package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"Economy/ledger"
)

func TestParseOldLedger(t *testing.T) {
	path := filepath.Join(t.TempDir(), "legacy-ledger")
	content := `Mint {"To":"userA","Amount":10000000,"Note":"Stipend","Time":1,"Id":"a"}
Burn {"From":"userA","Amount":2500000,"Note":"Created asset","Link":"/catalog/1/x","Returns":{},"Time":2,"Id":"b"}
Transaction {"From":"userA","To":"userB","Amount":5000000,"Note":"Purchase","Link":"/catalog/1/x","Returns":{},"Time":3,"Id":"c"}
`
	if err := os.WriteFile(path, []byte(content), 0o600); err != nil {
		t.Fatal(err)
	}

	s := &legacySnapshot{
		BalancesMicro: make(map[string]uint64),
		DustMicro:     make(map[string]uint64),
		LastStipends:  make(map[string]uint64),
	}
	if err := parseOldLedger(path, s); err != nil {
		t.Fatalf("parseOldLedger: %v", err)
	}

	if got := s.BalancesMicro["userA"]; got != 2_500_000 {
		t.Fatalf("expected userA balance 2500000 micro, got %d", got)
	}
	if got := s.BalancesMicro["userB"]; got != 5_000_000 {
		t.Fatalf("expected userB balance 5000000 micro, got %d", got)
	}
	if got := s.DustMicro["userA"]; got != 500_000 {
		t.Fatalf("expected userA dust 500000, got %d", got)
	}
	if got := s.LastStipends["userA"]; got != 1 {
		t.Fatalf("expected last stipend 1, got %d", got)
	}
}

func TestParseOldLedgerRejectsReturns(t *testing.T) {
	path := filepath.Join(t.TempDir(), "legacy-ledger")
	content := `Transaction {"From":"userA","To":"userB","Amount":1000000,"Note":"swap","Link":"/","Returns":{"asset-1":1},"Time":1,"Id":"a"}
`
	if err := os.WriteFile(path, []byte(content), 0o600); err != nil {
		t.Fatal(err)
	}

	s := &legacySnapshot{
		BalancesMicro: make(map[string]uint64),
		DustMicro:     make(map[string]uint64),
		LastStipends:  make(map[string]uint64),
	}
	err := parseOldLedger(path, s)
	if err == nil || !strings.Contains(err.Error(), "returns") {
		t.Fatalf("expected unsupported returns error, got %v", err)
	}
}

func fixtureSnapshot() *legacySnapshot {
	return &legacySnapshot{
		Version:   2,
		OldLedger: "testdata/old-ledger",
		Users:     []string{"userA", "userB"},
		Assets: []legacyAsset{
			{ID: 1, Type: 8, Name: "Standalone"},
			{ID: 2, Type: 32, Name: "Package"},
			{ID: 3, Type: 8, Name: "Child"},
			{ID: 4, Type: 32, Name: "Nested Package"},
			{ID: 5, Type: 11, Name: "Nested Child"},
		},
		Creators: []legacyCreator{
			{AssetID: 1, UserID: "userA", Created: "2026-01-01T00:00:00Z"},
			{AssetID: 2, UserID: "userA", Created: "2026-01-01T00:00:00Z"},
			{AssetID: 3, UserID: "userA", Created: "2026-01-01T00:00:00Z"},
			{AssetID: 4, UserID: "userA", Created: "2026-01-01T00:00:00Z"},
			{AssetID: 5, UserID: "userA", Created: "2026-01-01T00:00:00Z"},
		},
		AssetOwners: []legacyAssetOwner{
			{AssetID: 1, UserID: "userB"},
			{AssetID: 2, UserID: "userB"},
			{AssetID: 3, UserID: "userB"},
			{AssetID: 4, UserID: "userB"},
			{AssetID: 5, UserID: "userB"},
		},
		PackageChildren: []legacyPackageChild{
			{PackageID: 2, ChildID: 3},
			{PackageID: 2, ChildID: 4},
			{PackageID: 4, ChildID: 5},
		},
		Places:      []legacyPlace{{ID: 10, Name: "Place"}},
		PlaceOwners: []legacyPlaceOwner{{PlaceID: 10, UserID: "userA"}},
		Groups:      []legacyGroup{{ID: "group1", Name: "Group"}},
		GroupOwners: []legacyGroupOwner{{GroupID: "group1", UserID: "userA"}},
		BalancesMicro: map[string]uint64{
			"userA": 50_000_000,
			"userB": 2_500_000,
		},
		DustMicro:    map[string]uint64{"userB": 500_000},
		LastStipends: map[string]uint64{},
	}
}

