package main

import (
	"fmt"
	"sort"
	"strings"

	"Economy/ledger"
)

const microPerUnit = 1_000_000

type migrationData struct {
	assets        map[uint32]legacyAsset
	creators      map[uint32][]legacyCreator
	owners        map[uint32]map[string]struct{}
	children      map[uint32][]uint32
	parents       map[uint32]map[uint32]struct{}
	places        map[uint32]legacyPlace
	placeOwners   map[uint32]map[string]struct{}
	groups        map[string]legacyGroup
	groupOwners   map[string]map[string]struct{}
	balancesMicro map[string]uint64
	dust          map[string]uint64
	lastStipends  map[string]uint64
	fallbackUser  string
	warnings      []string
	errors        []string
}

func buildMigrationData(s *legacySnapshot, fallbackUser string, skipOrphans bool) *migrationData {
	d := &migrationData{
		assets:        make(map[uint32]legacyAsset),
		creators:      make(map[uint32][]legacyCreator),
		owners:        make(map[uint32]map[string]struct{}),
		children:      make(map[uint32][]uint32),
		parents:       make(map[uint32]map[uint32]struct{}),
		places:        make(map[uint32]legacyPlace),
		placeOwners:   make(map[uint32]map[string]struct{}),
		groups:        make(map[string]legacyGroup),
		groupOwners:   make(map[string]map[string]struct{}),
		balancesMicro: s.BalancesMicro,
		dust:          s.DustMicro,
		lastStipends:  s.LastStipends,
		fallbackUser:  fallbackUser,
	}
	d.warnings = append(d.warnings, s.Warnings...)

	if fallbackUser != "" {
		d.validateUserID(fallbackUser, "fallback user")
	}

	for _, a := range s.Assets {
		if _, ok := d.assets[a.ID]; ok {
			d.errorf("duplicate asset id %d", a.ID)
			continue
		}
		d.assets[a.ID] = a
	}
	for _, p := range s.Places {
		if _, ok := d.places[p.ID]; ok {
			d.errorf("duplicate place id %d", p.ID)
			continue
		}
		d.places[p.ID] = p
	}
	for _, g := range s.Groups {
		d.validateStringID(g.ID, fmt.Sprintf("group %q", g.ID))
		if _, ok := d.groups[g.ID]; ok {
			d.errorf("duplicate group id %q", g.ID)
			continue
		}
		d.groups[g.ID] = g
	}

	for _, c := range s.Creators {
		if _, ok := d.assets[c.AssetID]; !ok {
			if skipOrphans {
				d.warnf("ignoring creator relation for missing asset %d", c.AssetID)
				continue
			}
			d.errorf("creator relation points to missing asset %d", c.AssetID)
			continue
		}
		d.validateUserID(c.UserID, fmt.Sprintf("creator of asset %d", c.AssetID))
		d.creators[c.AssetID] = append(d.creators[c.AssetID], c)
	}
	for _, o := range s.AssetOwners {
		if _, ok := d.assets[o.AssetID]; !ok {
			if skipOrphans {
				d.warnf("ignoring asset owner relation for missing asset %d", o.AssetID)
				continue
			}
			d.errorf("asset owner relation points to missing asset %d", o.AssetID)
			continue
		}
		d.validateUserID(o.UserID, fmt.Sprintf("owner of asset %d", o.AssetID))
		if d.owners[o.AssetID] == nil {
			d.owners[o.AssetID] = make(map[string]struct{})
		}
		d.owners[o.AssetID][o.UserID] = struct{}{}
	}
	for _, child := range s.PackageChildren {
		pkg, ok := d.assets[child.PackageID]
		if !ok {
			d.errorf("package relation points to missing package %d", child.PackageID)
			continue
		}
		if pkg.Type != 32 {
			d.errorf("package relation source %d has type %d, not 32", child.PackageID, pkg.Type)
			continue
		}
		if _, ok := d.assets[child.ChildID]; !ok {
			d.errorf("package %d contains missing asset %d", child.PackageID, child.ChildID)
			continue
		}
		d.children[child.PackageID] = appendUnique(d.children[child.PackageID], child.ChildID)
		if d.parents[child.ChildID] == nil {
			d.parents[child.ChildID] = make(map[uint32]struct{})
		}
		d.parents[child.ChildID][child.PackageID] = struct{}{}
	}
	for _, o := range s.PlaceOwners {
		if _, ok := d.places[o.PlaceID]; !ok {
			if skipOrphans {
				d.warnf("ignoring place owner relation for missing place %d", o.PlaceID)
				continue
			}
			d.errorf("place owner relation points to missing place %d", o.PlaceID)
			continue
		}
		d.validateUserID(o.UserID, fmt.Sprintf("owner of place %d", o.PlaceID))
		if d.placeOwners[o.PlaceID] == nil {
			d.placeOwners[o.PlaceID] = make(map[string]struct{})
		}
		d.placeOwners[o.PlaceID][o.UserID] = struct{}{}
	}
	for _, o := range s.GroupOwners {
		if _, ok := d.groups[o.GroupID]; !ok {
			if skipOrphans {
				d.warnf("ignoring group owner relation for missing group %q", o.GroupID)
				continue
			}
			d.errorf("group owner relation points to missing group %q", o.GroupID)
			continue
		}
		d.validateUserID(o.UserID, fmt.Sprintf("owner of group %q", o.GroupID))
		if d.groupOwners[o.GroupID] == nil {
			d.groupOwners[o.GroupID] = make(map[string]struct{})
		}
		d.groupOwners[o.GroupID][o.UserID] = struct{}{}
	}

	for user, micro := range s.BalancesMicro {
		d.validateUserID(user, "balance user")
		if micro > 0 {
			d.balancesMicro[user] = micro
		}
	}

	d.detectConflicts()
	d.detectUnresolvedSources()
	return d
}

