// These tests poke at State directly because the situations they cover - a source sitting on fungible goods, and a source paying out to a user - need state that the public Ledger API can't currently build up on its own, so there's no way to set them up through Economy.
package ledger

import "testing"

func apply(t *testing.T, s *State, tf Transfer) {
	t.Helper()
	if err := s.CanApply(tf); err != nil {
		t.Fatalf("CanApply: %v", err)
	}
	s.ForceApply(tf)
}

// on a sale the buyer pays currency to the source's owner and receives the goods
func TestForceApplyDeliversManyToBuyerOnSale(t *testing.T) {
	s := makeState()

	currency := Currency{0}
	src := LimitedSource{2}
	asset := src.Create()

	creator := User{"creator"}
	buyer := User{"buyer"}

	s.ownerItems[creator] = &Items{One: ItemsOne{src: {}}}
	s.ownerItems[src] = &Items{Many: ItemsMany{asset: 5}}
	s.ownerItems[buyer] = &Items{Many: ItemsMany{currency: 100}}
	s.itemOwnersOne[src] = &OwnersOne{creator: {}}
	s.itemOwnersMany[asset] = &OwnersMany{src: 5}

	apply(t, &s, Transfer{
		{Owner: buyer, Items: Items{Many: ItemsMany{currency: 30}}},
		{Owner: src, Items: Items{Many: ItemsMany{asset: 3}}},
	})

	if got := s.GetInventory(buyer).Many[currency]; got != 70 {
		t.Fatalf("expected buyer to have 70 currency left, got %d", got)
	}

	// the goods actually reach the buyer, they aren't just consumed by the source
	if got := s.GetInventory(buyer).Many[asset]; got != 3 {
		t.Fatalf("expected buyer to have 3 %v, got %d", asset, got)
	}
	if got := s.GetInventory(src).Many[asset]; got != 2 {
		t.Fatalf("expected source to have 2 %v left, got %d", asset, got)
	}

	// and the creator is paid for them
	if got := s.GetInventory(creator).Many[currency]; got != 30 {
		t.Fatalf("expected creator to be paid 30, got %d", got)
	}

	// the reverse index tracks both sides
	owners := *s.GetOwnersMany(asset)
	if got := owners[src]; got != 2 {
		t.Fatalf("expected source to own 2 %v, got %d", asset, got)
	}
	if got := owners[buyer]; got != 3 {
		t.Fatalf("expected buyer to own 3 %v, got %d", asset, got)
	}
}

// currency on a sale goes to whoever owns the source, not to the source itself
func TestForceApplySaleCurrencyGoesToSourceOwner(t *testing.T) {
	s := makeState()

	currency := Currency{0}
	src := LimitedSource{2}
	asset := src.Create()

	creator := User{"creator"}
	buyer := User{"buyer"}

	s.ownerItems[creator] = &Items{One: ItemsOne{src: {}}}
	s.ownerItems[src] = &Items{Many: ItemsMany{asset: 5}}
	s.ownerItems[buyer] = &Items{Many: ItemsMany{currency: 100}}
	s.itemOwnersOne[src] = &OwnersOne{creator: {}}

	apply(t, &s, Transfer{
		{Owner: buyer, Items: Items{Many: ItemsMany{currency: 30}}},
		{Owner: src, Items: Items{Many: ItemsMany{asset: 3}}},
	})

	if got := s.GetInventory(src).Many[currency]; got != 0 {
		t.Fatalf("expected source to hold no currency, got %d", got)
	}
	if got := s.GetInventory(creator).Many[currency]; got != 30 {
		t.Fatalf("expected creator to be paid 30, got %d", got)
	}
}

