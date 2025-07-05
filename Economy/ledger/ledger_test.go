package ledger_test

import (
	"bytes"
	"testing"

	. "Economy/ledger"
)

func TestEconomy(t *testing.T) {
	rw := &bytes.Buffer{}

	e, err := NewEconomy(rw)
	if err != nil {
		t.Fatalf("Failed to create economy: %v", err)
	}

	if ccu := e.CCU(); ccu != 0 {
		t.Fatalf("CCU is %f", ccu)
	}

	u1 := User(RandId())

	if _, err = e.Mint(SentMint{
		To:     u1,
		Amount: 50 * Unit,
		Note:   "Here's 50 points for being a fly guy",
	}); err != nil {
		t.Fatal(err)
	}

	if balance := e.GetBalance(u1); balance != 50*Unit {
		t.Fatalf("Balance is %d, expected %d", balance, 50*Unit)
	}
}
