package ledger

import (
	"errors"
	"fmt"
	"time"
)

// Abstractions
type Economy struct {
	ledger                                                                               *Ledger
	defaultCurrency                                                                      Currency
	PlacePrice, GroupPrice, LimitedSourcePrice, UnlimitedSourcePrice, PackageSourcePrice Quantity
	StipendAmount                                                                        Quantity
	StipendTime                                                                          time.Duration
}

func NewEconomy(ledger *Ledger, placePrice, groupPrice, limitedSourcePrice, unlimitedSourcePrice, packageSourcePrice, stipendAmount Quantity, stipendTime time.Duration) *Economy {
	return &Economy{
		ledger: ledger,
		// default 0 currency
		PlacePrice:           placePrice,
		GroupPrice:           groupPrice,
		LimitedSourcePrice:   limitedSourcePrice,
		UnlimitedSourcePrice: unlimitedSourcePrice,
		PackageSourcePrice:   packageSourcePrice,
		StipendAmount:        stipendAmount,
		StipendTime:          stipendTime,
	}
}

func (e *Economy) OwnsOne(o Owner, i CanOwnOne) bool {
	// ea ledger
	// it's in the name
	inv := e.ledger.Inventory(o)
	return inv.One.Has(i)
}

func (e *Economy) OwnsMany(o Owner, i CanOwnMany) Quantity {
	inv := e.ledger.Inventory(o)
	return inv.Many[i]
}

func (e *Economy) OwnersOne(i CanOwnOne) OwnersOne {
	return *e.ledger.state.GetOwnersOne(i)
}

func (e *Economy) OwnersMany(i CanOwnMany) OwnersMany {
	return *e.ledger.state.GetOwnersMany(i)
}

func (e *Economy) CountOwnersOne(i CanOwnOne) int {
	return len(e.OwnersOne(i))
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

func (e *Economy) Inventory(o Owner) Items {
	inv := e.ledger.Inventory(o)
	return *inv
}

func (e *Economy) Balance(o Owner) Quantity {
	return e.OwnsMany(o, e.defaultCurrency)
}

func (e *Economy) MintCurrency(u User, qty Quantity) (tid TransferID, err error) {
	tf := Transfer{
		{Owner: u},
		{Items: Items{
			Many: ItemsMany{
				e.defaultCurrency: qty,
			},
		}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return tid, fmt.Errorf("mint currency transfer %v: %w", tid, err)
	}

	return tid, nil
}

var ErrStipendNotReady = errors.New("stipend not available yet")

func (e *Economy) Stipend(user User) (tid TransferID, err error) {
	lastStipend, ok := e.ledger.GetUserLastStipend(user)
	if ok && time.Since(time.Unix(0, int64(lastStipend.timestamp))) < e.StipendTime {
		return tid, ErrStipendNotReady
	}

	tf := Transfer{
		{Owner: user},
		{Items: Items{
			Many: ItemsMany{
				e.defaultCurrency: e.StipendAmount,
			},
		}},
	}

	// we built the check, now test it
	if !tf.Stipend() {
		return tid, fmt.Errorf("invalid stipend transfer: %v", tf)
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return tid, fmt.Errorf("stipend transfer %v: %w", tid, err)
	}

	return tid, nil
}

var ErrNoStock = errors.New("limited source needs a stock of at least one")

// CreateLimitedSource mints a limited source and stocks it with qty of the asset it creates.
// This takes two transfers, because a transfer can only ever move items between two owners and the stock has to go to the source while the source itself has to go to the user. They aren't atomic, so the order matters: the handover is charged first and the stock is granted second. That way a user who can't afford the source fails with nothing written at all, rather than leaving a stock of assets stranded in the ledger that nobody owns and nobody can sell.
// The reverse residual is much narrower: a source that's been paid for but not yet stocked, if the stock grant fails. That grant mints from nil so it can't fail validation, leaving a disk error as the only way to hit it - and it leaves a visible unusable source rather than invisible lost stock.
func (e *Economy) CreateLimitedSource(u User, qty Quantity) (src LimitedSource, tid TransferID, err error) {
	if qty == 0 {
		return src, tid, ErrNoStock
	}

	src = RandLimitedSource()

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.LimitedSourcePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return src, tid, fmt.Errorf("create limited source transfer %v: %w", tid, err)
	}

	stockTid := MakeTransferID()
	if err := e.ledger.Transfer(stockTid, Transfer{
		{Items: Items{
			Many: ItemsMany{
				src.Create(): qty,
			},
		}},
		{Owner: src, Items: Items{}},
	}); err != nil {
		return src, stockTid, fmt.Errorf("stock limited source transfer %v: %w", stockTid, err)
	}

	return src, tid, nil
}

func (e *Economy) CreateUnlimitedSource(u User) (src UnlimitedSource, tid TransferID, err error) {
	src = RandUnlimitedSource()

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.UnlimitedSourcePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return src, tid, fmt.Errorf("create unlimited source transfer %v: %w", tid, err)
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
				Many: ItemsMany{
					e.defaultCurrency: e.PlacePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				p: {},
			},
		}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return p, tid, fmt.Errorf("create place transfer %v: %w", tid, err)
	}

	return p, tid, nil
}