func (d *migrationData) errorf(format string, args ...any) {
	d.errors = append(d.errors, fmt.Sprintf(format, args...))
}

func (d *migrationData) warnf(format string, args ...any) {
	d.warnings = append(d.warnings, fmt.Sprintf(format, args...))
}

func (d *migrationData) validateUserID(id, what string) {
	if id == "" {
		d.errorf("%s has an empty user id", what)
		return
	}
	if len([]byte(id)) > 255 {
		d.errorf("%s id %q is longer than 255 bytes", what, id)
	}
}

func (d *migrationData) validateStringID(id, what string) {
	if id == "" {
		d.errorf("%s has an empty id", what)
		return
	}
	if len([]byte(id)) > 255 {
		d.errorf("%s id %q is longer than 255 bytes", what, id)
	}
}

func appendUnique(list []uint32, v uint32) []uint32 {
	for _, existing := range list {
		if existing == v {
			return list
		}
	}
	return append(list, v)
}

func sortedUsers(set map[string]struct{}) []string {
	users := make([]string, 0, len(set))
	for user := range set {
		users = append(users, user)
	}
	sort.Strings(users)
	return users
}

func (d *migrationData) detectConflicts() {
	for id, creators := range d.creators {
		if len(creators) > 1 {
			users := make([]string, 0, len(creators))
			for _, c := range creators {
				users = append(users, c.UserID)
			}
			sort.Strings(users)
			d.warnf("asset %d has multiple creators (%s); using the first sorted user", id, strings.Join(users, ", "))
		}
	}
	for id, owners := range d.placeOwners {
		if len(owners) > 1 {
			users := sortedUsers(owners)
			d.warnf("place %d has multiple owners (%s)", id, strings.Join(users, ", "))
		}
	}
	for id, owners := range d.groupOwners {
		if len(owners) > 1 {
			users := sortedUsers(owners)
			d.warnf("group %q has multiple owners (%s)", id, strings.Join(users, ", "))
		}
	}

	for child, parents := range d.parents {
		if len(parents) > 1 {
			list := make([]string, 0, len(parents))
			for parent := range parents {
				list = append(list, fmt.Sprintf("%d", parent))
			}
			sort.Strings(list)
			d.errorf("asset %d is contained by multiple packages (%s); resolve this before migrating (2E)", child, strings.Join(list, ", "))
		}
	}

	for id, asset := range d.assets {
		if asset.Type == 32 && len(d.children[id]) == 0 {
			d.warnf("package %d has no children and will not be sellable", id)
		}
	}
}

func (d *migrationData) detectUnresolvedSources() {
	for _, id := range d.sortedAssetIDs() {
		asset := d.assets[id]
		if d.isChild(id) {
			continue // the package source owns this source
		}

		kind := "asset"
		if asset.Type == 32 {
			kind = "package"
		}
		if len(d.creators[id]) > 0 {
			continue
		}
		if owners := d.owners[id]; len(owners) > 0 {
			d.warnf("%s %d has no creator; using owner %s as source owner", kind, id, sortedUsers(owners)[0])
			continue
		}
		if d.fallbackUser != "" {
			d.warnf("%s %d has no creator or owner; using fallback user %s", kind, id, d.fallbackUser)
			continue
		}
		d.errorf("%s %d has no creator, owner, or fallback user", kind, id)
	}
	for _, id := range d.sortedPlaceIDs() {
		if len(d.placeOwners[id]) > 0 {
			continue
		}
		if d.fallbackUser != "" {
			d.warnf("place %d has no owner; using fallback user %s", id, d.fallbackUser)
			continue
		}
		d.errorf("place %d has no owner or fallback user", id)
	}
	for _, id := range d.sortedGroupIDs() {
		if len(d.groupOwners[id]) > 0 {
			continue
		}
		if d.fallbackUser != "" {
			d.warnf("group %q has no owner; using fallback user %s", id, d.fallbackUser)
			continue
		}
		d.errorf("group %q has no owner or fallback user", id)
	}
}