func TestMigrationFixture(t *testing.T) {
	s := fixtureSnapshot()
	data := buildMigrationData(s, "", false)
	if len(data.errors) > 0 {
		t.Fatalf("unexpected validation errors: %v", data.errors)
	}

	path := filepath.Join(t.TempDir(), "migrated.db")
	l, err := ledger.NewLedger(path)
	if err != nil {
		t.Fatalf("NewLedger: %v", err)
	}
	p := newPlanner(l, 3)
	if err := p.plan(data); err != nil {
		t.Fatalf("plan: %v", err)
	}
	if err := l.Close(); err != nil {
		t.Fatalf("close: %v", err)
	}

	problems := verifyLedger(path, data)
	if len(problems) > 0 {
		t.Fatalf("verification failed: %v", problems)
	}
}

func TestReadSnapshotRejectsOldVersion(t *testing.T) {
	path := filepath.Join(t.TempDir(), "snapshot.json")
	if err := os.WriteFile(path, []byte(`{"version":1}`), 0o600); err != nil {
		t.Fatal(err)
	}
	if _, err := readSnapshot(path); err == nil {
		t.Fatalf("expected an old snapshot version to be rejected")
	}
}

func TestMigrationRejectsMultiplePackageParents(t *testing.T) {
	s := fixtureSnapshot()
	s.PackageChildren = append(s.PackageChildren, legacyPackageChild{PackageID: 4, ChildID: 3})
	data := buildMigrationData(s, "", false)
	if len(data.errors) == 0 {
		t.Fatalf("expected a multiple-package-parent error")
	}
	found := false
	for _, err := range data.errors {
		if strings.Contains(err, "multiple packages") {
			found = true
		}
	}
	if !found {
		t.Fatalf("expected multiple-package-parent error, got %v", data.errors)
	}
}

func TestMigrationRejectsMissingUser(t *testing.T) {
	s := fixtureSnapshot()
	s.Users = []string{"userA"}
	data := buildMigrationData(s, "", false)
	if len(data.errors) == 0 {
		t.Fatalf("expected missing-user errors")
	}

	found := false
	for _, err := range data.errors {
		if strings.Contains(err, "missing user userB") {
			found = true
		}
	}
	if !found {
		t.Fatalf("expected missing user error, got %v", data.errors)
	}
}

func TestMigrationSkipsMissingUser(t *testing.T) {
	s := fixtureSnapshot()
	s.Users = []string{"userA"}
	data := buildMigrationData(s, "", true)
	if len(data.errors) > 0 {
		t.Fatalf("unexpected validation errors: %v", data.errors)
	}
	if _, ok := data.balancesMicro["userB"]; ok {
		t.Fatalf("expected the missing user's balance to be skipped")
	}
	if len(data.owners) != 0 {
		t.Fatalf("expected the missing user's asset ownership to be skipped")
	}
}

func TestMigrationRejectsUnknownFallbackUser(t *testing.T) {
	s := fixtureSnapshot()
	data := buildMigrationData(s, "missing", true)
	if len(data.errors) == 0 {
		t.Fatalf("expected an unknown fallback user error")
	}
}

func TestMigrationSkipsPackageOrphans(t *testing.T) {
	s := fixtureSnapshot()
	s.PackageChildren = append(s.PackageChildren,
		legacyPackageChild{PackageID: 999, ChildID: 3},
		legacyPackageChild{PackageID: 2, ChildID: 999},
	)
	data := buildMigrationData(s, "", true)
	if len(data.errors) > 0 {
		t.Fatalf("unexpected validation errors: %v", data.errors)
	}

	found := 0
	for _, warning := range data.warnings {
		if strings.Contains(warning, "missing") {
			found++
		}
	}
	if found < 2 {
		t.Fatalf("expected missing package and asset warnings, got %v", data.warnings)
	}
}
