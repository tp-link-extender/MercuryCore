package ledger

import (
	"errors"
	"fmt"
	"time"
)

// Abstractions
type Economy struct {
	ledger                                                                          *Ledger
	defaultCurrency                                                                 Currency
	PlacePrice, GroupPrice, LimitedSourcePrice, UnlimitedSourcePrice, StipendAmount Quantity
	StipendTime                                                                     time.Duration
}

func NewEconomy(ledger *Ledger, placePrice, groupPrice, limitedSourcePrice, unlimitedSourcePrice, stipendAmount Quantity, stipendTime time.Duration) *Economy {
	return &Economy{
		ledger: ledger,
		// default 0 currency
		PlacePrice:           placePrice,
		GroupPrice:           groupPrice,
		LimitedSourcePrice:   limitedSourcePrice,
		UnlimitedSourcePrice: unlimitedSourcePrice,
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
	if ok || time.Since(time.Unix(0, int64(lastStipend.timestamp))) < e.StipendTime {
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

func (e *Economy) CreateLimitedSource(u User) (src LimitedSource, tid TransferID, err error) {
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

func (e *Economy) TransferHistory(n uint32) ([]TransferWithID, error) {
	return e.ledger.TransferHistory(int(n))
}

func (e *Economy) TransferHistoryOwner(n uint32, o Owner) ([]TransferWithID, error) {
	return e.ledger.TransferHistoryOwner(int(n), o)
}