func (d *migrationData) sourceOwner(id uint32) (string, bool) {
	if creators := d.creators[id]; len(creators) > 0 {
		sort.Slice(creators, func(i, j int) bool {
			if creators[i].Created != creators[j].Created {
				return creators[i].Created < creators[j].Created
			}
			return creators[i].UserID < creators[j].UserID
		})
		return creators[0].UserID, true
	}
	if owners := d.owners[id]; len(owners) > 0 {
		return sortedUsers(owners)[0], true
	}
	if d.fallbackUser != "" {
		return d.fallbackUser, true
	}
	return "", false
}

func (d *migrationData) placeOwner(id uint32) (string, bool) {
	if owners := d.placeOwners[id]; len(owners) > 0 {
		return sortedUsers(owners)[0], true
	}
	if d.fallbackUser != "" {
		return d.fallbackUser, true
	}
	return "", false
}

func (d *migrationData) groupOwner(id string) (string, bool) {
	if owners := d.groupOwners[id]; len(owners) > 0 {
		return sortedUsers(owners)[0], true
	}
	if d.fallbackUser != "" {
		return d.fallbackUser, true
	}
	return "", false
}

func (d *migrationData) packageOrder() ([]uint32, error) {
	packages := make([]uint32, 0)
	childPackages := make(map[uint32][]uint32)
	for id, asset := range d.assets {
		if asset.Type == 32 {
			packages = append(packages, id)
		}
	}
	sort.Slice(packages, func(i, j int) bool { return packages[i] < packages[j] })
	for pkg, children := range d.children {
		for _, child := range children {
			if d.assets[child].Type == 32 {
				childPackages[pkg] = append(childPackages[pkg], child)
			}
		}
	}
	for pkg := range childPackages {
		sort.Slice(childPackages[pkg], func(i, j int) bool {
			return childPackages[pkg][i] < childPackages[pkg][j]
		})
	}

	state := make(map[uint32]uint8, len(packages))
	order := make([]uint32, 0, len(packages))
	var visit func(uint32) error
	visit = func(pkg uint32) error {
		switch state[pkg] {
		case 1:
			return fmt.Errorf("package cycle involving %d", pkg)
		case 2:
			return nil
		}
		state[pkg] = 1
		order = append(order, pkg)
		for _, child := range childPackages[pkg] {
			if err := visit(child); err != nil {
				return err
			}
		}
		state[pkg] = 2
		return nil
	}

	for _, pkg := range packages {
		if len(d.parents[pkg]) == 0 {
			if err := visit(pkg); err != nil {
				return nil, err
			}
		}
	}
	for _, pkg := range packages {
		if state[pkg] == 0 {
			return nil, fmt.Errorf("package cycle or unreachable package involving %d", pkg)
		}
	}
	return order, nil
}

func (d *migrationData) sortedAssetIDs() []uint32 {
	ids := make([]uint32, 0, len(d.assets))
	for id := range d.assets {
		ids = append(ids, id)
	}
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })
	return ids
}

func (d *migrationData) sortedPlaceIDs() []uint32 {
	ids := make([]uint32, 0, len(d.places))
	for id := range d.places {
		ids = append(ids, id)
	}
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })
	return ids
}

func (d *migrationData) sortedGroupIDs() []string {
	ids := make([]string, 0, len(d.groups))
	for id := range d.groups {
		ids = append(ids, id)
	}
	sort.Strings(ids)
	return ids
}

func (d *migrationData) sortedBalanceUsers() []string {
	users := make([]string, 0, len(d.balancesMicro))
	for user := range d.balancesMicro {
		users = append(users, user)
	}
	sort.Strings(users)
	return users
}

func (d *migrationData) isChild(id uint32) bool {
	_, ok := d.parents[id]
	return ok
}

func (d *migrationData) packageParent(id uint32) (uint32, bool) {
	for parent := range d.parents[id] {
		return parent, true
	}
	return 0, false
}

func (d *migrationData) childSourceContainer(id uint32) (ledger.PackageSource, bool) {
	parent, ok := d.packageParent(id)
	if !ok {
		return ledger.PackageSource{}, false
	}
	return ledger.PackageSource{Id: parent}, true
}
