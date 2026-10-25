package ledger_test

import (
	"errors"
	"fmt"
	"sync"
	"testing"
	"time"

	. "Economy/ledger"
)

func newConcurrentEconomy(t *testing.T) *Economy {
	t.Helper()

	l, err := NewLedger(t.TempDir() + "/ledger.db")
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	t.Cleanup(func() { l.Close() })

	return NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)
}

// Concurrent buyers must not all validate against the same stock, and reads must not race with the transfer applying.
func TestConcurrentLimitedPurchasesDoNotOversell(t *testing.T) {
	e := newConcurrentEconomy(t)

	creator := User{"creator"}
	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency creator: %v", err)
	}

	const stock = 5
	src, _, err := e.CreateLimitedSource(creator, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	const buyers = 20
	users := make([]User, buyers)
	for i := range users {
		users[i] = User{fmt.Sprintf("buyer%d", i)}
		if _, err := e.MintCurrency(users[i], 10); err != nil {
			t.Fatalf("MintCurrency %v: %v", users[i], err)
		}
	}

	// keep reading the state while the purchases are applied, so the race detector covers the snapshot paths too
	done := make(chan struct{})
	readerDone := make(chan struct{})
	go func() {
		defer close(readerDone)
		for {
			select {
			case <-done:
				return
			default:
			}
			_ = e.Inventory(creator)
			_ = e.OwnersOne(src)
			_ = e.OwnersMany(src.Create())
			_ = e.PackageItems()
		}
	}()

	start := make(chan struct{})
	results := make(chan error, buyers)
	var wg sync.WaitGroup
	for _, u := range users {
		wg.Add(1)
		go func(u User) {
			defer wg.Done()
			<-start
			_, _, err := e.BuyLimitedAsset(u, src, 10, 1)
			results <- err
		}(u)
	}

	close(start)
	wg.Wait()
	close(done)
	<-readerDone
	close(results)

	successes := 0
	for err := range results {
		if err == nil {
			successes++
		}
	}

	if successes != stock {
		t.Fatalf("expected exactly %d successful purchases, got %d", stock, successes)
	}

	sold := Quantity(0)
	for _, qty := range e.OwnersMany(src.Create()) {
		sold += qty
	}
	if sold != stock {
		t.Fatalf("expected %d limited assets sold, got %d", stock, sold)
	}
	if got := e.OwnersMany(src.Create())[src]; got != 0 {
		t.Fatalf("expected no stock left in the source, got %d", got)
	}
}

// Package contents are read while other buyers are purchasing, so the contents walk must not race with sales.
func TestConcurrentPackagePurchases(t *testing.T) {
	e := newConcurrentEconomy(t)

	creator := User{"creator"}
	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency creator: %v", err)
	}

	comps := make([]UnlimitedSource, 2)
	sources := make([]PackageComponent, 2)
	for i := range comps {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		comps[i] = c
		sources[i] = c
	}

	pkgSrc, _, err := e.CreatePackageSource(creator, sources)
	if err != nil {
		t.Fatalf("CreatePackageSource: %v", err)
	}

	const buyers = 10
	users := make([]User, buyers)
	for i := range users {
		users[i] = User{fmt.Sprintf("package-buyer%d", i)}
		if _, err := e.MintCurrency(users[i], 20); err != nil {
			t.Fatalf("MintCurrency %v: %v", users[i], err)
		}
	}

	done := make(chan struct{})
	readerDone := make(chan struct{})
	go func() {
		defer close(readerDone)
		for {
			select {
			case <-done:
				return
			default:
			}
			_ = e.PackageContents(pkgSrc)
			_ = e.PackageItems()
			_ = e.OwnersOne(pkgSrc)
			_ = e.Inventory(creator)
		}
	}()

	start := make(chan struct{})
	results := make(chan error, buyers)
	var wg sync.WaitGroup
	for _, u := range users {
		wg.Add(1)
		go func(u User) {
			defer wg.Done()
			<-start
			_, _, err := e.BuyPackage(u, pkgSrc, 10)
			results <- err
		}(u)
	}

	close(start)
	wg.Wait()
	close(done)
	<-readerDone
	close(results)

	for err := range results {
		if err != nil {
			t.Fatalf("BuyPackage: %v", err)
		}
	}

	for _, u := range users {
		if !e.OwnsOne(u, pkgSrc.Create()) {
			t.Fatalf("expected %v to own the package", u)
		}
		for _, c := range comps {
			if !e.OwnsOne(u, c.Create()) {
				t.Fatalf("expected %v to own %v", u, c.Create())
			}
		}
	}
}

// Two simultaneous stipend requests must not both pass the cooldown check.
func TestConcurrentStipendsOnlyMintOnce(t *testing.T) {
	e := newConcurrentEconomy(t)

	user := User{"stipend-user"}
	const requests = 20

	start := make(chan struct{})
	results := make(chan error, requests)
	var wg sync.WaitGroup
	for range requests {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			_, err := e.Stipend(user)
			results <- err
		}()
	}

	close(start)
	wg.Wait()
	close(results)

	successes := 0
	for err := range results {
		switch {
		case err == nil:
			successes++
		case errors.Is(err, ErrStipendNotReady):
		default:
			t.Fatalf("unexpected stipend error: %v", err)
		}
	}

	if successes != 1 {
		t.Fatalf("expected exactly one stipend to be granted, got %d", successes)
	}
	if got := e.Balance(user); got != 10 {
		t.Fatalf("expected a balance of 10, got %d", got)
	}
}