// a source paying a user is still a sale, but the user isn't a source owner so the currency has to be delivered normally rather than paid on to anyone
func TestForceApplySaleCurrencyReachesUser(t *testing.T) {
	s := makeState()

	currency := Currency{0}
	src := UnlimitedSource{2}
	buyer := User{"buyer"}

	s.ownerItems[src] = &Items{Many: ItemsMany{currency: 50}}
	s.ownerItems[buyer] = &Items{}

	apply(t, &s, Transfer{
		{Owner: src, Items: Items{Many: ItemsMany{currency: 20}}},
		{Owner: buyer, Items: Items{}},
	})

	if got := s.GetInventory(src).Many[currency]; got != 30 {
		t.Fatalf("expected source to have 30 currency left, got %d", got)
	}
	if got := s.GetInventory(buyer).Many[currency]; got != 20 {
		t.Fatalf("expected buyer to be paid 20, got %d", got)
	}
}

// non-sale transfers are unaffected: everything just moves to the other side
func TestForceApplyManyNonSale(t *testing.T) {
	s := makeState()

	currency := Currency{0}
	sender := User{"sender"}
	receiver := User{"receiver"}

	s.ownerItems[sender] = &Items{Many: ItemsMany{currency: 100}}

	apply(t, &s, Transfer{
		{Owner: sender, Items: Items{Many: ItemsMany{currency: 40}}},
		{Owner: receiver, Items: Items{}},
	})

	if got := s.GetInventory(sender).Many[currency]; got != 60 {
		t.Fatalf("expected sender to have 60 currency left, got %d", got)
	}
	if got := s.GetInventory(receiver).Many[currency]; got != 40 {
		t.Fatalf("expected receiver to have 40 currency, got %d", got)
	}
}

// canIssue must only ever cover unlimited assets: places and groups are CanOwnOne too, and an id collision with a held source must not let a source conjure them
func TestCanIssueOnlyCoversUnlimitedAssets(t *testing.T) {
	s := makeState()

	holder := UnlimitedSource{7}
	held := UnlimitedSource{42}

	s.ownerItems[holder] = &Items{One: ItemsOne{held: {}}}
	s.GetOwnersOne(holder).Add(User{"holder"})

	if !s.canIssue(holder, UnlimitedAsset{42}) {
		t.Fatalf("expected %v to be able to issue %v it holds the source for", holder, UnlimitedAsset{42})
	}

	if s.canIssue(holder, Place{42}) {
		t.Fatalf("expected %v not to be able to issue %v", holder, Place{42})
	}

	if s.canIssue(holder, UnlimitedAsset{43}) {
		t.Fatalf("expected %v not to be able to issue %v it doesn't hold the source for", holder, UnlimitedAsset{43})
	}
}

// a package source issues its own package, and anything it holds a source for
func TestPackageSourceCanIssue(t *testing.T) {
	s := makeState()

	pkgSrc := PackageSource{5}

	s.ownerItems[pkgSrc] = &Items{One: ItemsOne{
		UnlimitedSource{42}: {},
		UnlimitedSource{43}: {},
	}}
	s.GetOwnersOne(pkgSrc).Add(User{"creator"})

	if !s.canIssue(pkgSrc, pkgSrc.Create()) {
		t.Fatalf("expected %v to be able to issue its own %v", pkgSrc, pkgSrc.Create())
	}

	for _, held := range []UnlimitedSource{{42}, {43}} {
		if !s.canIssue(pkgSrc, held.Create()) {
			t.Fatalf("expected %v to be able to issue %v it holds the source for", pkgSrc, held.Create())
		}
	}

	if s.canIssue(pkgSrc, UnlimitedAsset{44}) {
		t.Fatalf("expected %v not to be able to issue an asset it holds no source for", pkgSrc)
	}
}

// packages nest, so a package source holding another package source can issue that package
func TestPackageSourceCanIssueNestedPackage(t *testing.T) {
	s := makeState()

	outer := PackageSource{5}
	inner := PackageSource{6}

	s.ownerItems[outer] = &Items{One: ItemsOne{inner: {}}}
	s.GetOwnersOne(outer).Add(User{"creator"})

	if !s.canIssue(outer, inner.Create()) {
		t.Fatalf("expected %v to be able to issue nested %v", outer, inner.Create())
	}
}
