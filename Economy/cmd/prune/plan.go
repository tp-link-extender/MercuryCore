package main

import (
	"fmt"
	"sort"
	"strings"

	"Economy/ledger"
)

type dbAsset struct {
	ID   uint32 `json:"id"`
	Type int    `json:"type"`
	Name string `json:"name"`
}

type dbPackageChild struct {
	PackageID uint32 `json:"packageId"`
	ChildID   uint32 `json:"childId"`
}

type sourceKind int

const (
	sourceUnlimited sourceKind = iota
	sourceLimited
)

type sourcePlan struct {
	ID    uint32
	Kind  sourceKind
	Owner string
}

type prunePlan struct {
	removed         map[uint32]removedAsset
	orphanImages    []uint32
	balances        map[uint32]map[string]uint64 // currency ID -> user -> quantity
	places          map[uint32]string
	groups          map[string]string
	sources         map[uint32]sourcePlan
	itemsOne        map[uint32]map[string]struct{}
	itemsMany       map[uint32]map[string]uint64
	limitedStock    map[uint32]uint64
	burnedCurrency  map[uint32]uint64
	packageBurned   map[uint32]uint64
	movedCurrency   map[uint32]uint64
	packageChildren int
	retainedAssets  int
	warnings        []string
}

func (p *prunePlan) removedIDs() []uint32 {
	ids := make([]uint32, 0, len(p.removed))
	for id := range p.removed {
		ids = append(ids, id)
	}
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })
	return ids
}

func (p *prunePlan) removedIDStrings() []string {
	ids := p.removedIDs()
	out := make([]string, len(ids))
	for i, id := range ids {
		out[i] = fmt.Sprintf("%d", id)
	}
	return out
}

func (p *prunePlan) totalBalances() uint64 {
	var total uint64
	for _, users := range p.balances {
		for _, qty := range users {
			total += qty
		}
	}
	return total
}

func (p *prunePlan) totalBurned() uint64 {
	var total uint64
	for _, qty := range p.burnedCurrency {
		total += qty
	}
	return total
}

func (p *prunePlan) totalMoved() uint64 {
	var total uint64
	for _, qty := range p.movedCurrency {
		total += qty
	}
	return total
}

func (p *prunePlan) totalPackageBurned() uint64 {
	var total uint64
	for _, qty := range p.packageBurned {
		total += qty
	}
	return total
}

func collectPrimaryRemoved(
	led *ledger.Ledger,
	dbAssets map[uint32]dbAsset,
	packageChildren []dbPackageChild,
	removeTypes map[int]struct{},
) (map[uint32]string, int, error) {
	removed := make(map[uint32]string)
	children := make(map[uint32]struct{})
	for id, asset := range dbAssets {
		if _, ok := removeTypes[asset.Type]; ok {
			removed[id] = "type"
		}
	}
	for _, pc := range packageChildren {
		removed[pc.PackageID] = "package"
		removed[pc.ChildID] = "packageChild"
		children[pc.ChildID] = struct{}{}
	}

	oneItems := led.AllOneItems()
	packageSources := make(map[uint32]struct{})
	for item := range oneItems {
		switch item := item.(type) {
		case ledger.PackageSource:
			packageSources[item.Id] = struct{}{}
			removed[item.Id] = "package"
		case ledger.Package:
			removed[item.Id] = "package"
		}
	}
	for id, asset := range dbAssets {
		if asset.Type == 32 {
			packageSources[id] = struct{}{}
			removed[id] = "package"
		}
	}
	for _, pc := range packageChildren {
		packageSources[pc.PackageID] = struct{}{}
	}

	seen := make(map[uint32]struct{})
	var walk func(uint32) error
	walk = func(id uint32) error {
		if _, ok := seen[id]; ok {
			return nil
		}
		seen[id] = struct{}{}
		removed[id] = "package"

		inv := led.Inventory(ledger.PackageSource{Id: id})
		for item := range inv.One {
			switch item := item.(type) {
			case ledger.PackageSource:
				packageSources[item.Id] = struct{}{}
				if err := walk(item.Id); err != nil {
					return err
				}
			case ledger.UnlimitedSource:
				removed[item.Id] = "packageChild"
				children[item.Id] = struct{}{}
			case ledger.LimitedSource:
				removed[item.Id] = "packageChild"
				children[item.Id] = struct{}{}
			case ledger.Package:
				removed[item.Id] = "packageChild"
				children[item.Id] = struct{}{}
			default:
				return fmt.Errorf("package source %d holds unexpected item %v", id, item)
			}
		}
		for item, qty := range inv.Many {
			if qty == 0 {
				continue
			}
			if _, ok := item.(ledger.Currency); !ok {
				return fmt.Errorf("package source %d holds unexpected many item %v", id, item)
			}
		}
		return nil
	}

	// A source owned by a package source is package content even if the package itself is missing from the asset table.
	for item, owners := range oneItems {
		source, ok := item.(ledger.Source)
		if !ok {
			continue
		}
		for owner := range owners {
			ps, ok := owner.(ledger.PackageSource)
			if !ok {
				continue
			}
			packageSources[ps.Id] = struct{}{}
			removed[source.ID()] = "packageChild"
			children[source.ID()] = struct{}{}
		}
	}

	for id := range packageSources {
		if err := walk(id); err != nil {
			return nil, 0, err
		}
	}

	return removed, len(children), nil
}

