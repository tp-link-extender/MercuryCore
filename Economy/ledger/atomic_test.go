package ledger_test

import (
	"sync"
	"testing"

	. "Economy/ledger"
)

// A component the creator doesn't own must fail the whole package creation, not charge for the package first.
func TestCreatePackageSourceUnownedComponentIsClean(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	other := User{"other"}
	fund(t, e, creator, other)

	otherSrc, _, err := e.CreateUnlimitedSource(other)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	before := e.Balance(creator)
	beforeHistory, err := e.TransferHistory(100)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	pkgSrc, _, err := e.CreatePackageSource(creator, []PackageComponent{otherSrc})
	if err == nil {
		t.Fatalf("expected CreatePackageSource to reject a component owned by someone else")
	}

	if got := e.Balance(creator); got != before {
		t.Fatalf("expected a failed package creation to cost nothing, balance went %d -> %d", before, got)
	}
	if e.OwnsOne(creator, pkgSrc) {
		t.Fatalf("expected no package source to be minted by a failed creation")
	}
	if !e.OwnsOne(other, otherSrc) {
		t.Fatalf("expected %v to still be held by its owner", otherSrc)
	}

	afterHistory, err := e.TransferHistory(100)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}
	if len(afterHistory) != len(beforeHistory) {
		t.Fatalf("expected a failed creation to write no transfers, history went %d -> %d", len(beforeHistory), len(afterHistory))
	}
}

// Two attempts to put the same component sources into different packages must not both succeed or both charge.
func TestConcurrentCreatePackageSourceSameComponentsIsAtomic(t *testing.T) {
	e := newConcurrentEconomy(t)

	creator := User{"creator"}
	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency: %v", err)
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

	type result struct {
		src PackageSource
		err error
	}

	const attempts = 2
	start := make(chan struct{})
	results := make(chan result, attempts)
	var wg sync.WaitGroup
	for range attempts {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			src, _, err := e.CreatePackageSource(creator, sources)
			results <- result{src, err}
		}()
	}

	close(start)
	wg.Wait()
	close(results)

	successes := 0
	for res := range results {
		if res.err != nil {
			if e.OwnsOne(creator, res.src) {
				t.Fatalf("failed creation left %v owned", res.src)
			}
			continue
		}

		successes++
		if !e.OwnsOne(creator, res.src) {
			t.Fatalf("expected creator to own %v", res.src)
		}
		for _, c := range comps {
			if !e.OwnsOne(res.src, c) {
				t.Fatalf("expected %v to hold %v", res.src, c)
			}
		}
	}

	if successes != 1 {
		t.Fatalf("expected exactly one package source to be created, got %d", successes)
	}

	// 200 minted, 20 spent on the component sources, 10 on the one package source
	if got := e.Balance(creator); got != 170 {
		t.Fatalf("expected the balance to be 170, got %d", got)
	}
}

// Source creation is two transfers, so concurrent attempts must not leave a charged source without its stock.
func TestConcurrentLimitedSourceCreationIsAtomic(t *testing.T) {
	e := newConcurrentEconomy(t)

	creator := User{"creator"}
	const price = 100
	if _, err := e.MintCurrency(creator, 3*price); err != nil {
		t.Fatalf("MintCurrency: %v", err)
	}

	const attempts = 10
	const stock = 5

	type result struct {
		src LimitedSource
		err error
	}

	start := make(chan struct{})
	results := make(chan result, attempts)
	var wg sync.WaitGroup
	for range attempts {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			src, _, err := e.CreateLimitedSource(creator, stock)
			results <- result{src, err}
		}()
	}

	close(start)
	wg.Wait()
	close(results)

	successes := 0
	for res := range results {
		if res.err != nil {
			if e.OwnsOne(creator, res.src) {
				t.Fatalf("failed creation left %v owned", res.src)
			}
			if got := e.OwnersMany(res.src.Create())[res.src]; got != 0 {
				t.Fatalf("failed creation left %d stock for %v", got, res.src)
			}
			continue
		}

		successes++
		if !e.OwnsOne(creator, res.src) {
			t.Fatalf("expected creator to own %v", res.src)
		}
		if got := e.OwnersMany(res.src.Create())[res.src]; got != stock {
			t.Fatalf("expected %v to be stocked with %d, got %d", res.src, stock, got)
		}
	}

	if successes != 3 {
		t.Fatalf("expected exactly 3 successful creations, got %d", successes)
	}
	if got := e.Balance(creator); got != 0 {
		t.Fatalf("expected the balance to be spent exactly, got %d", got)
	}

	// one mint plus two transfers for each successful creation
	history, err := e.TransferHistory(100)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}
	if len(history) != 1+2*successes {
		t.Fatalf("expected %d transfers, got %d", 1+2*successes, len(history))
	}
}
