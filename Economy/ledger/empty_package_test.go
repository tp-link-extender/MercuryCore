package ledger_test

import (
	"testing"

	. "Economy/ledger"
)

// mintEmptyPackageSource mints a package source with no components, which the public creation API rejects.
// This is the shape left behind by old failed creations and by direct ledger use.
func mintEmptyPackageSource(t *testing.T, l *Ledger, owner User) PackageSource {
	t.Helper()

	src := RandPackageSource()
	tid := MakeTransferID()
	if err := l.Transfer(tid, Transfer{
		{Owner: owner},
		{Items: Items{One: ItemsOne{src: {}}}},
	}); err != nil {
		t.Fatalf("mint empty package source: %v", err)
	}

	return src
}

func TestBuyEmptyPackageRejected(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, buyer)

	empty := mintEmptyPackageSource(t, l, creator)
	if !e.OwnsOne(creator, empty) {
		t.Fatalf("expected %v to own the empty package source", creator)
	}

	before := e.Balance(buyer)
	beforeHistory, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	pkg, _, err := e.BuyPackage(buyer, empty, 10)
	if err != ErrEmptyPackage {
		t.Fatalf("expected ErrEmptyPackage, got %v", err)
	}
	if e.OwnsOne(buyer, pkg) {
		t.Fatalf("expected the buyer not to receive %v", pkg)
	}
	if got := e.Balance(buyer); got != before {
		t.Fatalf("expected a rejected purchase to cost nothing, balance went %d -> %d", before, got)
	}

	afterHistory, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}
	if len(afterHistory) != len(beforeHistory) {
		t.Fatalf("expected a rejected purchase to write no transfers, history went %d -> %d", len(beforeHistory), len(afterHistory))
	}
}

// a package containing only an empty package is still empty: it hands over package items but no assets.
func TestBuyPackageOfOnlyEmptyPackagesRejected(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	inner := mintEmptyPackageSource(t, l, creator)

	outer, _, err := e.CreatePackageSource(creator, []PackageComponent{inner})
	if err != nil {
		t.Fatalf("CreatePackageSource: %v", err)
	}
	if !e.OwnsOne(outer, inner) {
		t.Fatalf("expected %v to hold %v", outer, inner)
	}

	before := e.Balance(buyer)
	beforeHistory, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	pkg, _, err := e.BuyPackage(buyer, outer, 10)
	if err != ErrEmptyPackage {
		t.Fatalf("expected ErrEmptyPackage, got %v", err)
	}
	if e.OwnsOne(buyer, pkg) || e.OwnsOne(buyer, inner.Create()) {
		t.Fatalf("expected the buyer not to receive the package or its empty nested package")
	}
	if got := e.Balance(buyer); got != before {
		t.Fatalf("expected a rejected purchase to cost nothing, balance went %d -> %d", before, got)
	}

	afterHistory, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}
	if len(afterHistory) != len(beforeHistory) {
		t.Fatalf("expected a rejected purchase to write no transfers, history went %d -> %d", len(beforeHistory), len(afterHistory))
	}
}

// filling an otherwise empty package later must make it sellable again
func TestEmptyPackageBecomesSellableAfterAddingComponent(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	pkgSrc := mintEmptyPackageSource(t, l, creator)
	if _, _, err := e.BuyPackage(buyer, pkgSrc, 10); err != ErrEmptyPackage {
		t.Fatalf("expected initially empty package to be rejected, got %v", err)
	}

	comp, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}
	if _, err := e.AddPackageComponents(creator, pkgSrc, []PackageComponent{comp}); err != nil {
		t.Fatalf("AddPackageComponents: %v", err)
	}

	if _, _, err := e.BuyPackage(buyer, pkgSrc, 10); err != nil {
		t.Fatalf("expected the filled package to sell, got %v", err)
	}
	if !e.OwnsOne(buyer, comp.Create()) {
		t.Fatalf("expected the buyer to receive %v", comp.Create())
	}
}
