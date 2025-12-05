package main

import (
	"bytes"
	"os"
	"testing"
)

func TestEncodeDecode(t *testing.T) {
	user := User{"testuser"}

	tid := MakeTransferID()

	b := tid.Serialise()
	if len(b) != 28 {
		t.Fatalf("expected serialised TransferID length 28, got %d", len(b))
	}

	newTid, err := DeserialiseTransferID(b)
	if err != nil {
		t.Fatalf("DeserialiseTransferID: %v", err)
	}

	if tid != newTid {
		t.Fatalf("expected TransferID %v, got %v", tid, newTid)
	}

	// items
	items := Items{
		Many: ItemsMany{
			Currency{0}: 100,
		},
	}

	ibuf := &bytes.Buffer{}
	if err := items.Serialise(ibuf); err != nil {
		t.Fatalf("Items.Serialise: %v", err)
	}

	if ibuf.Len() != 25 {
		t.Fatalf("expected serialised Items length 25, got %d", ibuf.Len())
	}

	newItems, err := DeserialiseItems(ibuf)
	if err != nil {
		t.Fatalf("DeserialiseItems: %v", err)
	}

	if !items.Equal(newItems) {
		t.Fatalf("expected Items %v, got %v", items, newItems)
	}

	// send
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

	if tbuf.Len() != 44 {
		t.Fatalf("expected serialised Transfer length 44, got %d", tbuf.Len())
	}

	newTransfer, err := DeserialiseTransfer(tbuf)
	if err != nil {
		t.Fatalf("DeserialiseTransfer: %v", err)
	}

	if !transfer.Equal(newTransfer) {
		t.Fatalf("expected Transfer %v, got %v", transfer, newTransfer)
	}
}

func mintTest(economy *Economy, t *testing.T, currency Currency, user User) {
	xinv := Items{
		Many: ItemsMany{
			currency: 100,
		},
	}

	tf := Transfer{
		{Owner: user},
		{Items: xinv},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	if inv := economy.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}
}

func TestMint(t *testing.T) {
	// create temp file
	name := os.TempDir() + "/ledger_test.db"
	defer os.Remove(name)

	economy, err := NewEconomy(name)
	if err != nil {
		t.Fatalf("create economy: %v", err)
	}
	defer economy.Close()

	// let there be rocks
	currency := Currency{0}
	user1 := User{"user1"}

	mintTest(economy, t, currency, user1)
}

func createSourceTest(economy *Economy, t *testing.T, user User, currency Currency) UnlimitedSource {
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
		{
			Items: Items{
				One: ItemsOne{
					src: {},
				},
			},
		},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
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

	if inv := economy.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	return src
}

func purchaseAssetTest(economy *Economy, t *testing.T, user User, currency Currency, src UnlimitedSource) {
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

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
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

	if inv := economy.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}
}

func TestCreateSource(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	defer os.Remove(name)

	economy, err := NewEconomy(name)
	if err != nil {
		t.Fatalf("create economy: %v", err)
	}
	defer economy.Close()

	currency1 := Currency{1}
	user2 := User{"user2"}

	mintTest(economy, t, currency1, user2)
	src := createSourceTest(economy, t, user2, currency1)
	purchaseAssetTest(economy, t, user2, currency1, src)
}

func createPlaceTest(economy *Economy, t *testing.T, user User, currency Currency) {
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
		{
			Items: Items{
				One: ItemsOne{
					place: {},
				},
			},
		},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
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

	if inv := economy.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	if err := economy.Transfer(MakeTransferID(), tf); err == nil {
		t.Fatalf("expected error on duplicate transfer, got nil")
	}
}

func TestCreatePlace(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	defer os.Remove(name)

	economy, err := NewEconomy(name)
	if err != nil {
		t.Fatalf("create economy: %v", err)
	}
	defer economy.Close()

	currency2 := Currency{2}
	user3 := User{"user3"}

	mintTest(economy, t, currency2, user3)
	createPlaceTest(economy, t, user3, currency2)
}
