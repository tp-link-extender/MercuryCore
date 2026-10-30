package ledger_test

import (
	"testing"

	. "Economy/ledger"
)

func TestNewPlaceAndGroupExactIDs(t *testing.T) {
	place := NewPlace(42)
	if place.ID() != 42 {
		t.Fatalf("expected place id 42, got %d", place.ID())
	}

	group := NewGroup("group-id")
	if group.ID() != "group-id" {
		t.Fatalf("expected group id group-id, got %q", group.ID())
	}
}

func TestImportAllowsStipendAndDependencies(t *testing.T) {
	name := t.TempDir() + "/import.db"
	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}

	creator := User{Id: "creator"}
	owner := User{Id: "owner"}
	src := UnlimitedSource{Id: 123}

	// The source mint and the asset issue are dependent, and the currency mint is stipend-shaped.
	transfers := []Transfer{
		{
			{Owner: creator},
			{
				Items: Items{
					One: ItemsOne{src: {}},
				},
			},
		},
		{
			{
				Owner: src,
				Items: Items{
					One: ItemsOne{src.Create(): {}},
				},
			},
			{Owner: owner},
		},
		{
			{Owner: owner},
			{
				Items: Items{
					Many: ItemsMany{Currency{Id: 0}: 10},
				},
			},
		},
	}
	tids := []TransferID{
		NewTransferID(1, "migrate-1"),
		NewTransferID(2, "migrate-2"),
		NewTransferID(3, "migrate-3"),
	}
	if err := l.Import(tids, transfers); err != nil {
		t.Fatalf("Import: %v", err)
	}
	if !l.OwnsOne(creator, src) {
		t.Fatalf("expected creator to own the source")
	}
	if !l.OwnsOne(owner, src.Create()) {
		t.Fatalf("expected owner to own the asset")
	}
	if got := l.OwnsMany(owner, Currency{Id: 0}); got != 10 {
		t.Fatalf("expected balance 10, got %d", got)
	}
	if last, ok := l.GetUserLastStipend(owner); !ok || last != tids[2] {
		t.Fatalf("expected last stipend %v, got %v (ok %v)", tids[2], last, ok)
	}
	if err := l.Close(); err != nil {
		t.Fatalf("close: %v", err)
	}

	reopened, err := NewLedger(name)
	if err != nil {
		t.Fatalf("reopen: %v", err)
	}
	defer reopened.Close()

	if !reopened.OwnsOne(creator, src) {
		t.Fatalf("expected source ownership to survive reopen")
	}
	if !reopened.OwnsOne(owner, src.Create()) {
		t.Fatalf("expected asset ownership to survive reopen")
	}
	if got := reopened.OwnsMany(owner, Currency{Id: 0}); got != 10 {
		t.Fatalf("expected balance 10 after reopen, got %d", got)
	}
	if last, ok := reopened.GetUserLastStipend(owner); !ok || last != tids[2] {
		t.Fatalf("expected last stipend to survive reopen")
	}
}