func (e *Economy) CreateGroup(u User) (g Group, tid TransferID, err error) {
	g = RandGroup()

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.GroupPrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				g: {},
			},
		}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return g, tid, fmt.Errorf("create group transfer %v: %w", tid, err)
	}

	return g, tid, nil
}

func (e *Economy) BuyUnlimitedAsset(u User, src UnlimitedSource, price Quantity) (a UnlimitedAsset, tid TransferID, err error) {
	if e.OwnsOne(u, src) {
		return a, tid, fmt.Errorf("user %v already owns unlimited source %v", u, src)
	}

	a = src.Create()

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: price,
				},
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

func (e *Economy) BuyLimitedAsset(u User, src LimitedSource, priceEach, qty Quantity) (a LimitedAsset, tid TransferID, err error) {
	a = src.Create()

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: priceEach * qty,
				},
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

var ErrEmptyPackage = errors.New("package needs at least one component")

var ErrSelfNestedPackage = errors.New("package cannot contain itself")

// PackageComponent is something a package source can hold: either an asset source, or the source of a nested package. Both are CanOwnOne and both grant their holder the right to issue what they create, which is all the ledger needs to know to reissue a bundle.
type PackageComponent = CanOwnOne

// CreatePackageSource mints a package source and hands it ownership of the given component sources. The package source holding the sources (rather than the assets) is what lets it reissue the whole bundle indefinitely, because holding a source entitles its holder to issue what that source creates.
// The components are transferred in after the handover, so a user who can't afford the package fails with nothing written rather than with their component sources stranded.
func (e *Economy) CreatePackageSource(u User, comps []PackageComponent) (src PackageSource, tid TransferID, err error) {
	if len(comps) == 0 {
		return src, tid, ErrEmptyPackage
	}

	src = RandPackageSource()

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.PackageSourcePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return src, tid, fmt.Errorf("create package source transfer %v: %w", tid, err)
	}

	if _, err := e.AddPackageComponents(u, src, comps); err != nil {
		return src, tid, err
	}

	return src, tid, nil
}

// AddPackageComponents moves component sources from u into an existing package source, so packages can be built up and nested. The caller has to own every source they pass in.
func (e *Economy) AddPackageComponents(u User, src PackageSource, comps []PackageComponent) ([]TransferID, error) {
	if len(comps) == 0 {
		return nil, nil
	}

	items := make(ItemsOne, len(comps))
	for _, c := range comps {
		if c == src {
			return nil, ErrSelfNestedPackage
		}
		items.Add(c)
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, Transfer{
		{Owner: u, Items: Items{One: items}},
		{Owner: src, Items: Items{}},
	}); err != nil {
		return nil, fmt.Errorf("add package components transfer %v: %w", tid, err)
	}

	return []TransferID{tid}, nil
}

// AddPackageComponent nests one package inside another, by moving its source into the outer one.
func (e *Economy) AddPackageComponent(u User, src PackageSource, inner PackageSource) ([]TransferID, error) {
	return e.AddPackageComponents(u, src, []PackageComponent{inner})
}

// BuyPackage sells a package: the buyer pays once and receives the package plus everything inside it, in a single transfer.
//
// A component the buyer already owns is skipped rather than failing the whole bundle, so overlapping packages can both be bought.
func (e *Economy) BuyPackage(u User, src PackageSource, price Quantity) (p Package, tid TransferID, err error) {
	p = src.Create()

	contents := e.ledger.state.packageContents(src)
	if len(contents) == 0 {
		return p, tid, ErrEmptyPackage
	}

	// the package itself, plus every component the buyer doesn't already have
	issued := ItemsOne{p: {}}
	for item := range contents {
		if e.OwnsOne(u, item) {
			continue
		}
		issued.Add(item)
	}

	tf := Transfer{
		{
			Owner: u,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: price,
				},
			},
		},
		{Owner: src, Items: Items{One: issued}},
	}

	tid = MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return p, tid, fmt.Errorf("buy package transfer %v: %w", tid, err)
	}

	return p, tid, nil
}

func (e *Economy) TransferHistory(n uint32) ([]TransferWithID, error) {
	return e.ledger.TransferHistory(int(n))
}

func (e *Economy) TransferHistoryOwner(n uint32, o Owner) ([]TransferWithID, error) {
	return e.ledger.TransferHistoryOwner(int(n), o)
}
