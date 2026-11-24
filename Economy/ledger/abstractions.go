package ledger

import (
	"errors"
	"fmt"
	"math/bits"
	"time"
)

type (
	// Abstractions
	Economy struct {
		ledger *Ledger
		defaultCurrency Currency
		PlacePrice, GroupPrice, LimitedSourcePrice, UnlimitedSourcePrice, PackageSourcePrice, StipendAmount Quantity
		StipendTime time.Duration
	}

	// PackageComponent is something a package source can hold: either an asset source, or the source of a nested package. Both are CanOwnOne and both grant their holder the right to issue what they create, which is all the ledger needs to know to reissue a bundle.
	PackageComponent = CanOwnOne
)

var (
	ErrStipendNotReady = errors.New("stipend not available yet")
	ErrNoStock = errors.New("limited source needs a stock of at least one")
	ErrPriceOverflow = errors.New("total price overflows")
	ErrBalanceOverflow = errors.New("mint would overflow balance")
	ErrEmptyPackage = errors.New("package needs at least one component")
	ErrSelfNestedPackage = errors.New("package cannot contain itself")

	// ErrUnsupportedPackageComponent is returned for a component a package can't reissue, which is anything that isn't an unlimited asset source or a nested package source.
	// Limited sources are the awkward case: their asset is CanOwnMany, so it can't travel in a One and the contents walk would drop it without a word, leaving the buyer short of what they paid for.
	ErrUnsupportedPackageComponent = errors.New("package components must be unlimited asset sources or package sources")
)

func (e *Economy) Inventory(o Owner) Items {
	return e.ledger.Inventory(o)
}

func (e *Economy) OwnersMany(i CanOwnMany) OwnersMany {
	return e.ledger.OwnersMany(i)
}

func (e *Economy) CountOwnersMany(i CanOwnMany) (count int) {
	owners := e.OwnersMany(i)

	for _, qty := range owners {
		if qty > 0 {
			count++
		}
	}

	return count
}

func (e *Economy) OwnersOne(i CanOwnOne) OwnersOne {
	return e.ledger.OwnersOne(i)
}

func (e *Economy) CountOwnersOne(i CanOwnOne) int {
	return len(e.OwnersOne(i))
}

func (e *Economy) OwnsMany(o Owner, i CanOwnMany) Quantity {
	return e.ledger.OwnsMany(o, i)
}

func (e *Economy) Balance(o Owner) Quantity {
	return e.OwnsMany(o, e.defaultCurrency)
}

func (e *Economy) OwnsOne(o Owner, i CanOwnOne) bool {
	return e.ledger.OwnsOne(o, i)
}

// PackageContents returns everything a package source will hand over to a buyer: the package itself plus every asset inside it, nested packages included.
func (e *Economy) PackageContents(src PackageSource) ItemsOne {
	return e.ledger.PackageContents(src)
}

// PackageItems returns every asset that sits inside some package, across the whole ledger.
// The Site uses this to keep bundle contents out of catalog and search listings.
func (e *Economy) PackageItems() ItemsOne {
	return e.ledger.PackageItems()
}

func (e *Economy) TransferHistory(n uint32) ([]TransferWithID, error) {
	return e.ledger.TransferHistory(int(n))
}

func (e *Economy) TransferHistoryOwner(n uint32, o Owner) ([]TransferWithID, error) {
	return e.ledger.TransferHistoryOwner(int(n), o)
}

func NewEconomy(ledger *Ledger, placePrice, groupPrice, limitedSourcePrice, unlimitedSourcePrice, packageSourcePrice, stipendAmount Quantity, stipendTime time.Duration) *Economy {
	return &Economy{
		ledger: ledger,
		// default 0 currency
		PlacePrice: placePrice,
		GroupPrice: groupPrice,
		LimitedSourcePrice: limitedSourcePrice,
		UnlimitedSourcePrice: unlimitedSourcePrice,
		PackageSourcePrice: packageSourcePrice,
		StipendAmount: stipendAmount,
		StipendTime: stipendTime,
	}
}

// currencyItems builds a payment entry. Zero prices are free, and a zero-quantity entry would make the transfer invalid, so free means no currency entry at all.
func currencyItems(currency Currency, qty Quantity) ItemsMany {
	if qty == 0 {
		return nil
	}

	return ItemsMany{
		currency: qty,
	}
}

