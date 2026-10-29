package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"Economy/ledger"
)

type options struct {
	input        string
	export       string
	oldLedger    string
	out          string
	report       string
	surrealURL   string
	namespace    string
	database     string
	surrealUser  string
	surrealPass  string
	fallbackUser string
	skipOrphans  bool
	dryRun       bool
	force        bool
	batchSize    int
}

type report struct {
	Version      int            `json:"version"`
	StartedAt    time.Time      `json:"startedAt"`
	FinishedAt   time.Time      `json:"finishedAt"`
	DryRun       bool           `json:"dryRun"`
	Snapshot     string         `json:"snapshot,omitempty"`
	OldLedger    string         `json:"oldLedger,omitempty"`
	OutputLedger string         `json:"outputLedger,omitempty"`
	Counts       map[string]int `json:"counts"`
	Balances     balanceReport  `json:"balances"`
	Warnings     []string       `json:"warnings,omitempty"`
	Errors       []string       `json:"errors,omitempty"`
	Verification []string       `json:"verification,omitempty"`
}

type balanceReport struct {
	Users      int    `json:"users"`
	TotalUnits uint64 `json:"totalUnits"`
	DustUsers  int    `json:"dustUsers"`
	DustTotal  uint64 `json:"dustTotalMicro"`
}

func main() {
	var o options
	flag.StringVar(&o.input, "input", "", "read a legacy snapshot JSON instead of querying SurrealDB")
	flag.StringVar(&o.export, "export", "", "write a legacy snapshot JSON and exit")
	flag.StringVar(&o.oldLedger, "old-ledger", "../data/economy/ledger", "path to the old JSONL economy ledger")
	flag.StringVar(&o.out, "out", "", "path for the new bbolt ledger")
	flag.StringVar(&o.report, "report", "migration-report.json", "path for the migration report")
	flag.StringVar(&o.surrealURL, "surreal", "http://localhost:8000", "SurrealDB HTTP endpoint")
	flag.StringVar(&o.namespace, "namespace", "main", "SurrealDB namespace")
	flag.StringVar(&o.database, "database", "main", "SurrealDB database")
	flag.StringVar(&o.surrealUser, "surreal-user", "root", "SurrealDB username")
	flag.StringVar(&o.surrealPass, "surreal-pass", "root", "SurrealDB password")
	flag.StringVar(&o.fallbackUser, "fallback-user", "", "user ID to assign to otherwise unowned assets/places/groups")
	flag.BoolVar(&o.skipOrphans, "skip-orphans", false, "ignore creator/owner/package relations that point to missing records, and balances for missing users")
	flag.BoolVar(&o.dryRun, "dry-run", false, "validate and build a temporary ledger without writing the output")
	flag.BoolVar(&o.force, "force", false, "overwrite the output ledger if it exists")
	flag.IntVar(&o.batchSize, "batch-size", 500, "transfers per bbolt import batch")
	flag.Parse()

	rep := &report{
		Version:   1,
		StartedAt: time.Now().UTC(),
		DryRun:    o.dryRun,
		Counts:    make(map[string]int),
	}

	var err error
	if o.export != "" {
		err = runExport(o, rep)
	} else {
		err = runMigrate(o, rep)
	}

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
		fmt.Fprintf(os.Stderr, "migration failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("migration report: %s\n", o.report)
	if !o.dryRun && o.out != "" {
		fmt.Printf("new ledger: %s\n", o.out)
	}
}

func runExport(o options, rep *report) error {
	if o.oldLedger == "" {
		return fmt.Errorf("--old-ledger is required for export")
	}
	c, err := newSurrealClient(o.surrealURL, o.namespace, o.database, o.surrealUser, o.surrealPass)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	defer c.Close()

	s, err := exportSnapshot(c, o.oldLedger)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	if err := writeJSON(o.export, s); err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}
	rep.Snapshot = o.export
	rep.OldLedger = o.oldLedger
	rep.Warnings = append(rep.Warnings, s.Warnings...)
	rep.Counts["users"] = len(s.Users)
	rep.Counts["assets"] = len(s.Assets)
	rep.Counts["creators"] = len(s.Creators)
	rep.Counts["assetOwners"] = len(s.AssetOwners)
	rep.Counts["packageChildren"] = len(s.PackageChildren)
	rep.Counts["places"] = len(s.Places)
	rep.Counts["groups"] = len(s.Groups)
	rep.Balances = summarizeBalances(s.BalancesMicro, s.DustMicro)
	fmt.Printf("wrote legacy snapshot %s\n", o.export)
	return nil
}

