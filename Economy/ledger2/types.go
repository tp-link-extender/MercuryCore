package main

import "fmt"

type (
	Item interface {
		String() string
	}
	CanOwnOne interface {
		Item
		CanOwnOne()
	}
	CanOwnMany interface {
		Item
		CanOwnMany()
	}
	Mintable interface {
		Item
		Mintable()
	}
	Owner interface {
		Item
		Owner()
	}
	Single interface {
		Item
		Single()
	}
)

type Currency struct {
	ID uint64
}

func (i Currency) String() string {
	return fmt.Sprintf("currency(%d)", i.ID)
}

func (Currency) Mintable()   {}
func (Currency) CanOwnMany() {}

type LimitedAsset struct {
	ID uint64
}

func (i LimitedAsset) String() string {
	return fmt.Sprintf("limited-asset(%d)", i.ID)
}

func (LimitedAsset) CanOwnMany() {}

type UnlimitedAsset struct {
	ID uint64
}

func (i UnlimitedAsset) String() string {
	return fmt.Sprintf("unlimited-asset(%d)", i.ID)
}

func (UnlimitedAsset) CanOwnOne() {}

type Place struct {
	ID string
}

func (i Place) String() string {
	return fmt.Sprintf("place(%s)", i.ID)
}

func (Place) CanOwnOne() {}
func (Place) Mintable()  {}
func (Place) Single()    {}

func RandPlace() Place {
	return Place{RandStringId()	}
}

type User struct {
	ID string
}

func (i User) String() string {
	return fmt.Sprintf("user(%s)", i.ID)
}

func (User) Owner()  {}
func (User) Single() {}

type Group struct {
	ID string
}

func (i Group) String() string {
	return fmt.Sprintf("group(%s)", i.ID)
}

func (Group) CanOwnOne() {}
func (Group) Owner()     {}
func (Group) Single()    {}

type LimitedSource struct {
	ID uint64
}

func (i LimitedSource) String() string {
	return fmt.Sprintf("limited-source(%d)", i.ID)
}

func (LimitedSource) CanOwnOne() {}
func (LimitedSource) Mintable()  {}
func (LimitedSource) Owner()     {}
func (LimitedSource) Single()    {}

func (i LimitedSource) Create() LimitedAsset {
	return LimitedAsset{i.ID}
}

type UnlimitedSource struct {
	ID uint64
}

func (i UnlimitedSource) String() string {
	return fmt.Sprintf("unlimited-source(%d)", i.ID)
}

func (i UnlimitedSource) Create() UnlimitedAsset {
	return UnlimitedAsset{i.ID}
}

func (UnlimitedSource) CanOwnOne() {}
func (UnlimitedSource) Mintable()  {}
func (UnlimitedSource) Owner()     {}
func (UnlimitedSource) Single()    {}
