package ledger

import (
	"encoding/binary"
	"fmt"
	"io"
)

type Type uint8

const (
	// number ID types

	// zillion pound mistake
	TypeNil Type = iota
	TypeCurrency
	TypeLimitedAsset
	TypeUnlimitedAsset
	TypeLimitedSource
	TypeUnlimitedSource
	TypePlace

	// string ID types

	TypeUser
	TypeGroup
)

type Item interface {
	String() string
	// only used for serialisation atm
	Type() Type
}

func readByte(r io.Reader) (byte, error) {
	var b [1]byte
	if _, err := r.Read(b[:]); err != nil {
		return 0, err
	}
	return b[0], nil
}

func DeserialiseItem(r io.Reader) (Item, error) {
	tb, err := readByte(r)
	if err != nil {
		return nil, fmt.Errorf("read type: %w", err)
	}

	t := Type(tb)
	if t == TypeNil {
		return nil, nil
	}

	if t == TypeUser || t == TypeGroup {
		lb, err := readByte(r)
		if err != nil {
			return nil, fmt.Errorf("read string id length: %w", err)
		}

		idbuf := make([]byte, lb)
		if _, err := r.Read(idbuf); err != nil {
			return nil, fmt.Errorf("read string id: %w", err)
		}
		id := string(idbuf)

		if t == TypeUser {
			return User{id}, nil
		}
		return Group{id}, nil
	}

	var idbuf [4]byte
	if _, err := r.Read(idbuf[:]); err != nil {
		return nil, fmt.Errorf("read numeric id: %w", err)
	}

	switch id := binary.BigEndian.Uint32(idbuf[:]); t {
	case TypeCurrency:
		return Currency{id}, nil
	case TypeLimitedAsset:
		return LimitedAsset{id}, nil
	case TypeUnlimitedAsset:
		return UnlimitedAsset{id}, nil
	case TypeLimitedSource:
		return LimitedSource{id}, nil
	case TypeUnlimitedSource:
		return UnlimitedSource{id}, nil
	case TypePlace:
		return Place{id}, nil
	}

	return nil, fmt.Errorf("unknown Type: %d", t)
}

type (
	NumericItem interface {
		Item
		// only used for serialisation atm
		// also uint32 because if anything bigger than that is needed then string IDs should be used instead
		// as for negative IDs......... lmao
		ID() uint32
	}
	StringItem interface {
		Item
		// only used for serialisation atm
		ID() string
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
)

func IsMintable(i Item) bool {
	_, ok := i.(Mintable)
	return ok
}

type Currency struct {
	Id uint32
}

func (i Currency) String() string {
	return fmt.Sprintf("currency(%d)", i.Id)
}

func (Currency) Type() Type {
	return TypeCurrency
}

func (i Currency) ID() uint32 {
	return i.Id
}

func (Currency) Mintable()   {}
func (Currency) CanOwnMany() {}

type LimitedAsset struct {
	Id uint32
}

func (i LimitedAsset) String() string {
	return fmt.Sprintf("limited-asset(%d)", i.Id)
}

func (LimitedAsset) Type() Type {
	return TypeLimitedAsset
}

func (i LimitedAsset) ID() uint32 {
	return i.Id
}

func (LimitedAsset) CanOwnMany() {}

type UnlimitedAsset struct {
	Id uint32
}

func (i UnlimitedAsset) String() string {
	return fmt.Sprintf("unlimited-asset(%d)", i.Id)
}

func (UnlimitedAsset) Type() Type {
	return TypeUnlimitedAsset
}

func (i UnlimitedAsset) ID() uint32 {
	return i.Id
}

func (UnlimitedAsset) CanOwnOne() {}

type LimitedSource struct {
	Id uint32
}

func (i LimitedSource) String() string {
	return fmt.Sprintf("limited-source(%d)", i.Id)
}

func (LimitedSource) Type() Type {
	return TypeLimitedSource
}

func (i LimitedSource) ID() uint32 {
	return i.Id
}

func (LimitedSource) CanOwnOne() {}
func (LimitedSource) Mintable()  {}
func (LimitedSource) Owner()     {}

// func (LimitedSource) Single()    {}

func (i LimitedSource) Create() LimitedAsset {
	return LimitedAsset(i)
}

func RandLimitedSource() LimitedSource {
	return LimitedSource{RandNumericId()}
}

type UnlimitedSource struct {
	Id uint32
}

func (i UnlimitedSource) String() string {
	return fmt.Sprintf("unlimited-source(%d)", i.Id)
}

func (UnlimitedSource) Type() Type {
	return TypeUnlimitedSource
}

func (i UnlimitedSource) ID() uint32 {
	return i.Id
}

func (UnlimitedSource) CanOwnOne() {}
func (UnlimitedSource) Mintable()  {}
func (UnlimitedSource) Owner()     {}

// func (UnlimitedSource) Single()    {}

func (i UnlimitedSource) Create() UnlimitedAsset {
	return UnlimitedAsset(i)
}

func RandUnlimitedSource() UnlimitedSource {
	return UnlimitedSource{RandNumericId()}
}

type Place struct {
	id uint32
}

func (i Place) String() string {
	return fmt.Sprintf("place(%d)", i.id)
}

func (Place) Type() Type {
	return TypePlace
}

func (i Place) ID() uint32 {
	return i.id
}

func (Place) CanOwnOne() {}
func (Place) Mintable()  {}

// func (Place) Single()    {}

func RandPlace() Place {
	return Place{RandNumericId()}
}

type User struct {
	Id string
}

func (i User) String() string {
	return fmt.Sprintf("user(%s)", i.Id)
}

func (User) Type() Type {
	return TypeUser
}

func (i User) ID() string {
	return i.Id
}

func (User) Owner() {}

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
func (Group) Mintable()  {}
func (Group) Owner()     {}

// func (Group) Single()    {}

func RandGroup() Group {
	return Group{RandStringId()}
}
