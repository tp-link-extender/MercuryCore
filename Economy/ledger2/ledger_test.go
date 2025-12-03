package main

import (
	"os"
	"testing"
)

func mintTest(economy *Economy, t *testing.T, currency ItemCurrency, user OwnerUser) {
	xinv := Items{
		currency: 100,
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
	currency := ItemCurrency{0}
	user1 := OwnerUser{"user1"}

	mintTest(economy, t, currency, user1)
}

func createSourceTest(economy *Economy, t *testing.T, user OwnerUser, currency ItemCurrency) OwnerUnlimitedSource {
	src := OwnerUnlimitedSource{1}
	ios := ItemOwner{src}

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				currency: 50,
			},
		},
		{
			Items: Items{
				ios: 1,
			},
		},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		currency: 50,
		ios:      1,
	}

	if inv := economy.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	return src
}

func purchaseAssetTest(economy *Economy, t *testing.T, user OwnerUser, currency ItemCurrency, src OwnerUnlimitedSource) {
	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				currency: 50,
			},
		},
		{
			Owner: src,
			Items: Items{
				ItemAsset{false, src.ID}: 1,
			},
		},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		ItemOwner{src}:           1,
		ItemAsset{false, src.ID}: 1,
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

	currency1 := ItemCurrency{1}
	user2 := OwnerUser{"user2"}

	mintTest(economy, t, currency1, user2)
	src := createSourceTest(economy, t, user2, currency1)
	purchaseAssetTest(economy, t, user2, currency1, src)
}

func createPlaceTest(economy *Economy, t *testing.T, user OwnerUser, currency ItemCurrency) {
	place := RandPlace()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				currency: 10,
			},
		},
		{
			Items: Items{
				place: 1,
			},
		},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		currency: 90,
		place:    1,
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

	currency2 := ItemCurrency{2}
	user3 := OwnerUser{"user3"}

	mintTest(economy, t, currency2, user3)
	createPlaceTest(economy, t, user3, currency2)
}