func (e *Economy) BuyLimitedAsset(u User, src LimitedSource, priceEach, qty Quantity) (a LimitedAsset, tid TransferID, err error) {
	a = src.Create()

	// A wrapped total would charge far less than the real price
	hi, total := bits.Mul64(uint64(priceEach), uint64(qty))
	if hi != 0 {
		return a, tid, ErrPriceOverflow
	}

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, Quantity(total)),
			},
		},
		{
			Owner: src,
			Items: Items{
				Many: ItemsMany{
					a: qty,
				},
			},
		},
	}
	tid = MakeTransferID()

	if err := e.ledger.Transfer(tid, tf); err != nil {
		return a, tid, fmt.Errorf("buy limited asset transfer %v: %w", tid, err)
	}

	return a, tid, nil
}

// BuyPackage sells a package: the buyer pays once and receives the package plus everything inside it, in a single transfer.
//
// A component the buyer already owns is skipped rather than failing the whole bundle, so overlapping packages can both be bought.
func (e *Economy) BuyPackage(u User, src PackageSource, price Quantity) (p Package, tid TransferID, err error) {
	p = src.Create()
	tid = MakeTransferID()

	// Contents and the buyer's inventory are read inside the same lock that applies the transfer, so a package can't change between pricing it and selling it.
	err = e.ledger.transferPrepared(tid, func(s *State) (Transfer, error) {
		contents := s.packageContents(src)
		if !packageContentsHaveAsset(contents) {
			return Transfer{}, ErrEmptyPackage
		}

		// the package itself, plus every component the buyer doesn't already have
		issued := ItemsOne{
			p: {},
		}

		for item := range contents {
			if s.ownsOne(u, item) {
				continue
			}

			issued.Add(item)
		}

		return Transfer{
			{
				Owner: u,
				Items: Items{
					Many: currencyItems(e.defaultCurrency, price),
				},
			},
			{
				Owner: src,
				Items: Items{
					One: issued,
				},
			},
		}, nil
	})
	if err != nil {
		if errors.Is(err, ErrEmptyPackage) {
			return p, TransferID{}, ErrEmptyPackage
		}

		return p, tid, fmt.Errorf("buy package transfer %v: %w", tid, err)
	}

	return p, tid, nil
}

func (e *Economy) BuyUnlimitedAsset(u User, src UnlimitedSource, price Quantity) (a UnlimitedAsset, tid TransferID, err error) {
	a = src.Create()

	// Owning the source is how creators are represented, so checking the source here would stop them from ever buying their own asset.
	// The thing that can only be owned once is the asset, and the ledger rejects a second copy under the transfer lock anyway.
	if e.OwnsOne(u, a) {
		return a, tid, fmt.Errorf("user %v already owns unlimited asset %v", u, a)
	}

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, price),
			},
		},
		{
			Owner: src,
			Items: Items{
				One: ItemsOne{
					a: {},
				},
			},
		},
	}
	tid = MakeTransferID()

	if err := e.ledger.Transfer(tid, tf); err != nil {
		return a, tid, fmt.Errorf("buy unlimited asset transfer %v: %w", tid, err)
	}

	return a, tid, nil
}

func (e *Economy) CreateGroup(u User) (g Group, tid TransferID, err error) {
	g = RandGroup()
	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, e.GroupPrice),
			},
		},
		{
			Items: Items{
				One: ItemsOne{
					g: {},
				},
			},
		},
	}
	tid = MakeTransferID()

	if err := e.ledger.Transfer(tid, tf); err != nil {
		return g, tid, fmt.Errorf("create group transfer %v: %w", tid, err)
	}

	return g, tid, nil
}

