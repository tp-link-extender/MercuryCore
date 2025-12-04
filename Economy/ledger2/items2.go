package main

type (
	CanOwnOne  interface{ CanOwnOne() }
	CanOwnMany interface{ CanOwnMany() }
	Mintable   interface{ Mintable() }
	Owner      interface{ Owner() }
	Single     interface{ Single() }
)

type Currency struct {
	ID uint64
}

func (Currency) Mintable()   {}
func (Currency) CanOwnMany() {}

type LimitedAsset struct {
	ID uint64
}

func (LimitedAsset) CanOwnMany() {}

type UnlimitedAsset struct {
	ID uint64
}

func (UnlimitedAsset) CanOwnOne() {}

type Place struct {
	ID string
}

func (Place) CanOwnOne() {}
func (Place) Mintable()  {}
func (Place) Single()    {}

type User struct {
	ID string
}

func (User) Owner()  {}
func (User) Single() {}

type Group struct {
	ID string
}

func (Group) CanOwnOne() {}
func (Group) Owner()     {}
func (Group) Single()    {}

type LimitedSource struct {
	ID uint64
}

func (LimitedSource) CanOwnOne() {}
func (LimitedSource) Mintable()  {}
func (LimitedSource) Owner()     {}
func (LimitedSource) Single()    {}

type UnlimitedSource struct {
	ID uint64
}

func (UnlimitedSource) CanOwnOne() {}
func (UnlimitedSource) Mintable()  {}
func (UnlimitedSource) Owner()     {}
func (UnlimitedSource) Single()    {}

type (
	Quantity  uint64
	ItemsOne  map[CanOwnOne]struct{}
	ItemsMany map[CanOwnMany]Quantity
	Items     struct {
		One  ItemsOne
		Many ItemsMany
	}
)
