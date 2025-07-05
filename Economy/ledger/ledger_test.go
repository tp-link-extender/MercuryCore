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
}
