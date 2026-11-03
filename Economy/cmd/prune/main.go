package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"time"

	sdb "Economy/internal/surreal"
	"Economy/ledger"
)

type options struct {
	db, out, report, surrealURL, namespace, database, surrealUser, surrealPass, removeTypes, assetsDir, thumbnailsDir string
	dryRun, force, skipLedger, skipSite, skipFiles, dropOrphans, keepOrphans                                          bool
	batchSize                                                                                                         int
}

func main() {
	var o options
	flag.StringVar(&o.db, "db", "mydb.db", "path to the current ledger database")
	flag.StringVar(&o.out, "out", "", "path for the pruned ledger database")
	flag.StringVar(&o.report, "report", "prune-report.json", "path for the JSON report")
	flag.StringVar(&o.surrealURL, "surreal", "http://localhost:8000", "SurrealDB HTTP endpoint")
	flag.StringVar(&o.namespace, "namespace", "main", "SurrealDB namespace")
	flag.StringVar(&o.database, "database", "main", "SurrealDB database")
	flag.StringVar(&o.surrealUser, "surreal-user", "root", "SurrealDB username")
	flag.StringVar(&o.surrealPass, "surreal-pass", "root", "SurrealDB password")
	flag.StringVar(&o.removeTypes, "remove-types", "8,18,19,32", "comma-separated asset types to remove; packages (32) are always removed")
	flag.StringVar(&o.assetsDir, "assets-dir", "../data/assets", "asset file directory")
	flag.StringVar(&o.thumbnailsDir, "thumbnails-dir", "../data/thumbnails", "thumbnail file directory")
	flag.BoolVar(&o.dryRun, "dry-run", false, "build a temporary ledger and report database/file changes without applying them")
	flag.BoolVar(&o.force, "force", false, "overwrite an existing output ledger")
	flag.BoolVar(&o.skipLedger, "skip-ledger", false, "do not build a pruned ledger")
	flag.BoolVar(&o.skipSite, "skip-site", false, "do not run the SurrealDB cleanup or delete files")
	flag.BoolVar(&o.skipFiles, "skip-files", false, "delete database rows but keep asset files")
	flag.BoolVar(&o.dropOrphans, "drop-orphans", false, "drop ledger items whose asset is missing from SurrealDB")
	flag.BoolVar(&o.keepOrphans, "keep-orphan-images", false, "keep image assets that are only linked to removed assets")
	flag.IntVar(&o.batchSize, "batch-size", 500, "transfers per ledger import batch")
	flag.Parse()

	removeTypes, err := parseTypes(o.removeTypes)
	if err != nil {
		fail(err)
	}
	removeTypes[32] = struct{}{}

	if o.skipLedger && o.skipSite {
		fail(fmt.Errorf("--skip-ledger and --skip-site leave nothing to do"))
	}
	if o.batchSize <= 0 {
		fail(fmt.Errorf("--batch-size must be positive"))
	}
	if !o.dryRun && !o.skipLedger {
		if o.out == "" {
			fail(fmt.Errorf("--out is required unless --dry-run or --skip-ledger is used"))
		}
		dbAbs, err := filepath.Abs(o.db)
		if err != nil {
			fail(err)
		}
		outAbs, err := filepath.Abs(o.out)
		if err != nil {
			fail(err)
		}
		if dbAbs == outAbs {
			fail(fmt.Errorf("--out must be a new ledger, not the current ledger"))
		}
		if _, err := os.Stat(o.out); err == nil && !o.force {
			fail(fmt.Errorf("output ledger %s already exists (use --force to replace it)", o.out))
		}
	}
	if o.skipSite {
		o.skipFiles = true
	}

	rep := &report{
		Version:     1,
		StartedAt:   time.Now().UTC(),
		DryRun:      o.dryRun,
		LedgerPath:  o.db,
		RemoveTypes: sortedInts(removeTypes),
		Counts:      make(map[string]int),
		Ledger:      ledgerReport{Counts: make(map[string]int)},
	}

	err = run(o, removeTypes, rep)
	rep.FinishedAt = time.Now().UTC()
	if o.report != "" {
		if reportErr := writeJSON(o.report, rep); reportErr != nil {
			fmt.Fprintf(os.Stderr, "write report: %v\n", reportErr)
		}
	}

	for _, warning := range rep.Warnings {
		fmt.Fprintf(os.Stderr, "warning: %s\n", warning)
	}
	for _, reportErr := range rep.Errors {
		fmt.Fprintf(os.Stderr, "error: %s\n", reportErr)
	}
	if err != nil {
		fmt.Fprintf(os.Stderr, "prune failed: %v\n", err)
		os.Exit(1)
	}

	printSummary(rep, o)
}

