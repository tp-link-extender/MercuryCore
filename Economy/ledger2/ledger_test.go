package main

import (
	"os"
	"testing"
)

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
