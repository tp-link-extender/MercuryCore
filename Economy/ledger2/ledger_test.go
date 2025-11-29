package main

import (
	"os"
	"testing"
)

func mintTest(economy *Economy, t *testing.T, currency ItemCurrency, user OwnerUser) {
	iou := ItemOwner{user}
	xinv := Items{
		currency: 100,
	}

	tf := Transfer{
		{Owner: iou},
		{Items: xinv},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	if inv := economy.Inventory(iou); !inv.Equal(xinv) {
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
	iou := ItemOwner{user}
	src := OwnerUnlimitedSource{1}
	ios := ItemOwner{src}

	tf := Transfer{
		{
			Owner: iou,
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

	expected := Items{
		currency: 50,
		ios:      1,
	}

	if inv := economy.Inventory(iou); !inv.Equal(expected) {
		t.Fatalf("expected inventory %v, got %v", expected, inv)
	}

	return src
}

func purchaseAssetTest(economy *Economy, t *testing.T, user OwnerUser, currency ItemCurrency, src OwnerUnlimitedSource) {
	iou := ItemOwner{user}
	ios := ItemOwner{src}

	tf := Transfer{
		{
			Owner: iou,
			Items: Items{
				currency: 50,
			},
		},
		{
			Owner: ios,
			Items: Items{
				ItemAsset{false, src.ID}: 1,
			},
		},
	}

	if err := economy.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}
}

func TestCreateSource(t *testing.T) {
	// create temp file
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
