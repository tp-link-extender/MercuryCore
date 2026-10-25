package ledger_test

import (
	"testing"
	"time"

	. "Economy/ledger"
)

func newFreeEconomy(t *testing.T) *Economy {
	t.Helper()

	l, err := NewLedger(t.TempDir() + "/free.db")
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	t.Cleanup(func() { l.Close() })

	return NewEconomy(l, 0, 0, 0, 0, 0, 10, time.Hour*12)
}

func TestBuyFreeUnlimitedAsset(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator)

	src, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	before := e.Balance(creator)

	if _, _, err := e.BuyUnlimitedAsset(buyer, src, 0); err != nil {
		t.Fatalf("BuyUnlimitedAsset: %v", err)
	}

	if !e.OwnsOne(buyer, src.Create()) {
		t.Fatalf("expected %v to own %v", buyer, src.Create())
	}
	if got := e.Balance(buyer); got != 0 {
		t.Fatalf("expected a free purchase to cost the buyer nothing, got balance %d", got)
	}
	if got := e.Balance(creator); got != before {
		t.Fatalf("expected a free purchase to pay the creator nothing, balance went %d -> %d", before, got)
	}
}

func TestBuyFreeLimitedAsset(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator)

	src, _, err := e.CreateLimitedSource(creator, 2)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	before := e.Balance(creator)

	if _, _, err := e.BuyLimitedAsset(buyer, src, 0, 1); err != nil {
		t.Fatalf("BuyLimitedAsset: %v", err)
	}

	if got := e.OwnsMany(buyer, src.Create()); got != 1 {
		t.Fatalf("expected %v to own 1 %v, got %d", buyer, src.Create(), got)
	}
	if got := e.OwnersMany(src.Create())[src]; got != 1 {
		t.Fatalf("expected the source to have 1 stock left, got %d", got)
	}
	if got := e.Balance(buyer); got != 0 {
		t.Fatalf("expected a free purchase to cost the buyer nothing, got balance %d", got)
	}
	if got := e.Balance(creator); got != before {
		t.Fatalf("expected a free purchase to pay the creator nothing, balance went %d -> %d", before, got)
	}
}

func TestBuyFreePackage(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator)

	comps := make([]UnlimitedSource, 2)
	sources := make([]PackageComponent, 2)
	for i := range comps {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		comps[i] = c
		sources[i] = c
	}

	pkgSrc, _, err := e.CreatePackageSource(creator, sources)
	if err != nil {
		t.Fatalf("CreatePackageSource: %v", err)
	}

	before := e.Balance(creator)

	if _, _, err := e.BuyPackage(buyer, pkgSrc, 0); err != nil {
		t.Fatalf("BuyPackage: %v", err)
	}

	if !e.OwnsOne(buyer, pkgSrc.Create()) {
		t.Fatalf("expected %v to own the package", buyer)
	}
	for _, c := range comps {
		if !e.OwnsOne(buyer, c.Create()) {
			t.Fatalf("expected %v to own %v", buyer, c.Create())
		}
	}
	if got := e.Balance(buyer); got != 0 {
		t.Fatalf("expected a free package to cost the buyer nothing, got balance %d", got)
	}
	if got := e.Balance(creator); got != before {
		t.Fatalf("expected a free package to pay the creator nothing, balance went %d -> %d", before, got)
	}
}

func TestZeroPriceCreations(t *testing.T) {
	e := newFreeEconomy(t)

	user := User{"user"}

	unlimited, _, err := e.CreateUnlimitedSource(user)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}
	if !e.OwnsOne(user, unlimited) {
		t.Fatalf("expected %v to own %v", user, unlimited)
	}

	const stock = 3
	limited, _, err := e.CreateLimitedSource(user, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}
	if !e.OwnsOne(user, limited) {
		t.Fatalf("expected %v to own %v", user, limited)
	}
	if got := e.OwnersMany(limited.Create())[limited]; got != stock {
		t.Fatalf("expected %v to be stocked with %d, got %d", limited, stock, got)
	}

	if _, _, err := e.CreatePlace(user); err != nil {
		t.Fatalf("CreatePlace: %v", err)
	}
	if _, _, err := e.CreateGroup(user); err != nil {
		t.Fatalf("CreateGroup: %v", err)
	}

	pkg, _, err := e.CreatePackageSource(user, []PackageComponent{unlimited})
	if err != nil {
		t.Fatalf("CreatePackageSource: %v", err)
	}
	if !e.OwnsOne(user, pkg) {
		t.Fatalf("expected %v to own %v", user, pkg)
	}
	if !e.OwnsOne(pkg, unlimited) {
		t.Fatalf("expected %v to hold %v", pkg, unlimited)
	}
	if got := e.Balance(user); got != 0 {
		t.Fatalf("expected zero-price creations to cost nothing, got balance %d", got)
	}
}