func run(o options, removeTypes map[int]struct{}, rep *report) error {
	client, err := sdb.New(o.surrealURL, o.namespace, o.database, o.surrealUser, o.surrealPass)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	defer client.Close()

	tables, err := loadTables(client)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	assets, err := loadAssets(client)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	packageChildren, err := loadPackageChildren(client, tables)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}

	led, err := ledger.NewLedgerWithTimeout(o.db, 10*time.Second)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return fmt.Errorf("open ledger: %w", err)
	}
	defer led.Close()

	var orphanImagesFn func([]uint32) ([]uint32, error)
	if !o.skipSite && !o.keepOrphans {
		orphanImagesFn = func(primary []uint32) ([]uint32, error) {
			return loadOrphanImages(client, tables, primary)
		}
	}

	plan, err := buildPlan(led, assets, packageChildren, removeTypes, o.dropOrphans, orphanImagesFn)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	rep.Warnings = append(rep.Warnings, plan.warnings...)
	rep.OrphanImages = plan.orphanImages
	rep.Counts["removed"] = len(plan.removed)
	rep.Counts["packageChildren"] = plan.packageChildren
	rep.Counts["retainedAssets"] = plan.retainedAssets
	rep.Counts["sources"] = len(plan.sources)
	rep.Counts["itemsOne"] = len(plan.itemsOne)
	rep.Counts["itemsMany"] = len(plan.itemsMany)
	for id := range plan.removed {
		asset := plan.removed[id]
		rep.Removed = append(rep.Removed, asset)
	}
	sort.Slice(rep.Removed, func(i, j int) bool { return rep.Removed[i].ID < rep.Removed[j].ID })
	if len(plan.removed) == 0 {
		rep.Warnings = append(rep.Warnings, "no matching assets found; nothing to prune")
		return nil
	}

	rep.Ledger.BalancesBefore = plan.totalBalances() + plan.totalBurned()
	rep.Ledger.BalancesAfter = plan.totalBalances()
	rep.Ledger.SourceCurrencyMoved = plan.totalMoved()
	rep.Ledger.PackageCurrencyBurned = plan.totalPackageBurned()

	if !o.skipLedger {
		out := o.out
		removeOut := false
		if o.dryRun {
			f, err := os.CreateTemp("", "economy-prune-*.db")
			if err != nil {
				rep.Errors = append(rep.Errors, err.Error())
				return err
			}
			out = f.Name()
			f.Close()
			os.Remove(out)
			removeOut = true
		} else {
			if err := os.Remove(out); err != nil && !os.IsNotExist(err) {
				rep.Errors = append(rep.Errors, err.Error())
				return fmt.Errorf("remove existing output: %w", err)
			}
		}

		l, err := ledger.NewLedger(out)
		if err != nil {
			rep.Errors = append(rep.Errors, err.Error())
			return fmt.Errorf("create pruned ledger: %w", err)
		}
		p := newPlanner(l, o.batchSize)
		planErr := p.plan(plan)
		closeErr := l.Close()
		if planErr != nil {
			os.Remove(out)
			rep.Errors = append(rep.Errors, planErr.Error())
			return planErr
		}
		if closeErr != nil {
			os.Remove(out)
			rep.Errors = append(rep.Errors, closeErr.Error())
			return closeErr
		}
		for category, count := range p.counts {
			rep.Ledger.Counts[category] = count
		}
		rep.Ledger.Transfers = totalCount(p.counts)
		verification := verifyPlan(out, plan)
		rep.Verification = verification
		if len(verification) > 0 {
			os.Remove(out)
			rep.Errors = append(rep.Errors, verification...)
			return fmt.Errorf("pruned ledger verification failed with %d errors", len(verification))
		}
		if removeOut {
			os.Remove(out)
			fmt.Println("pruned ledger passed verification; no ledger was written")
		} else {
			rep.OutputLedger = out
			fmt.Printf("wrote pruned ledger %s (%d transfers)\n", out, rep.Ledger.Transfers)
		}
	}

	if o.skipSite {
		rep.Site.Skipped = true
		rep.Files.Skipped = true
		return nil
	}

	removedIDs := plan.removedIDs()
	removedIDStrings := plan.removedIDStrings()
	commentIDs, err := loadCommentIDs(client, removedIDs, removedIDStrings)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}

	before, err := siteCounts(client, tables, removedIDs, removedIDStrings, commentIDs, plan.orphanImages)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	rep.Site.Before = before

	if o.dryRun {
		rep.Files = deleteFiles(removedIDs, o.assetsDir, o.thumbnailsDir, true)
		return nil
	}

	if err := applySite(client, tables, removedIDs, removedIDStrings, commentIDs, plan.orphanImages); err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return fmt.Errorf("apply SurrealDB cleanup: %w", err)
	}
	rep.Site.Committed = true

	after, err := siteCounts(client, tables, removedIDs, removedIDStrings, commentIDs, plan.orphanImages)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	rep.Site.After = after

	if o.skipFiles {
		rep.Files.Skipped = true
		return nil
	}
	rep.Files = deleteFiles(removedIDs, o.assetsDir, o.thumbnailsDir, false)
	if len(rep.Files.Errors) > 0 {
		return fmt.Errorf("database cleanup committed, but some files could not be removed")
	}
	return nil
}

