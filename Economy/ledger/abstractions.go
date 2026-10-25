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
	return e.ledger.OwnsOne(o, i)
}

func (e *Economy) OwnsMany(o Owner, i CanOwnMany) Quantity {
	return e.ledger.OwnsMany(o, i)
}

func (e *Economy) OwnersOne(i CanOwnOne) OwnersOne {
	return e.ledger.OwnersOne(i)
}

func (e *Economy) OwnersMany(i CanOwnMany) OwnersMany {
	return e.ledger.OwnersMany(i)
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
	return e.ledger.Inventory(o)
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
	// The eligibility check runs inside the ledger lock, so two simultaneous requests can't both pass it and mint two stipends.
	if err := e.ledger.transferWithCheck(tid, tf, func(s *State) error {
		lastStipend, ok := s.userLastStipend[user]
		if ok && time.Since(time.Unix(0, int64(lastStipend.timestamp))) < e.StipendTime {
			return ErrStipendNotReady
		}
		return nil
	}); err != nil {
		if errors.Is(err, ErrStipendNotReady) {
			return tid, ErrStipendNotReady
		}
		return tid, fmt.Errorf("stipend transfer %v: %w", tid, err)
	}

	return tid, nil
}

var ErrNoStock = errors.New("limited source needs a stock of at least one")

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

	stock := Transfer{
		{Items: Items{
			Many: ItemsMany{
				src.Create(): qty,
			},
		}},
		{Owner: src, Items: Items{}},
	}

	tid = MakeTransferID()
	stockTid := MakeTransferID()
	if err := e.ledger.transferBatch([]TransferID{tid, stockTid}, []Transfer{handover, stock}); err != nil {
		return src, tid, fmt.Errorf("create limited source transfers: %w", err)
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

// ErrUnsupportedPackageComponent is returned for a component a package can't reissue, which is anything that isn't an unlimited asset source or a nested package source.
// Limited sources are the awkward case: their asset is CanOwnMany, so it can't travel in a One and the contents walk would drop it without a word, leaving the buyer short of what they paid for.
var ErrUnsupportedPackageComponent = errors.New("package components must be unlimited asset sources or package sources")

// validatePackageComponents rejects components the contents walk can't hand over. It runs before anything is written, so a rejected component never costs the caller anything.
func validatePackageComponents(comps []PackageComponent) error {
	for _, c := range comps {
		switch c.(type) {
		case UnlimitedSource, PackageSource:
		default:
			return fmt.Errorf("%w: %v", ErrUnsupportedPackageComponent, c)
		}
	}
	return nil
}

// PackageComponent is something a package source can hold: either an asset source, or the source of a nested package. Both are CanOwnOne and both grant their holder the right to issue what they create, which is all the ledger needs to know to reissue a bundle.
type PackageComponent = CanOwnOne

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

// CreatePackageSource mints a package source and hands it ownership of the given component sources. The package source holding the sources (rather than the assets) is what lets it reissue the whole bundle indefinitely, because holding a source entitles its holder to issue what that source creates.
// The handover and the component transfer go in one batch, so a user who can't afford the package or doesn't own a component is charged nothing and left with nothing.
func (e *Economy) CreatePackageSource(u User, comps []PackageComponent) (src PackageSource, tid TransferID, err error) {
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

	components := Transfer{
		{Owner: u, Items: Items{One: items}},
		{Owner: src, Items: Items{}},
	}

	tid = MakeTransferID()
	componentsTid := MakeTransferID()
	if err := e.ledger.transferBatch([]TransferID{tid, componentsTid}, []Transfer{handover, components}); err != nil {
		return src, tid, fmt.Errorf("create package source transfers: %w", err)
	}

	return src, tid, nil
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
	tid = MakeTransferID()

	// Contents and the buyer's inventory are read inside the same lock that applies the transfer, so a package can't change between pricing it and selling it.
	err = e.ledger.transferPrepared(tid, func(s *State) (Transfer, error) {
		contents := s.packageContents(src)
		if len(contents) == 0 {
			return Transfer{}, ErrEmptyPackage
		}

		// the package itself, plus every component the buyer doesn't already have
		issued := ItemsOne{p: {}}
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
					Many: ItemsMany{
						e.defaultCurrency: price,
					},
				},
			},
			{Owner: src, Items: Items{One: issued}},
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