// CreateLimitedSource mints a limited source and stocks it with qty of the asset it creates.
// The source has to go to the user while its stock has to go to the source, which needs two transfers. They are applied as one batch, so a failure in either leaves neither the charge nor the source behind.
func (e *Economy) CreateLimitedSource(u User, qty Quantity) (src LimitedSource, tid TransferID, err error) {
	if qty == 0 {
		return src, tid, ErrNoStock
	}

	src = RandLimitedSource()
	handover := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, e.LimitedSourcePrice),
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
	stock := Transfer{
		{
			Items: Items{
				Many: ItemsMany{
					src.Create(): qty,
				},
			},
		},
		{
			Owner: src,
			Items: Items{},
		},
	}
	tid = MakeTransferID()
	stockTid := MakeTransferID()

	if err := e.ledger.transferBatch([]TransferID{tid, stockTid}, []Transfer{handover, stock}); err != nil {
		return src, tid, fmt.Errorf("create limited source transfers: %w", err)
	}

	return src, tid, nil
}

func (e *Economy) CreatePlace(u User) (p Place, tid TransferID, err error) {
	p = RandPlace()

	// tf (the fuck)
	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, e.PlacePrice),
			},
		},
		{
			Items: Items{
				One: ItemsOne{
					p: {},
				},
			},
		},
	}
	tid = MakeTransferID()

	if err := e.ledger.Transfer(tid, tf); err != nil {
		return p, tid, fmt.Errorf("create place transfer %v: %w", tid, err)
	}

	return p, tid, nil
}

func (e *Economy) MintCurrency(u User, qty Quantity) (tid TransferID, err error) {
	tf := Transfer{
		{
			Owner: u,
		},
		{
			Items: Items{
				Many: currencyItems(e.defaultCurrency, qty),
			},
		},
	}
	tid = MakeTransferID()

	// The overflow check runs inside the ledger lock, so two concurrent mints can't both pass it and wrap the balance.
	if err := e.ledger.transferWithCheck(tid, tf, func(s *State) error {
		// Currency is created from nothing here, so a mint that wraps around would silently destroy the recipient's balance.
		if qty > ^Quantity(0)-s.GetInventory(u).Many[e.defaultCurrency] {
			return ErrBalanceOverflow
		}

		return nil
	}); err != nil {
		if errors.Is(err, ErrBalanceOverflow) {
			return tid, ErrBalanceOverflow
		}

		return tid, fmt.Errorf("mint currency transfer %v: %w", tid, err)
	}

	return tid, nil
}

func (e *Economy) Stipend(user User) (tid TransferID, err error) {
	tf := Transfer{
		{
			Owner: user,
		},
		{
			Items: Items{
				Many: currencyItems(e.defaultCurrency, e.StipendAmount),
			},
		},
	}

	// we built the check, now test it
	if !tf.Stipend() {
		return tid, fmt.Errorf("invalid stipend transfer: %v", tf)
	}

	tid = MakeTransferID()

	// The eligibility check runs inside the ledger lock, so two simultaneous requests can't both pass it and mint two stipends.
	if err := e.ledger.transferWithCheck(tid, tf, func(s *State) error {
		if lastStipend, ok := s.userLastStipend[user]; ok && time.Since(time.Unix(0, int64(lastStipend.timestamp))) < e.StipendTime {
			return ErrStipendNotReady
		}

		if e.StipendAmount > ^Quantity(0)-s.GetInventory(user).Many[e.defaultCurrency] {
			return ErrBalanceOverflow
		}

		return nil
	}); err != nil {
		if errors.Is(err, ErrStipendNotReady) {
			return tid, ErrStipendNotReady
		}

		if errors.Is(err, ErrBalanceOverflow) {
			return tid, ErrBalanceOverflow
		}

		return tid, fmt.Errorf("stipend transfer %v: %w", tid, err)
	}

	return tid, nil
}

// createUnlimitedSourceWithPrice mints an unlimited source and charges price for it. A zero price is free, since currencyItems returns no currency entry at zero.
func (e *Economy) createUnlimitedSourceWithPrice(u User, price Quantity) (src UnlimitedSource, tid TransferID, err error) {
	src = RandUnlimitedSource()
	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, price),
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
	tid = MakeTransferID()

	if err := e.ledger.Transfer(tid, tf); err != nil {
		return src, tid, fmt.Errorf("create unlimited source transfer %v: %w", tid, err)
	}

	return src, tid, nil
}

func (e *Economy) CreateUnlimitedSource(u User) (src UnlimitedSource, tid TransferID, err error) {
	return e.createUnlimitedSourceWithPrice(u, e.UnlimitedSourcePrice)
}

