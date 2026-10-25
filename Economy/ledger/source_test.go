package ledger_test

import (
	"testing"

	. "Economy/ledger"
)

func TestUnissuedUnlimitedSourceCannotMint(t *testing.T) {
	_, e := newTestEconomy(t)

	buyer := User{"buyer"}
	fund(t, e, buyer)

	before := e.Balance(buyer)
	beforeHistory, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	// this source was never created through the Economy service, so nobody owns it
	src := UnlimitedSource{Id: 987654321}
	asset, _, err := e.BuyUnlimitedAsset(buyer, src, 10)
	if err == nil {
		t.Fatalf("expected an unissued source to be rejected")
	}
	if e.OwnsOne(buyer, asset) {
		t.Fatalf("expected the buyer not to receive %v", asset)
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

func TestUnissuedPackageSourceCannotMint(t *testing.T) {
	_, e := newTestEconomy(t)

	buyer := User{"buyer"}
	fund(t, e, buyer)

	before := e.Balance(buyer)
	beforeHistory, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	// this package source was never created through the Economy service, so nobody owns it
	src := PackageSource{Id: 987654322}
	pkg, _, err := e.BuyPackage(buyer, src, 10)
	if err == nil {
		t.Fatalf("expected an unissued package source to be rejected")
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

// a real source must still be able to issue its asset after the ownership check
func TestIssuedUnlimitedSourceCanMint(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	src, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	before := e.Balance(creator)
	if _, _, err := e.BuyUnlimitedAsset(buyer, src, 10); err != nil {
		t.Fatalf("BuyUnlimitedAsset: %v", err)
	}

	if !e.OwnsOne(buyer, src.Create()) {
		t.Fatalf("expected %v to own %v", buyer, src.Create())
	}
	if got := e.Balance(creator); got != before+10 {
		t.Fatalf("expected the creator to be paid 10, balance went %d -> %d", before, got)
	}
}