func parseTypes(value string) (map[int]struct{}, error) {
	out := make(map[int]struct{})
	for _, part := range strings.Split(value, ",") {
		part = strings.TrimSpace(part)
		if part == "" {
			continue
		}
		n, err := strconv.Atoi(part)
		if err != nil {
			return nil, fmt.Errorf("invalid asset type %q: %w", part, err)
		}
		out[n] = struct{}{}
	}
	if len(out) == 0 {
		return nil, fmt.Errorf("--remove-types must contain at least one type")
	}
	return out, nil
}

func sortedInts(set map[int]struct{}) []int {
	out := make([]int, 0, len(set))
	for n := range set {
		out = append(out, n)
	}
	sort.Ints(out)
	return out
}

func totalCount(counts map[string]int) int {
	var total int
	for _, count := range counts {
		total += count
	}
	return total
}

func writeJSON(path string, v any) error {
	data, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return err
	}
	data = append(data, '\n')
	return os.WriteFile(path, data, 0o600)
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(2)
}

func countReason(assets []removedAsset, reason string) int {
	n := 0
	for _, asset := range assets {
		if asset.Reason == reason {
			n++
		}
	}
	return n
}

func printSummary(rep *report, o options) {
	fmt.Printf("removed %d assets (%d packages, %d package children, %d orphan images)\n",
		rep.Counts["removed"], countReason(rep.Removed, "package"), rep.Counts["packageChildren"], len(rep.OrphanImages))
	fmt.Printf("retained %d assets; ledger balances %d -> %d (burned %d, moved %d)\n",
		rep.Counts["retainedAssets"], rep.Ledger.BalancesBefore, rep.Ledger.BalancesAfter,
		rep.Ledger.PackageCurrencyBurned, rep.Ledger.SourceCurrencyMoved)
	if rep.Ledger.Transfers > 0 {
		fmt.Printf("pruned ledger: %d transfers\n", rep.Ledger.Transfers)
	}
	if rep.Site.Committed {
		if rep.Files.Skipped {
			fmt.Println("site cleanup committed; files skipped")
		} else {
			fmt.Printf("site cleanup committed; files deleted %d, missing %d\n", len(rep.Files.Deleted), len(rep.Files.Missing))
		}
	} else if rep.DryRun {
		fmt.Printf("dry run: %d files would be deleted, %d missing\n", len(rep.Files.Planned), len(rep.Files.Missing))
	}
	if o.report != "" {
		fmt.Printf("report: %s\n", o.report)
	}
}
