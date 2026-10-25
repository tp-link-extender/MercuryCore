package main

import (
	"fmt"

	"Economy/ledger"
)

func verifyLedger(path string, d *migrationData) []string {
	var problems []string

	l, err := ledger.NewLedger(path)
	if err != nil {
		return []string{fmt.Sprintf("reopen ledger: %v", err)}
	}
	defer l.Close()

	checkSource := func(kind string, src ledger.CanOwnOne) {
		if len(l.OwnersOne(src)) == 0 {
			problems = append(problems, fmt.Sprintf("%s %v is not issued", kind, src))
		}
	}

	for _, id := range d.sortedAssetIDs() {
		a := d.assets[id]
		if a.Type == 32 {
			src := ledger.PackageSource{Id: id}
			checkSource("package source", src)
			for _, owner := range sortedUsers(d.owners[id]) {
				if !l.OwnsOne(ledger.User{Id: owner}, ledger.Package{Id: id}) {
					problems = append(problems, fmt.Sprintf("package %d is not owned by %s", id, owner))
				}
			}
			contents := l.PackageContents(src)
			for _, child := range d.children[id] {
				if d.assets[child].Type == 32 {
					if !contents.Has(ledger.Package{Id: child}) {
						problems = append(problems, fmt.Sprintf("nested package %d is missing from package %d", child, id))
					}
					if !l.OwnsOne(src, ledger.PackageSource{Id: child}) {
						problems = append(problems, fmt.Sprintf("package %d does not hold nested source %d", id, child))
					}
				} else {
					if !contents.Has(ledger.UnlimitedAsset{Id: child}) {
						problems = append(problems, fmt.Sprintf("asset %d is missing from package %d", child, id))
					}
					if !l.OwnsOne(src, ledger.UnlimitedSource{Id: child}) {
						problems = append(problems, fmt.Sprintf("package %d does not hold source %d", id, child))
					}
					for _, owner := range sortedUsers(d.owners[child]) {
						if !l.OwnsOne(ledger.User{Id: owner}, ledger.UnlimitedAsset{Id: child}) {
							problems = append(problems, fmt.Sprintf("asset %d is not owned by %s", child, owner))
						}
					}
				}
			}
			continue
		}

		if d.isChild(id) {
			continue
		}
		src := ledger.UnlimitedSource{Id: id}
		checkSource("asset source", src)
		for _, owner := range sortedUsers(d.owners[id]) {
			if !l.OwnsOne(ledger.User{Id: owner}, ledger.UnlimitedAsset{Id: id}) {
				problems = append(problems, fmt.Sprintf("asset %d is not owned by %s", id, owner))
			}
		}
	}

	for _, id := range d.sortedPlaceIDs() {
		owner, ok := d.placeOwner(id)
		if !ok {
			problems = append(problems, fmt.Sprintf("place %d has no expected owner", id))
			continue
		}
		if !l.OwnsOne(ledger.User{Id: owner}, ledger.NewPlace(id)) {
			problems = append(problems, fmt.Sprintf("place %d is not owned by %s", id, owner))
		}
	}
	for _, id := range d.sortedGroupIDs() {
		owner, ok := d.groupOwner(id)
		if !ok {
			problems = append(problems, fmt.Sprintf("group %q has no expected owner", id))
			continue
		}
		if !l.OwnsOne(ledger.User{Id: owner}, ledger.NewGroup(id)) {
			problems = append(problems, fmt.Sprintf("group %q is not owned by %s", id, owner))
		}
	}

	for _, user := range d.sortedBalanceUsers() {
		expected := ledger.Quantity(d.balancesMicro[user] / microPerUnit)
		if got := l.OwnsMany(ledger.User{Id: user}, ledger.Currency{Id: 0}); got != expected {
			problems = append(problems, fmt.Sprintf("balance for %s is %d, expected %d", user, got, expected))
		}
	}

	return problems
}
