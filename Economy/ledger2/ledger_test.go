package main

import (
	"bytes"
	"os"
	"testing"
)

func TestEncTransferID(t *testing.T) {
	tid := MakeTransferID()

	b := tid.Serialise()

	const expLen = 28
	if len(b) != expLen {
		t.Fatalf("expected serialised TransferID length %d, got %d", expLen, len(b))
	}

	newTid, err := DeserialiseTransferID(b)
	if err != nil {
		t.Fatalf("DeserialiseTransferID: %v", err)
	}

	if tid != newTid {
		t.Fatalf("expected TransferID %v, got %v", tid, newTid)
	}
}

func TestEncItemsOne(t *testing.T) {
	items := Items{
		One: ItemsOne{
			RandPlace(): {},
		},
	}

	ibuf := &bytes.Buffer{}
	if err := items.Serialise(ibuf); err != nil {
		t.Fatalf("Items.Serialise: %v", err)
	}

	const expLen = 13
	if ibuf.Len() != expLen {
		t.Fatalf("expected serialised Items length %d, got %d", expLen, ibuf.Len())
	}

	newItems, err := DeserialiseItems(ibuf)
	if err != nil {
		t.Fatalf("DeserialiseItems: %v", err)
	}

	if !items.Equal(newItems) {
		t.Fatalf("expected Items %v, got %v", items, newItems)
	}
}

func encItemsMany(t *testing.T) Items {
	items := Items{
		Many: ItemsMany{
			Currency{}: 100,
		},
	}

	ibuf := &bytes.Buffer{}
	if err := items.Serialise(ibuf); err != nil {
		t.Fatalf("Items.Serialise: %v", err)
	}

	const expLen = 21
	if ibuf.Len() != expLen {
		t.Fatalf("expected serialised Items length %d, got %d", expLen, ibuf.Len())
	}

	newItems, err := DeserialiseItems(ibuf)
	if err != nil {
		t.Fatalf("DeserialiseItems: %v", err)
	}

	if !items.Equal(newItems) {
		t.Fatalf("expected Items %v, got %v", items, newItems)
	}
	return items
}

func encTransfer(t *testing.T, user User, items Items) {
	transfer := Transfer{
		{Owner: user},
		{Items: items},
	}
	if err := transfer.Valid(); err != nil {
		t.Fatalf("Transfer.Valid: %v", err)
	}

	for _, send := range transfer {
		sbuf := &bytes.Buffer{}
		send.Serialise(sbuf)

		newSend, err := DeserialiseSend(sbuf)
		if err != nil {
			t.Fatalf("DeserialiseSend: %v", err)
		}

		if !send.Equal(newSend) {
			t.Fatalf("expected Send %v, got %v", send, newSend)
		}
	}

	tbuf := &bytes.Buffer{}
	transfer.Serialise(tbuf)

	const expLen = 40
	if tbuf.Len() != expLen {
		t.Fatalf("expected serialised Transfer length %d, got %d", expLen, tbuf.Len())
	}

	newTransfer, err := DeserialiseTransfer(tbuf)
	if err != nil {
		t.Fatalf("DeserialiseTransfer: %v", err)
	}

	if !transfer.Equal(newTransfer) {
		t.Fatalf("expected Transfer %v, got %v", transfer, newTransfer)
	}
}

func TestEncodeDecode(t *testing.T) {
	user := User{"testuser"}
	items := encItemsMany(t)

	encTransfer(t, user, items)
}

func mintTest(l *Ledger, t *testing.T, currency Currency, user User) {
	xinv := Items{
		Many: ItemsMany{
			currency: 100,
		},
	}

	tf := Transfer{
		{Owner: user},
		{Items: xinv},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}
}

func TestMint(t *testing.T) {
	// create temp file
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	// let there be rocks
	currency := Currency{0}
	user1 := User{"user1"}

	mintTest(l, t, currency, user1)
}

func createSourceTest(l *Ledger, t *testing.T, user User, currency Currency) UnlimitedSource {
	src := UnlimitedSource{1}

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 50,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			src: {},
		},
		Many: ItemsMany{
			currency: 50,
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	return src
}

func purchaseAssetTest(l *Ledger, t *testing.T, user User, currency Currency, src UnlimitedSource) {
	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 10,
				},
			},
		},
		{
			Owner: src,
			Items: Items{
				One: ItemsOne{
					src.Create(): {},
				},
			},
		},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			src:          {},
			src.Create(): {},
		},
		Many: ItemsMany{
			currency: 40,
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}
}

func TestCreateSource(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency1 := Currency{1}
	user2 := User{"user2"}

	mintTest(l, t, currency1, user2)
	src := createSourceTest(l, t, user2, currency1)
	purchaseAssetTest(l, t, user2, currency1, src)
}

func createPlaceTest(l *Ledger, t *testing.T, user User, currency Currency) {
	place := RandPlace()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 10,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				place: {},
			},
		}},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			place: {},
		},
		Many: ItemsMany{
			currency: 90,
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	if err := l.Transfer(MakeTransferID(), tf); err == nil {
		t.Fatalf("expected error on duplicate transfer, got nil")
	}
}

func TestCreatePlace(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency2 := Currency{2}
	user3 := User{"user3"}

	mintTest(l, t, currency2, user3)
	createPlaceTest(l, t, user3, currency2)
}

func TestReopen(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	currency3 := Currency{3}
	user4 := User{"user4"}

	const qty = 100

	for i := Quantity(qty); i < 10*qty; i += qty {
		l, err := NewLedger(name)
		if err != nil {
			t.Fatalf("create ledger: %v", err)
		}

		tf := Transfer{
			{Owner: user4},
			{Items: Items{
				Many: ItemsMany{
					currency3: qty,
				},
			}},
		}

		if err := l.Transfer(MakeTransferID(), tf); err != nil {
			t.Fatalf("transfer: %v", err)
		}

		xinv := Items{
			Many: ItemsMany{
				currency3: i,
			},
		}

		if inv := l.Inventory(user4); !inv.Equal(xinv) {
			t.Fatalf("expected inventory %v, got %v", xinv, inv)
		}
		l.Close()
	}
}

func TestAbstractions(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	e := Economy{
		ledger:               l,
		placePrice:           10,
		groupPrice:           10,
		limitedSourcePrice:   100,
		unlimitedSourcePrice: 10,
	}

	user := User{"testuser"}

	if _, err := e.MintCurrency(user, 100); err != nil {
		t.Fatalf("MintCurrency: %v", err)
	}

	if e.Balance(user) != 100 {
		t.Fatalf("expected balance 100, got %d", e.Balance(user))
	}

	place, _, err := e.CreatePlace(user)
	if err != nil {
		t.Fatalf("CreatePlace: %v", err)
	}

	if e.Balance(user) != 90 {
		t.Fatalf("expected balance 90, got %d", e.Balance(user))
	}

	if !e.OwnsOne(user, place) {
		t.Fatalf("expected user to own place %v", place)
	}
}