// CreateUnlimitedSourceFree mints an unlimited source without charging the user. The caller must have authorised a staff member (permission level 3+), since the Economy has no permission model.
func (e *Economy) CreateUnlimitedSourceFree(u User) (src UnlimitedSource, tid TransferID, err error) {
	return e.createUnlimitedSourceWithPrice(u, 0)
}

// validatePackageComponents rejects components the contents walk can't hand over. It runs before anything is written, so a rejected component never costs the caller anything.
func validatePackageComponents(comps []PackageComponent) error {
	for _, c := range comps {
		switch c.(type) {
		case PackageSource, UnlimitedSource:
		default:
			return fmt.Errorf("%w: %v", ErrUnsupportedPackageComponent, c)
		}
	}

	return nil
}

func packageComponentItems(comps []PackageComponent) (ItemsOne, error) {
	if err := validatePackageComponents(comps); err != nil {
		return nil, err
	}

	items := make(ItemsOne, len(comps))

	for _, c := range comps {
		items.Add(c)
	}

	return items, nil
}

// AddPackageComponents moves component sources from u into an existing package source, so packages can be built up and nested. The caller has to own every source they pass in.
func (e *Economy) AddPackageComponents(u User, src PackageSource, comps []PackageComponent) ([]TransferID, error) {
	if len(comps) == 0 {
		return nil, nil
	}

	items, err := packageComponentItems(comps)
	if err != nil {
		return nil, err
	}

	for _, c := range comps {
		if c == src {
			return nil, ErrSelfNestedPackage
		}
	}

	tid := MakeTransferID()

	if err := e.ledger.Transfer(tid, Transfer{
		{
			Owner: u,
			Items: Items{
				One: items,
			},
		},
		{
			Owner: src,
			Items: Items{},
		},
	}); err != nil {
		return nil, fmt.Errorf("add package components transfer %v: %w", tid, err)
	}

	return []TransferID{tid}, nil
}

// AddPackageComponent nests one package inside another, by moving its source into the outer one.
func (e *Economy) AddPackageComponent(u User, src, inner PackageSource) ([]TransferID, error) {
	return e.AddPackageComponents(u, src, []PackageComponent{inner})
}

// createPackageSourceWithPrice mints a package source and charges price for it. A zero price is free, since currencyItems returns no currency entry at zero.
func (e *Economy) createPackageSourceWithPrice(u User, comps []PackageComponent, price Quantity) (src PackageSource, tid TransferID, err error) {
	if len(comps) == 0 {
		return src, tid, ErrEmptyPackage
	}

	items, err := packageComponentItems(comps)
	if err != nil {
		return src, tid, err
	}

	src = RandPackageSource()
	handover := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: currencyItems(e.defaultCurrency, price),
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
	components := Transfer{
		{
			Owner: u,
			Items: Items{
				One: items,
			},
		},
		{
			Owner: src,
			Items: Items{},
		},
	}
	tid = MakeTransferID()
	componentsTid := MakeTransferID()

	if err := e.ledger.transferBatch([]TransferID{tid, componentsTid}, []Transfer{handover, components}); err != nil {
		return src, tid, fmt.Errorf("create package source transfers: %w", err)
	}

	return src, tid, nil
}

// CreatePackageSource mints a package source and hands it ownership of the given component sources. The package source holding the sources (rather than the assets) is what lets it reissue the whole bundle indefinitely, because holding a source entitles its holder to issue what that source creates.
// The handover and the component transfer go in one batch, so a user who can't afford the package or doesn't own a component is charged nothing and left with nothing.
func (e *Economy) CreatePackageSource(u User, comps []PackageComponent) (src PackageSource, tid TransferID, err error) {
	return e.createPackageSourceWithPrice(u, comps, e.PackageSourcePrice)
}

// CreatePackageSourceFree mints a package source without charging the user. The caller must have authorised a staff member (permission level 3+), since the Economy has no permission model.
func (e *Economy) CreatePackageSourceFree(u User, comps []PackageComponent) (src PackageSource, tid TransferID, err error) {
	return e.createPackageSourceWithPrice(u, comps, 0)
}
