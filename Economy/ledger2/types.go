package main

import "fmt"

type Type uint8

const (
	// number ID types

	TypeCurrency Type = iota
	TypeLimitedAsset
	TypeUnlimitedAsset
	TypeLimitedSource
	TypeUnlimitedSource
	TypePlace
	
	// string ID types

	TypeUser
	TypeGroup
)

type (
	NumericID interface {
		ID() uint64
	}
	StringID interface {
		ID() string
	}
	Item interface {
		String() string
		Type() Type
	}
	NumericItem interface {
		Item
		NumericID
	}
	StringItem interface {
		Item
		StringID
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
	id uint64
}

func (i Currency) String() string {
	return fmt.Sprintf("currency(%d)", i.id)
}

func (Currency) Type() Type {
	return TypeCurrency
}

func (i Currency) ID() uint64 {
	return i.id
}

func (Currency) Mintable()   {}
func (Currency) CanOwnMany() {}

type LimitedAsset struct {
	id uint64
}

func (i LimitedAsset) String() string {
	return fmt.Sprintf("limited-asset(%d)", i.id)
}

func (LimitedAsset) Type() Type {
	return TypeLimitedAsset
}

func (i LimitedAsset) ID() uint64 {
	return i.id
}

func (LimitedAsset) CanOwnMany() {}

type UnlimitedAsset struct {
	id uint64
}

func (i UnlimitedAsset) String() string {
	return fmt.Sprintf("unlimited-asset(%d)", i.id)
}

func (UnlimitedAsset) Type() Type {
	return TypeUnlimitedAsset
}

func (i UnlimitedAsset) ID() uint64 {
	return i.id
}

func (UnlimitedAsset) CanOwnOne() {}


type LimitedSource struct {
	id uint64
}

func (i LimitedSource) String() string {
	return fmt.Sprintf("limited-source(%d)", i.id)
}

func (LimitedSource) Type() Type {
	return TypeLimitedSource
}

func (i LimitedSource) ID() uint64 {
	return i.id
}

func (LimitedSource) CanOwnOne() {}
func (LimitedSource) Mintable()  {}
func (LimitedSource) Owner()     {}
func (LimitedSource) Single()    {}

func (i LimitedSource) Create() LimitedAsset {
	return LimitedAsset{i.id}
}

type UnlimitedSource struct {
	id uint64
}

func (i UnlimitedSource) String() string {
	return fmt.Sprintf("unlimited-source(%d)", i.id)
}

func (UnlimitedSource) Type() Type {
	return TypeUnlimitedSource
}

func (i UnlimitedSource) ID() uint64 {
	return i.id
}

func (UnlimitedSource) CanOwnOne() {}
func (UnlimitedSource) Mintable()  {}
func (UnlimitedSource) Owner()     {}
func (UnlimitedSource) Single()    {}

func (i UnlimitedSource) Create() UnlimitedAsset {
	return UnlimitedAsset{i.id}
}

type Place struct {
	id uint64
}

func (i Place) String() string {
	return fmt.Sprintf("place(%d)", i.id)
}

func (Place) Type() Type {
	return TypePlace
}

func (i Place) ID() uint64 {
	return i.id
}

func (Place) CanOwnOne() {}
func (Place) Mintable()  {}
func (Place) Single()    {}

func RandPlace() Place {
	return Place{RandNumericId()}
}

type User struct {
	id string
}

func (i User) String() string {
	return fmt.Sprintf("user(%s)", i.id)
}

func (User) Type() Type {
	return TypeUser
}

func (i User) ID() string {
	return i.id
}

func (User) Owner()  {}
func (User) Single() {}

type Group struct {
	id string
}

func (i Group) String() string {
	return fmt.Sprintf("group(%s)", i.id)
}

func (Group) Type() Type {
	return TypeGroup
}

func (i Group) ID() string {
	return i.id
}

func (Group) CanOwnOne() {}
func (Group) Owner()     {}
func (Group) Single()    {}

// checks
var (
	_ Item = Currency{}
	_ Item = LimitedAsset{}
	_ Item = UnlimitedAsset{}
	_ Item = Place{}
	_ Item = User{}
	_ Item = Group{}
	_ Item = LimitedSource{}
	_ Item = UnlimitedSource{}
)
