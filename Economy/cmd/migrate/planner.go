package main

import (
	"fmt"
	"slices"
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

func (p *planner) emit(category string, tf ledger.Transfer) error {
	p.seq++
	tid := ledger.NewTransferID(p.base+uint64(p.seq), fmt.Sprintf("migrate-%d", p.seq))
	p.batchIDs = append(p.batchIDs, tid)
	p.batchTFs = append(p.batchTFs, tf)
	p.counts[category]++

	if len(p.batchTFs) >= p.batchSize {
		return p.flush()
	}
	return nil
}

func (p *planner) flush() error {
	if len(p.batchTFs) == 0 {
		return nil
	}
	if err := p.ledger.Import(p.batchIDs, p.batchTFs); err != nil {
		return fmt.Errorf("import migration batch: %w", err)
	}
	p.batchIDs = p.batchIDs[:0]
	p.batchTFs = p.batchTFs[:0]
	return nil
}

func (p *planner) plan(d *migrationData) error {
	// Final currency balances.
	for _, user := range d.sortedBalanceUsers() {
		units := d.balancesMicro[user] / microPerUnit
		if units == 0 {
			continue
		}
		if err := p.emit("balance", ledger.Transfer{
			{Owner: ledger.User{Id: user}},
			{
				Items: ledger.Items{
					Many: ledger.ItemsMany{ledger.Currency{Id: 0}: ledger.Quantity(units)},
				},
			},
		}); err != nil {
			return err
		}
	}

	// Places and groups.
	for _, id := range d.sortedPlaceIDs() {
		owner, ok := d.placeOwner(id)
		if !ok {
			return fmt.Errorf("place %d has no owner", id)
		}
		if err := p.emit("place", ledger.Transfer{
			{Owner: ledger.User{Id: owner}},
			{
				Items: ledger.Items{One: ledger.ItemsOne{ledger.NewPlace(id): {}}},
			},
		}); err != nil {
			return err
		}
	}
	for _, id := range d.sortedGroupIDs() {
		owner, ok := d.groupOwner(id)
		if !ok {
			return fmt.Errorf("group %q has no owner", id)
		}
		if err := p.emit("group", ledger.Transfer{
			{Owner: ledger.User{Id: owner}},
			{
				Items: ledger.Items{One: ledger.ItemsOne{ledger.NewGroup(id): {}}},
			},
		}); err != nil {
			return err
		}
	}

	order, err := d.packageOrder()
	if err != nil {
		return err
	}

	// Package sources first, parents before children, so nested sources have an owner to move into.
	for _, pkg := range order {
		src := ledger.PackageSource{Id: pkg}
		if parent, nested := d.packageParent(pkg); nested {
			if err := p.emit("packageSource", ledger.Transfer{
				{Owner: ledger.PackageSource{Id: parent}},
				{
					Items: ledger.Items{One: ledger.ItemsOne{src: {}}},
				},
			}); err != nil {
				return err
			}
			continue
		}

		owner, ok := d.sourceOwner(pkg)
		if !ok {
			return fmt.Errorf("package %d has no source owner", pkg)
		}
		if err := p.emit("packageSource", ledger.Transfer{
			{Owner: ledger.User{Id: owner}},
			{
				Items: ledger.Items{One: ledger.ItemsOne{src: {}}},
			},
		}); err != nil {
			return err
		}
	}

	// Sources for standalone assets.
	for _, id := range d.sortedAssetIDs() {
		a := d.assets[id]
		if a.Type == 32 || d.isChild(id) {
			continue
		}
		owner, ok := d.sourceOwner(id)
		if !ok {
			return fmt.Errorf("asset %d has no source owner", id)
		}
		if err := p.emit("assetSource", ledger.Transfer{
			{Owner: ledger.User{Id: owner}},
			{
				Items: ledger.Items{One: ledger.ItemsOne{ledger.UnlimitedSource{Id: id}: {}}},
			},
		}); err != nil {
			return err
		}
	}

	// Sources for normal assets contained in packages.
	for _, pkg := range order {
		children := append([]uint32(nil), d.children[pkg]...)
		slices.Sort(children)
		for _, child := range children {
			if d.assets[child].Type == 32 {
				continue
			}
			if err := p.emit("packageChildSource", ledger.Transfer{
				{Owner: ledger.PackageSource{Id: pkg}},
				{
					Items: ledger.Items{One: ledger.ItemsOne{ledger.UnlimitedSource{Id: child}: {}}},
				},
			}); err != nil {
				return err
			}
		}
	}

	// Issue asset items to their old owners.
	for _, id := range d.sortedAssetIDs() {
		a := d.assets[id]
		if a.Type == 32 || d.isChild(id) {
			continue
		}
		src := ledger.UnlimitedSource{Id: id}
		for _, owner := range sortedUsers(d.owners[id]) {
			if err := p.emit("assetOwner", ledger.Transfer{
				{
					Owner: src,
					Items: ledger.Items{One: ledger.ItemsOne{ledger.UnlimitedAsset{Id: id}: {}}},
				},
				{Owner: ledger.User{Id: owner}},
			}); err != nil {
				return err
			}
		}
	}

	// Packages and their child asset items.
	for _, pkg := range order {
		src := ledger.PackageSource{Id: pkg}
		for _, owner := range sortedUsers(d.owners[pkg]) {
			if err := p.emit("packageOwner", ledger.Transfer{
				{
					Owner: src,
					Items: ledger.Items{One: ledger.ItemsOne{ledger.Package{Id: pkg}: {}}},
				},
				{Owner: ledger.User{Id: owner}},
			}); err != nil {
				return err
			}
		}

		children := append([]uint32(nil), d.children[pkg]...)
		slices.Sort(children)
		for _, child := range children {
			if d.assets[child].Type == 32 {
				continue
			}
			for _, owner := range sortedUsers(d.owners[child]) {
				if err := p.emit("packageChildOwner", ledger.Transfer{
					{
						Owner: src,
						Items: ledger.Items{One: ledger.ItemsOne{ledger.UnlimitedAsset{Id: child}: {}}},
					},
					{Owner: ledger.User{Id: owner}},
				}); err != nil {
					return err
				}
			}
		}
	}

	return p.flush()
}
