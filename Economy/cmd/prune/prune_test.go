package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"Economy/ledger"
)

type testLedger struct {
	l   *ledger.Ledger
	seq int
}

func newTestLedger(t *testing.T) *testLedger {
	t.Helper()
	l, err := ledger.NewLedger(filepath.Join(t.TempDir(), "ledger.db"))
	if err != nil {
		t.Fatalf("NewLedger: %v", err)
	}
	t.Cleanup(func() { l.Close() })
	return &testLedger{l: l}
}

func (tl *testLedger) apply(t *testing.T, tfs ...ledger.Transfer) {
	t.Helper()
	ids := make([]ledger.TransferID, len(tfs))
	for i := range tfs {
		tl.seq++
		ids[i] = ledger.NewTransferID(uint64(tl.seq), "test")
	}
	if err := tl.l.Import(ids, tfs); err != nil {
		t.Fatalf("Import: %v", err)
	}
}

func mintOne(t *testing.T, tl *testLedger, user string, items ...ledger.CanOwnOne) {
	t.Helper()
	one := make(ledger.ItemsOne, len(items))
	for _, item := range items {
		one[item] = struct{}{}
	}
	tl.apply(t, ledger.Transfer{
		{Owner: ledger.User{Id: user}},
		{Items: ledger.Items{One: one}},
	})
}

func mintCurrency(t *testing.T, tl *testLedger, user string, qty ledger.Quantity) {
	t.Helper()
	tl.apply(t, ledger.Transfer{
		{Items: ledger.Items{Many: ledger.ItemsMany{ledger.Currency{Id: 0}: qty}}},
		{Owner: ledger.User{Id: user}},
	})
}

func moveOne(t *testing.T, tl *testLedger, from ledger.Owner, to ledger.Owner, item ledger.CanOwnOne) {
	t.Helper()
	tl.apply(t, ledger.Transfer{
		{Owner: from, Items: ledger.Items{One: ledger.ItemsOne{item: {}}}},
		{Owner: to},
	})
}

func moveMany(t *testing.T, tl *testLedger, from ledger.Owner, to ledger.Owner, item ledger.CanOwnMany, qty ledger.Quantity) {
	t.Helper()
	tl.apply(t, ledger.Transfer{
		{Owner: from, Items: ledger.Items{Many: ledger.ItemsMany{item: qty}}},
		{Owner: to},
	})
}

