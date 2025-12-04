package main

import "fmt"

type Type uint8

const (
	TypeCurrency Type = iota
	TypeLimitedAsset
	TypeUnlimitedAsset
	TypePlace
	TypeUser
	TypeGroup
	TypeLimitedSource
	TypeUnlimitedSource
)

type (
	Item interface {
		String() string
		Type() Type
		Serialise() []byte
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

func (Currency) Type() Type {
	return TypeCurrency
}

func (Currency) Mintable()   {}
func (Currency) CanOwnMany() {}

type LimitedAsset struct {
	ID uint64
}

func (i LimitedAsset) String() string {
	return fmt.Sprintf("limited-asset(%d)", i.ID)
}

func (LimitedAsset) Type() Type {
	return TypeLimitedAsset
}

func (LimitedAsset) CanOwnMany() {}

type UnlimitedAsset struct {
	ID uint64
}

func (i UnlimitedAsset) String() string {
	return fmt.Sprintf("unlimited-asset(%d)", i.ID)
}

func (UnlimitedAsset) Type() Type {
	return TypeUnlimitedAsset
}

func (UnlimitedAsset) CanOwnOne() {}

type Place struct {
	ID string
}

func (i Place) String() string {
	return fmt.Sprintf("place(%s)", i.ID)
}

func (Place) Type() Type {
	return TypePlace
}

func (Place) CanOwnOne() {}
func (Place) Mintable()  {}
func (Place) Single()    {}

func RandPlace() Place {
	return Place{RandStringId()}
}

type User struct {
	ID string
}

func (i User) String() string {
	return fmt.Sprintf("user(%s)", i.ID)
}

func (User) Type() Type {
	return TypeUser
}

func (User) Owner()  {}
func (User) Single() {}

type Group struct {
	ID string
}

func (i Group) String() string {
	return fmt.Sprintf("group(%s)", i.ID)
}

func (Group) Type() Type {
	return TypeGroup
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

func (LimitedSource) Type() Type {
	return TypeLimitedSource
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

func (UnlimitedSource) Type() Type {
	return TypeUnlimitedSource
}

func (UnlimitedSource) CanOwnOne() {}
func (UnlimitedSource) Mintable()  {}
func (UnlimitedSource) Owner()     {}
func (UnlimitedSource) Single()    {}

func (i UnlimitedSource) Create() UnlimitedAsset {
	return UnlimitedAsset{i.ID}
}
