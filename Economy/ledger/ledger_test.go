package ledger_test

import (
	"bytes"
	"testing"

	. "Economy/ledger"
)

type EconomyTest struct {
	Economy *Economy
	t       *testing.T
}

func (et *EconomyTest) ExpectBalance(user User, expected Currency) {
	if balance := et.Economy.GetBalance(user); balance != expected {
		et.t.Fatalf("Expected balance for user %s to be %d, got %d", user, expected, balance)
	}
}

func TestEconomy(t *testing.T) {
	rw := &bytes.Buffer{}

	e, err := NewEconomy(rw)
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

	et.ExpectBalance(u1, 15*Unit)
	et.ExpectBalance(u2, 125*Unit)

	e.Stats()
}