func fixturePlan(t *testing.T) (*testLedger, []dbAsset, *prunePlan) {
	t.Helper()
	tl := newTestLedger(t)
	const (
		userA = "userA"
		userB = "userB"

		retained     uint32 = 1000
		packageChild uint32 = 1001
		retainedTwo  uint32 = 1002
		hat          uint32 = 2000
		packageHat   uint32 = 2001
		pkg          uint32 = 3000
		imageAsset   uint32 = 4000
		limited      uint32 = 5000
	)

	mintCurrency(t, tl, userA, 100)
	mintCurrency(t, tl, userB, 50)
	mintOne(t, tl, userA, ledger.NewPlace(10))
	mintOne(t, tl, userB, ledger.NewGroup("group1"))

	mintOne(t, tl, userA,
		ledger.UnlimitedSource{Id: retained},
		ledger.UnlimitedSource{Id: packageChild},
		ledger.UnlimitedSource{Id: retainedTwo},
		ledger.UnlimitedSource{Id: hat},
		ledger.UnlimitedSource{Id: packageHat},
		ledger.UnlimitedSource{Id: imageAsset},
		ledger.LimitedSource{Id: limited},
		ledger.PackageSource{Id: pkg},
	)
	moveOne(t, tl, ledger.UnlimitedSource{Id: retained}, ledger.User{Id: userB}, ledger.UnlimitedAsset{Id: retained})
	moveOne(t, tl, ledger.UnlimitedSource{Id: retainedTwo}, ledger.User{Id: userB}, ledger.UnlimitedAsset{Id: retainedTwo})
	moveOne(t, tl, ledger.UnlimitedSource{Id: hat}, ledger.User{Id: userB}, ledger.UnlimitedAsset{Id: hat})
	moveOne(t, tl, ledger.UnlimitedSource{Id: imageAsset}, ledger.User{Id: userB}, ledger.UnlimitedAsset{Id: imageAsset})

	// Package contents are sources held by the package source.
	tl.apply(t, ledger.Transfer{
		{Owner: ledger.User{Id: userA}, Items: ledger.Items{One: ledger.ItemsOne{
			ledger.UnlimitedSource{Id: packageChild}: {},
			ledger.UnlimitedSource{Id: packageHat}:   {},
		}}},
		{Owner: ledger.PackageSource{Id: pkg}},
	})
	// The package itself and a child are sold to userB.
	moveOne(t, tl, ledger.PackageSource{Id: pkg}, ledger.User{Id: userB}, ledger.Package{Id: pkg})
	moveOne(t, tl, ledger.PackageSource{Id: pkg}, ledger.User{Id: userB}, ledger.UnlimitedAsset{Id: packageChild})
	// Currency held directly by the package source is burned with it.
	tl.apply(t, ledger.Transfer{
		{Items: ledger.Items{Many: ledger.ItemsMany{ledger.Currency{Id: 0}: 5}}},
		{Owner: ledger.PackageSource{Id: pkg}},
	})

	// Limited stock: two left, one sold.
	tl.apply(t, ledger.Transfer{
		{Items: ledger.Items{Many: ledger.ItemsMany{ledger.LimitedAsset{Id: limited}: 3}}},
		{Owner: ledger.LimitedSource{Id: limited}},
	})
	moveMany(t, tl, ledger.LimitedSource{Id: limited}, ledger.User{Id: userB}, ledger.LimitedAsset{Id: limited}, 1)

	assets := []dbAsset{
		{ID: retained, Type: 11, Name: "Retained shirt"},
		{ID: packageChild, Type: 11, Name: "Package shirt"},
		{ID: retainedTwo, Type: 11, Name: "Retained shirt two"},
		{ID: hat, Type: 8, Name: "Hat"},
		{ID: packageHat, Type: 8, Name: "Package hat"},
		{ID: pkg, Type: 32, Name: "Package"},
		{ID: imageAsset, Type: 1, Name: "Image"},
		{ID: limited, Type: 11, Name: "Limited shirt"},
	}
	removeTypes := map[int]struct{}{8: {}, 18: {}, 19: {}, 32: {}}
	plan, err := buildPlan(tl.l, assets, nil, removeTypes, false, func([]uint32) ([]uint32, error) {
		return []uint32{imageAsset}, nil
	})
	if err != nil {
		t.Fatalf("buildPlan: %v", err)
	}
	return tl, assets, plan
}

func TestPrunePlanRemovesPackagesAndChildren(t *testing.T) {
	_, _, plan := fixturePlan(t)

	for _, id := range []uint32{1001, 2000, 2001, 3000, 4000} {
		if _, ok := plan.removed[id]; !ok {
			t.Fatalf("expected asset %d to be removed", id)
		}
	}
	for _, id := range []uint32{1000, 1002, 5000} {
		if _, ok := plan.removed[id]; ok {
			t.Fatalf("expected asset %d to be retained", id)
		}
	}
	if _, ok := plan.sources[1001]; ok {
		t.Fatalf("package child source should not be retained")
	}
	if _, ok := plan.sources[1000]; !ok {
		t.Fatalf("retained source 1000 missing")
	}
	if plan.packageChildren != 2 {
		t.Fatalf("expected 2 package children, got %d", plan.packageChildren)
	}
	if plan.totalBalances() != 150 {
		t.Fatalf("expected 150 retained currency, got %d", plan.totalBalances())
	}
	if plan.totalPackageBurned() != 5 {
		t.Fatalf("expected 5 package currency burned, got %d", plan.totalPackageBurned())
	}
}

