package ledger_test

import (
	"os"
	"testing"

	. "Economy/ledger"
)

type EconomyTest struct {
	Economy *Economy
	t       *testing.T
}

func (et *EconomyTest) ExpectBalance(u User, expected Currency) {
	if balance := et.Economy.GetBalance(u); balance != expected {
		et.t.Fatalf("Expected balance for user %s to be %d, got %d", u, expected, balance)
	}
}

func (et *EconomyTest) ExpectInventoryQuantity(u User, asset Asset, expected uint64) {
	inventory := et.Economy.GetInventory(u)
	if quantity := inventory[asset]; quantity != expected {
		et.t.Fatalf("Expected inventory for user %s to contain asset %s with quantity %d, got %d", u, asset, expected, quantity)
	}
}

func (et *EconomyTest) ExpectInventoryInfinite(u User, asset Asset) {
	inventory := et.Economy.GetInventory(u)
	if quantity, ok := inventory[asset]; !ok || quantity < BasicallyInfinity {
		et.t.Fatalf("Expected inventory for user %s to contain asset %s with quantity Infinity, got %d", u, asset, quantity)
	}
}

func TestEconomy(t *testing.T) {
	file, err := os.CreateTemp("", "ledgertest*.txt")
	if err != nil {
		t.Fatalf("Failed to create temporary file: %v", err)
	}
	defer os.Remove(file.Name()) // Clean up the temporary file after the test

	e, err := NewEconomy(file)
	if err != nil {
		t.Fatalf("Failed to create economy: %v", err)
	}

	et := &EconomyTest{e, t}

	if ccu := e.CCU(); ccu != 0 {
		t.Fatalf("CCU is %v", ccu.Readable())
	}

	u1 := User(RandId())

	if _, err = e.Mint(SentMint{
		To:     u1,
		Amount: 50 * Unit,
		Note:   "Here's 50 points for being a fly guy",
	}); err != nil {
		t.Fatal(err)
	}

	et.ExpectBalance(u1, 50*Unit)

	u2 := User(RandId())

	if _, err = e.Mint(SentMint{
		To:     u2,
		Amount: 100 * Unit,
		Note:   "Stipend",
	}); err != nil {
		t.Fatal(err)
	}

	et.ExpectBalance(u2, 100*Unit)

	if err = e.Transact(SentTx{
		From:   u1,
		To:     u2,
		Amount: 25 * Unit,
		Note:   "Transfer",
	}); err != nil {
		t.Fatal(err)
	}

	et.ExpectBalance(u1, 25*Unit)
	et.ExpectBalance(u2, 125*Unit)

	if err = e.Transact(SentTx{
		From:   u2,
		To:     u1,
		Amount: 1000 * Unit,
		Note:   "Illegal transfer",
	}); err == nil {
		t.Fatal("Expected error for illegal transfer, got nil")
	}

	if err = e.Burn(SentBurn{
		From:   u1,
		Amount: 10 * Unit,
		Note:   "Burning some currency",
		Link:   "/place/whatever",
	}); err != nil {
		t.Fatal(err)
	}

	if err = e.Burn(SentBurn{
		From:   u2,
		Amount: 1 * Mega,
		Note:   "Illegal burn",
		Link:   "/place/whatever",
	}); err == nil {
		t.Fatal("Expected error for illegal burn, got nil")
	}

	et.ExpectBalance(u1, 15*Unit)
	et.ExpectBalance(u2, 125*Unit)

	e.Stats()
}

func TestAssets(t *testing.T) {
	file, err := os.CreateTemp("", "ledgertest*.txt")
	if err != nil {
		t.Fatalf("Failed to create temporary file: %v", err)
	}
	defer os.Remove(file.Name())

	e, err := NewEconomy(file)
	if err != nil {
		t.Fatalf("Failed to create economy: %v", err)
	}

	et := &EconomyTest{e, t}

	u1 := User(RandId())
	u2 := User(RandId())

	if _, err = e.Mint(SentMint{
		To:     u1,
		Amount: 1 * Unit,
		Note:   "Minting for asset testing",
	}); err != nil {
		t.Fatal(err)
	}

	if _, err = e.Mint(SentMint{
		To:     u2,
		Amount: 1 * Unit,
		Note:   "Minting for asset testing",
	}); err != nil {
		t.Fatal(err)
	}

	a := NewAsset(TypeAsset, AssetId(RandAssetId()))
	if err = e.Burn(SentBurn{
		From:   u1,
		Amount: 1 * Milli,
		Note:   "Create asset",
		Link:   "/asset/whatever",
		Returns: Assets{
			a: Infinity,
		},
	}); err != nil {
		t.Fatal(err)
	}

	et.ExpectInventoryInfinite(u1, a)

	// buy time
	if err = e.Transact(SentTx{
		From: u2,
		To:   u1,
		Note: "Transfer",
		Returns: Assets{
			a: 100,
		},
	}); err != nil {
		t.Fatal(err)
	}

	et.ExpectInventoryInfinite(u1, a)
	et.ExpectInventoryQuantity(u2, a, 100)

	e.Stats()
}