func runMigrate(o options, rep *report) error {
	var s *legacySnapshot
	var err error
	if o.input != "" {
		s, err = readSnapshot(o.input)
		if err != nil {
			rep.Errors = append(rep.Errors, err.Error())
			return err
		}
		rep.Snapshot = o.input
	} else {
		if o.oldLedger == "" {
			return fmt.Errorf("--old-ledger is required when not using --input")
		}
		c, connectErr := newSurrealClient(o.surrealURL, o.namespace, o.database, o.surrealUser, o.surrealPass)
		if connectErr != nil {
			rep.Errors = append(rep.Errors, connectErr.Error())
			return connectErr
		}
		defer c.Close()

		s, err = exportSnapshot(c, o.oldLedger)
		if err != nil {
			rep.Errors = append(rep.Errors, err.Error())
			return err
		}
	}

	rep.OldLedger = s.OldLedger
	if len(s.BalancesMicro) > 0 {
		rep.Warnings = append(rep.Warnings, "currency snapshot mints reset every migrated user's stipend cooldown to the migration timestamp")
	}
	if s.OldLedger != "" {
		rep.Warnings = append(rep.Warnings, fmt.Sprintf("old ledger left in place at %s; keep it as the migration archive", s.OldLedger))
	}

	data := buildMigrationData(s, o.fallbackUser, o.skipOrphans)
	rep.Balances = summarizeBalances(data.balancesMicro, data.dust)
	rep.Warnings = append(rep.Warnings, data.warnings...)
	rep.Errors = append(rep.Errors, data.errors...)
	rep.Counts["assets"] = len(data.assets)
	rep.Counts["places"] = len(data.places)
	rep.Counts["groups"] = len(data.groups)
	rep.Counts["balanceUsers"] = len(data.balancesMicro)
	rep.Counts["assetOwnerships"] = countOwners(data.owners)
	rep.Counts["placeOwnerships"] = countOwners(data.placeOwners)
	rep.Counts["groupOwnerships"] = countOwners(data.groupOwners)

	if len(data.errors) > 0 {
		return fmt.Errorf("migration blocked by %d validation errors", len(data.errors))
	}
	if _, err := data.packageOrder(); err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return err
	}

	out := o.out
	removeOut := false
	if o.dryRun {
		f, err := os.CreateTemp("", "economy-migration-*.db")
		if err != nil {
			rep.Errors = append(rep.Errors, err.Error())
			return err
		}
		out = f.Name()
		f.Close()
		os.Remove(out)
		removeOut = true
	} else {
		if o.out == "" {
			return fmt.Errorf("--out is required unless --dry-run or --export is used")
		}
		if _, err := os.Stat(o.out); err == nil {
			if !o.force {
				return fmt.Errorf("output ledger %s already exists (use --force to replace it)", o.out)
			}
			if err := os.Remove(o.out); err != nil {
				return fmt.Errorf("remove existing output: %w", err)
			}
		}
	}

	l, err := ledger.NewLedger(out)
	if err != nil {
		rep.Errors = append(rep.Errors, err.Error())
		return fmt.Errorf("create output ledger: %w", err)
	}

	planner := newPlanner(l, o.batchSize)
	planErr := planner.plan(data)
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
	for category, count := range planner.counts {
		rep.Counts[category] = count
	}
	transfers := totalCount(planner.counts)
	rep.Counts["transfers"] = transfers

	verification := verifyLedger(out, data)
	rep.Verification = verification
	if len(verification) > 0 {
		rep.Errors = append(rep.Errors, verification...)
		os.Remove(out)
		return fmt.Errorf("migration verification failed with %d errors", len(verification))
	}

	if removeOut {
		os.Remove(out)
		fmt.Println("dry run passed verification; no ledger was written")
	} else {
		rep.OutputLedger = out
		fmt.Printf("wrote migrated ledger %s (%d transfers)\n", out, transfers)
	}
	return nil
}

func summarizeBalances(micro, dust map[string]uint64) balanceReport {
	var r balanceReport
	for _, amount := range micro {
		r.Users++
		r.TotalUnits += amount / microPerUnit
	}
	for _, amount := range dust {
		r.DustUsers++
		r.DustTotal += amount
	}
	return r
}

func countOwners[K comparable](m map[K]map[string]struct{}) int {
	n := 0
	for _, owners := range m {
		n += len(owners)
	}
	return n
}

func totalCount(counts map[string]int) int {
	n := 0
	for _, count := range counts {
		n += count
	}
	return n
}