func TestPruneBuildsVerifiedLedger(t *testing.T) {
	_, _, plan := fixturePlan(t)
	out := filepath.Join(t.TempDir(), "pruned.db")
	l, err := ledger.NewLedger(out)
	if err != nil {
		t.Fatalf("NewLedger: %v", err)
	}
	p := newPlanner(l, 2)
	if err := p.plan(plan); err != nil {
		t.Fatalf("plan: %v", err)
	}
	if err := l.Close(); err != nil {
		t.Fatalf("close: %v", err)
	}
	if problems := verifyPlan(out, plan); len(problems) > 0 {
		t.Fatalf("verification failed: %v", problems)
	}

	check, err := ledger.NewLedger(out)
	if err != nil {
		t.Fatalf("reopen: %v", err)
	}
	defer check.Close()
	if !check.OwnsOne(ledger.User{Id: "userB"}, ledger.UnlimitedAsset{Id: 1000}) {
		t.Fatalf("retained asset 1000 missing")
	}
	if check.OwnsOne(ledger.User{Id: "userB"}, ledger.UnlimitedAsset{Id: 1001}) {
		t.Fatalf("package child asset 1001 should be gone")
	}
	if len(check.PackageItems()) != 0 {
		t.Fatalf("package items should be empty")
	}
	if got := check.OwnsMany(ledger.User{Id: "userB"}, ledger.LimitedAsset{Id: 5000}); got != 1 {
		t.Fatalf("expected 1 limited asset, got %d", got)
	}
	if got := check.Inventory(ledger.LimitedSource{Id: 5000}).Many[ledger.LimitedAsset{Id: 5000}]; got != 2 {
		t.Fatalf("expected 2 limited stock, got %d", got)
	}
}

func TestPruneDropsLedgerOrphans(t *testing.T) {
	tl := newTestLedger(t)
	mintCurrency(t, tl, "userA", 10)
	mintOne(t, tl, "userA", ledger.UnlimitedSource{Id: 99})
	assets := []dbAsset{{ID: 1, Type: 11, Name: "Known"}}
	removeTypes := map[int]struct{}{32: {}}
	if _, err := buildPlan(tl.l, assets, nil, removeTypes, false, nil); err == nil {
		t.Fatalf("expected an orphan error")
	}
	plan, err := buildPlan(tl.l, assets, nil, removeTypes, true, nil)
	if err != nil {
		t.Fatalf("buildPlan with drop-orphans: %v", err)
	}
	if _, ok := plan.removed[99]; !ok {
		t.Fatalf("expected orphan 99 to be removed")
	}
}

func TestCleanupSQLSkipsMissingTables(t *testing.T) {
	sql := cleanupSQL(map[string]bool{
		"asset":   true,
		"comment": true,
	})
	if strings.Contains(sql, "DELETE packageItem") {
		t.Fatalf("cleanup should not touch a missing packageItem table")
	}
	if !strings.Contains(sql, "DELETE asset WHERE record::id(id) IN $removedIds;") {
		t.Fatalf("cleanup should delete removed assets")
	}
	if !strings.Contains(sql, "COMMIT TRANSACTION;") {
		t.Fatalf("cleanup should commit")
	}
}

func TestDeleteFiles(t *testing.T) {
	dir := t.TempDir()
	assets := filepath.Join(dir, "assets")
	thumbs := filepath.Join(dir, "thumbnails")
	if err := os.MkdirAll(assets, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(thumbs, 0o755); err != nil {
		t.Fatal(err)
	}
	for _, path := range []string{
		filepath.Join(assets, "1"),
		filepath.Join(thumbs, "1"),
		filepath.Join(assets, "2"),
	} {
		if err := os.WriteFile(path, []byte("x"), 0o600); err != nil {
			t.Fatal(err)
		}
	}
	report := deleteFiles([]uint32{1, 2, 3}, assets, thumbs, false)
	if len(report.Deleted) != 3 {
		t.Fatalf("expected 3 deleted files, got %v", report.Deleted)
	}
	if len(report.Missing) != 3 {
		t.Fatalf("expected 3 missing files, got %v", report.Missing)
	}
	if len(report.Errors) != 0 {
		t.Fatalf("unexpected errors: %v", report.Errors)
	}
}

func TestPruneRemovesDatabasePackageChildren(t *testing.T) {
	tl, assets, _ := fixturePlan(t)
	removeTypes := map[int]struct{}{8: {}, 18: {}, 19: {}, 32: {}}
	plan, err := buildPlan(tl.l, assets, []dbPackageChild{{PackageID: 3000, ChildID: 1002}}, removeTypes, false, nil)
	if err != nil {
		t.Fatalf("buildPlan: %v", err)
	}
	if _, ok := plan.removed[1002]; !ok {
		t.Fatalf("expected database package child 1002 to be removed")
	}
}
