package main

import (
	"fmt"
	"sort"
	"time"

	"Economy/ledger"
)

type planner struct {
	ledger    *ledger.Ledger
	base      uint64
	seq       int
	batchIDs  []ledger.TransferID
	batchTFs  []ledger.Transfer
	batchSize int
	counts    map[string]int
}

func newPlanner(l *ledger.Ledger, batchSize int) *planner {
	if batchSize <= 0 {
		batchSize = 500
	}
	return &planner{
		ledger:    l,
		base:      uint64(time.Now().UnixNano()),
		batchSize: batchSize,
		counts:    make(map[string]int),
	}
}

func sortedStringKeys[V any](m map[string]V) []string {
	out := make([]string, 0, len(m))
	for key := range m {
		out = append(out, key)
	}
	sort.Strings(out)
	return out
}

func (p *planner) flush() error {
	if len(p.batchTFs) == 0 {
		return nil
	}
	if err := p.ledger.Import(p.batchIDs, p.batchTFs); err != nil {
		return fmt.Errorf("import prune batch: %w", err)
	}
	p.batchIDs = p.batchIDs[:0]
	p.batchTFs = p.batchTFs[:0]
	return nil
}

func (p *planner) emit(category string, tf ledger.Transfer) error {
	p.seq++
	tid := ledger.NewTransferID(p.base+uint64(p.seq), fmt.Sprintf("prune-%d", p.seq))
	p.batchIDs = append(p.batchIDs, tid)
	p.batchTFs = append(p.batchTFs, tf)
	p.counts[category]++
	if len(p.batchTFs) >= p.batchSize {
		return p.flush()
	}
	return nil
}

func (p *planner) plan(plan *prunePlan) error {
	for _, currency := range sortedUint32Keys(plan.balances) {
		users := plan.balances[currency]
		for _, user := range sortedStringKeys(users) {
			qty := users[user]
			if qty == 0 {
				continue
			}
			if err := p.emit("balance", ledger.Transfer{
				{Items: ledger.Items{Many: ledger.ItemsMany{ledger.Currency{Id: currency}: ledger.Quantity(qty)}}},
				{Owner: ledger.User{Id: user}},
			}); err != nil {
				return err
			}
		}
	}

	for _, id := range sortedUint32Keys(plan.places) {
		if err := p.emit("place", ledger.Transfer{
			{Owner: ledger.User{Id: plan.places[id]}},
			{Items: ledger.Items{One: ledger.ItemsOne{ledger.NewPlace(id): {}}}},
		}); err != nil {
			return err
		}
	}
	for _, id := range sortedStringKeys(plan.groups) {
		if err := p.emit("group", ledger.Transfer{
			{Owner: ledger.User{Id: plan.groups[id]}},
			{Items: ledger.Items{One: ledger.ItemsOne{ledger.NewGroup(id): {}}}},
		}); err != nil {
			return err
		}
	}

	for _, id := range sortedUint32Keys(plan.sources) {
		source := plan.sources[id]
		switch source.Kind {
		case sourceUnlimited:
			if err := p.emit("unlimitedSource", ledger.Transfer{
				{Owner: ledger.User{Id: source.Owner}},
				{Items: ledger.Items{One: ledger.ItemsOne{ledger.UnlimitedSource{Id: id}: {}}}},
			}); err != nil {
				return err
			}
		case sourceLimited:
			limitedSource := ledger.LimitedSource{Id: id}
			if err := p.emit("limitedSource", ledger.Transfer{
				{Owner: ledger.User{Id: source.Owner}},
				{Items: ledger.Items{One: ledger.ItemsOne{limitedSource: {}}}},
			}); err != nil {
				return err
			}
			total := plan.limitedStock[id]
			for _, qty := range plan.itemsMany[id] {
				total += qty
			}
			if total > 0 {
				if err := p.emit("limitedStock", ledger.Transfer{
					{Items: ledger.Items{Many: ledger.ItemsMany{ledger.LimitedAsset{Id: id}: ledger.Quantity(total)}}},
					{Owner: limitedSource},
				}); err != nil {
					return err
				}
			}
		}
	}

	for _, id := range sortedUint32Keys(plan.itemsOne) {
		for _, user := range sortedStringKeys(plan.itemsOne[id]) {
			if err := p.emit("unlimitedItem", ledger.Transfer{
				{Owner: ledger.UnlimitedSource{Id: id}, Items: ledger.Items{One: ledger.ItemsOne{ledger.UnlimitedAsset{Id: id}: {}}}},
				{Owner: ledger.User{Id: user}},
			}); err != nil {
				return err
			}
		}
	}

	for _, id := range sortedUint32Keys(plan.itemsMany) {
		for _, user := range sortedStringKeys(plan.itemsMany[id]) {
			qty := plan.itemsMany[id][user]
			if qty == 0 {
				continue
			}
			if err := p.emit("limitedItem", ledger.Transfer{
				{Owner: ledger.LimitedSource{Id: id}, Items: ledger.Items{Many: ledger.ItemsMany{ledger.LimitedAsset{Id: id}: ledger.Quantity(qty)}}},
				{Owner: ledger.User{Id: user}},
			}); err != nil {
				return err
			}
		}
	}

	return p.flush()
}