func addSource(plan *prunePlan, id uint32, kind sourceKind, owners ledger.OwnersOne) error {
	if existing, ok := plan.sources[id]; ok {
		if existing.Kind != kind {
			return fmt.Errorf("asset %d has both an unlimited and a limited source", id)
		}
		return nil
	}
	owner, err := singleUserOwner(owners)
	if err != nil {
		return fmt.Errorf("asset %d source: %w", id, err)
	}
	if owner == "" {
		return fmt.Errorf("asset %d source has no user owner", id)
	}
	plan.sources[id] = sourcePlan{ID: id, Kind: kind, Owner: owner}
	return nil
}

func singleUserOwner(owners ledger.OwnersOne) (string, error) {
	if len(owners) == 0 {
		return "", nil
	}
	if len(owners) > 1 {
		users := make([]string, 0, len(owners))
		for owner := range owners {
			users = append(users, fmt.Sprintf("%v", owner))
		}
		sort.Strings(users)
		return "", fmt.Errorf("has multiple owners (%s), but the ledger allows one", strings.Join(users, ", "))
	}
	for owner := range owners {
		user, ok := owner.(ledger.User)
		if !ok {
			return "", fmt.Errorf("is owned by %T, not a user", owner)
		}
		return user.Id, nil
	}
	return "", nil
}

func userOwners(owners ledger.OwnersOne) (map[string]struct{}, error) {
	out := make(map[string]struct{}, len(owners))
	for owner := range owners {
		user, ok := owner.(ledger.User)
		if !ok {
			return nil, fmt.Errorf("is owned by %T, not a user", owner)
		}
		out[user.Id] = struct{}{}
	}
	return out, nil
}

func (p *prunePlan) addBalance(currency uint32, user string, qty uint64) {
	if qty == 0 {
		return
	}
	users := p.balances[currency]
	if users == nil {
		users = make(map[string]uint64)
		p.balances[currency] = users
	}
	users[user] += qty
}

func resolveUserOwner(led *ledger.Ledger, owner ledger.Owner) (ledger.User, bool) {
	seen := make(map[ledger.Owner]struct{})
	for {
		if _, ok := seen[owner]; ok {
			return ledger.User{}, false
		}
		seen[owner] = struct{}{}
		switch current := owner.(type) {
		case ledger.User:
			return current, true
		case ledger.UnlimitedSource:
			next, ok := singleOwner(led, current)
			if !ok {
				return ledger.User{}, false
			}
			owner = next
		case ledger.LimitedSource:
			next, ok := singleOwner(led, current)
			if !ok {
				return ledger.User{}, false
			}
			owner = next
		case ledger.PackageSource:
			next, ok := singleOwner(led, current)
			if !ok {
				return ledger.User{}, false
			}
			owner = next
		default:
			return ledger.User{}, false
		}
	}
}

func singleOwner(led *ledger.Ledger, source ledger.CanOwnOne) (ledger.Owner, bool) {
	owners := led.OwnersOne(source)
	if len(owners) != 1 {
		return nil, false
	}
	for owner := range owners {
		return owner, true
	}
	return nil, false
}

