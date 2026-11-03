package main

import (
	"fmt"
	"time"

	"Economy/ledger"
)

func verifyPlan(path string, plan *prunePlan) []string {
	var problems []string

	l, err := ledger.NewLedgerWithTimeout(path, 10*time.Second)
	if err != nil {
		return []string{fmt.Sprintf("reopen ledger: %v", err)}
	}
	defer l.Close()

	for currency, users := range plan.balances {
		got := l.OwnersMany(ledger.Currency{Id: currency})
		for owner, qty := range got {
			if qty == 0 {
				continue
			}
			user, ok := owner.(ledger.User)
			if !ok {
				problems = append(problems, fmt.Sprintf("currency %d is owned by %T, not a user", currency, owner))
				continue
			}
			if users[user.Id] != uint64(qty) {
				problems = append(problems, fmt.Sprintf("currency %d balance for %s is %d, expected %d", currency, user.Id, qty, users[user.Id]))
			}
		}
		for user, qty := range users {
			if uint64(got[ledger.User{Id: user}]) != qty {
				problems = append(problems, fmt.Sprintf("currency %d balance for %s is %d, expected %d", currency, user, got[ledger.User{Id: user}], qty))
			}
		}
	}

	for id, owner := range plan.places {
		if !l.OwnsOne(ledger.User{Id: owner}, ledger.NewPlace(id)) {
			problems = append(problems, fmt.Sprintf("place %d is not owned by %s", id, owner))
		}
	}
	for id, owner := range plan.groups {
		if !l.OwnsOne(ledger.User{Id: owner}, ledger.NewGroup(id)) {
			problems = append(problems, fmt.Sprintf("group %q is not owned by %s", id, owner))
		}
	}

	for id, source := range plan.sources {
		var item ledger.CanOwnOne
		if source.Kind == sourceUnlimited {
			item = ledger.UnlimitedSource{Id: id}
		} else {
			item = ledger.LimitedSource{Id: id}
		}
		if !l.OwnsOne(ledger.User{Id: source.Owner}, item) {
			problems = append(problems, fmt.Sprintf("source %v is not owned by %s", item, source.Owner))
		}
		if source.Kind == sourceLimited {
			stock := l.Inventory(ledger.LimitedSource{Id: id}).Many[ledger.LimitedAsset{Id: id}]
			if uint64(stock) != plan.limitedStock[id] {
				problems = append(problems, fmt.Sprintf("limited source %d stock is %d, expected %d", id, stock, plan.limitedStock[id]))
			}
		}
	}

	for id, owners := range plan.itemsOne {
		got := l.OwnersOne(ledger.UnlimitedAsset{Id: id})
		for owner := range got {
			user, ok := owner.(ledger.User)
			if !ok {
				problems = append(problems, fmt.Sprintf("unlimited asset %d has non-user owner %T", id, owner))
				continue
			}
			if _, ok := owners[user.Id]; !ok {
				problems = append(problems, fmt.Sprintf("unlimited asset %d has unexpected owner %s", id, user.Id))
			}
		}
		for owner := range owners {
			if !l.OwnsOne(ledger.User{Id: owner}, ledger.UnlimitedAsset{Id: id}) {
				problems = append(problems, fmt.Sprintf("unlimited asset %d is not owned by %s", id, owner))
			}
		}
	}

	for id, owners := range plan.itemsMany {
		got := l.OwnersMany(ledger.LimitedAsset{Id: id})
		for owner, qty := range got {
			if qty == 0 {
				continue
			}
			switch owner := owner.(type) {
			case ledger.User:
				if owners[owner.Id] != uint64(qty) {
					problems = append(problems, fmt.Sprintf("limited asset %d quantity for %s is %d, expected %d", id, owner.Id, qty, owners[owner.Id]))
				}
			case ledger.LimitedSource:
				if owner.Id != id {
					problems = append(problems, fmt.Sprintf("limited asset %d is held by unrelated source %d", id, owner.Id))
				}
			default:
				problems = append(problems, fmt.Sprintf("limited asset %d has non-user owner %T", id, owner))
			}
		}
		for owner, qty := range owners {
			if uint64(got[ledger.User{Id: owner}]) != qty {
				problems = append(problems, fmt.Sprintf("limited asset %d quantity for %s is %d, expected %d", id, owner, got[ledger.User{Id: owner}], qty))
			}
		}
	}

	for id := range plan.removed {
		for _, item := range []ledger.CanOwnOne{
			ledger.UnlimitedSource{Id: id},
			ledger.LimitedSource{Id: id},
			ledger.UnlimitedAsset{Id: id},
			ledger.PackageSource{Id: id},
			ledger.Package{Id: id},
		} {
			if len(l.OwnersOne(item)) > 0 {
				problems = append(problems, fmt.Sprintf("removed item %v is still owned", item))
			}
		}
		if len(l.OwnersMany(ledger.LimitedAsset{Id: id})) > 0 {
			problems = append(problems, fmt.Sprintf("removed limited asset %d is still owned", id))
		}
	}

	for item := range l.AllOneItems() {
		switch item.Type() {
		case ledger.TypePackage, ledger.TypePackageSource:
			problems = append(problems, fmt.Sprintf("package item %v still exists", item))
		}
	}
	if items := l.PackageItems(); len(items) > 0 {
		problems = append(problems, fmt.Sprintf("%d package items still exist", len(items)))
	}

	var total uint64
	for item, owners := range l.AllManyItems() {
		if _, ok := item.(ledger.Currency); !ok {
			continue
		}
		for _, qty := range owners {
			total += uint64(qty)
		}
	}
	if total != plan.totalBalances() {
		problems = append(problems, fmt.Sprintf("total currency is %d, expected %d", total, plan.totalBalances()))
	}

	return problems
}