func sortedUint32Keys[V any](m map[uint32]V) []uint32 {
	out := make([]uint32, 0, len(m))
	for id := range m {
		out = append(out, id)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}

func buildPlan(
	led *ledger.Ledger,
	assets []dbAsset,
	packageChildren []dbPackageChild,
	removeTypes map[int]struct{},
	dropOrphans bool,
	orphanImagesFn func([]uint32) ([]uint32, error),
) (*prunePlan, error) {
	dbAssets := make(map[uint32]dbAsset, len(assets))
	for _, a := range assets {
		dbAssets[a.ID] = a
	}

	primary, packageChildCount, err := collectPrimaryRemoved(led, dbAssets, packageChildren, removeTypes)
	if err != nil {
		return nil, err
	}

	var orphanImages []uint32
	if orphanImagesFn != nil {
		orphanImages, err = orphanImagesFn(sortedUint32Keys(primary))
		if err != nil {
			return nil, fmt.Errorf("find orphan image assets: %w", err)
		}
	}

	removed := make(map[uint32]string, len(primary)+len(orphanImages))
	for id, reason := range primary {
		removed[id] = reason
	}
	for _, id := range orphanImages {
		removed[id] = "orphanImage"
	}

	plan := &prunePlan{
		removed:         make(map[uint32]removedAsset, len(removed)),
		orphanImages:    orphanImages,
		balances:        make(map[uint32]map[string]uint64),
		places:          make(map[uint32]string),
		groups:          make(map[string]string),
		sources:         make(map[uint32]sourcePlan),
		itemsOne:        make(map[uint32]map[string]struct{}),
		itemsMany:       make(map[uint32]map[string]uint64),
		limitedStock:    make(map[uint32]uint64),
		burnedCurrency:  make(map[uint32]uint64),
		packageBurned:   make(map[uint32]uint64),
		movedCurrency:   make(map[uint32]uint64),
		packageChildren: packageChildCount,
	}
	for id := range dbAssets {
		if _, ok := removed[id]; !ok {
			plan.retainedAssets++
		}
	}

	oneItems := led.AllOneItems()
	manyItems := led.AllManyItems()

	for item, owners := range oneItems {
		switch item := item.(type) {
		case ledger.PackageSource:
			removed[item.Id] = "package"
			continue
		case ledger.Package:
			removed[item.Id] = "package"
			continue
		case ledger.Place:
			owner, err := singleUserOwner(owners)
			if err != nil {
				return nil, fmt.Errorf("place %d: %w", item.ID(), err)
			}
			if owner != "" {
				plan.places[item.ID()] = owner
			} else {
				plan.warnings = append(plan.warnings, fmt.Sprintf("place %d has no owner and will stay unowned", item.ID()))
			}
			continue
		case ledger.Group:
			owner, err := singleUserOwner(owners)
			if err != nil {
				return nil, fmt.Errorf("group %q: %w", item.ID(), err)
			}
			if owner != "" {
				plan.groups[item.ID()] = owner
			} else {
				plan.warnings = append(plan.warnings, fmt.Sprintf("group %q has no owner and will stay unowned", item.ID()))
			}
			continue
		}

		numeric, ok := item.(ledger.NumericItem)
		if !ok {
			return nil, fmt.Errorf("unexpected one-per-owner item %T", item)
		}
		id := numeric.ID()
		if _, drop := removed[id]; drop {
			continue
		}
		if _, known := dbAssets[id]; !known {
			if !dropOrphans {
				return nil, fmt.Errorf("ledger item %v has no matching asset in SurrealDB (use --drop-orphans to drop it)", item)
			}
			removed[id] = "ledgerOrphan"
			continue
		}

		switch item := item.(type) {
		case ledger.UnlimitedSource:
			if err := addSource(plan, id, sourceUnlimited, owners); err != nil {
				return nil, err
			}
		case ledger.LimitedSource:
			if err := addSource(plan, id, sourceLimited, owners); err != nil {
				return nil, err
			}
			stock := led.Inventory(item).Many[ledger.LimitedAsset{Id: id}]
			plan.limitedStock[id] = uint64(stock)
		case ledger.UnlimitedAsset:
			users, err := userOwners(owners)
			if err != nil {
				return nil, fmt.Errorf("unlimited asset %d: %w", id, err)
			}
			plan.itemsOne[id] = users
		default:
			return nil, fmt.Errorf("unexpected one-per-owner item %v", item)
		}
	}

	for item, owners := range manyItems {
		currency, isCurrency := item.(ledger.Currency)
		if isCurrency {
			for owner, qty := range owners {
				if qty == 0 {
					continue
				}
				user, ok := owner.(ledger.User)
				if ok {
					plan.addBalance(currency.Id, user.Id, uint64(qty))
					continue
				}
				switch owner := owner.(type) {
				case ledger.PackageSource:
					plan.burnedCurrency[currency.Id] += uint64(qty)
					plan.packageBurned[currency.Id] += uint64(qty)
				case ledger.UnlimitedSource:
					if _, isRemoved := removed[owner.Id]; isRemoved {
						plan.burnedCurrency[currency.Id] += uint64(qty)
						continue
					}
					user, ok := resolveUserOwner(led, owner)
					if !ok {
						plan.warnings = append(plan.warnings, fmt.Sprintf("burning %d of currency %d held by %v", qty, currency.Id, owner))
						plan.burnedCurrency[currency.Id] += uint64(qty)
						continue
					}
					plan.addBalance(currency.Id, user.Id, uint64(qty))
					plan.movedCurrency[currency.Id] += uint64(qty)
				case ledger.LimitedSource:
					if _, isRemoved := removed[owner.Id]; isRemoved {
						plan.burnedCurrency[currency.Id] += uint64(qty)
						continue
					}
					user, ok := resolveUserOwner(led, owner)
					if !ok {
						plan.warnings = append(plan.warnings, fmt.Sprintf("burning %d of currency %d held by %v", qty, currency.Id, owner))
						plan.burnedCurrency[currency.Id] += uint64(qty)
						continue
					}
					plan.addBalance(currency.Id, user.Id, uint64(qty))
					plan.movedCurrency[currency.Id] += uint64(qty)
				default:
					plan.warnings = append(plan.warnings, fmt.Sprintf("burning %d of currency %d held by %T", qty, currency.Id, owner))
					plan.burnedCurrency[currency.Id] += uint64(qty)
				}
			}
			continue
		}

		limited, isLimited := item.(ledger.LimitedAsset)
		if !isLimited {
			return nil, fmt.Errorf("unexpected many-per-owner item %T", item)
		}
		id := limited.Id
		if _, drop := removed[id]; drop {
			continue
		}
		if _, known := dbAssets[id]; !known {
			if !dropOrphans {
				return nil, fmt.Errorf("ledger item %v has no matching asset in SurrealDB (use --drop-orphans to drop it)", limited)
			}
			removed[id] = "ledgerOrphan"
			continue
		}
		users := make(map[string]uint64, len(owners))
		for owner, qty := range owners {
			if qty == 0 {
				continue
			}
			switch owner := owner.(type) {
			case ledger.User:
				users[owner.Id] += uint64(qty)
			case ledger.LimitedSource:
				if owner.Id != id {
					return nil, fmt.Errorf("limited asset %d is held by unrelated source %d", id, owner.Id)
				}
				// The source's own copy is its remaining stock, captured from its inventory below.
			default:
				return nil, fmt.Errorf("limited asset %d is owned by %T, not a user", id, owner)
			}
		}
		if len(users) > 0 {
			plan.itemsMany[id] = users
		}
	}

	for id, source := range plan.sources {
		switch source.Kind {
		case sourceUnlimited:
			if _, ok := plan.itemsMany[id]; ok {
				return nil, fmt.Errorf("asset %d has both an unlimited source and limited items", id)
			}
		case sourceLimited:
			if _, ok := plan.itemsOne[id]; ok {
				return nil, fmt.Errorf("asset %d has both a limited source and unlimited items", id)
			}
		}
	}
	for id := range plan.itemsOne {
		source, ok := plan.sources[id]
		if !ok || source.Kind != sourceUnlimited {
			return nil, fmt.Errorf("unlimited asset %d has no unlimited source", id)
		}
	}
	for id := range plan.itemsMany {
		source, ok := plan.sources[id]
		if !ok || source.Kind != sourceLimited {
			return nil, fmt.Errorf("limited asset %d has no limited source", id)
		}
	}

	for id, reason := range removed {
		asset := dbAssets[id]
		plan.removed[id] = removedAsset{ID: id, Type: asset.Type, Name: asset.Name, Reason: reason}
	}
	return plan, nil
}
