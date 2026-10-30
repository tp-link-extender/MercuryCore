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

	// appended after the original types, because these byte values are persisted in every transfer in the ledger and shifting them would corrupt existing data

	TypePackage
	TypePackageSource
)

type Item interface {
	String() string
	// only used for serialisation atm
	Type() Type
}

func readByte(r io.Reader) (byte, error) {
	var b [1]byte
	if _, err := io.ReadFull(r, b[:]); err != nil {
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
		if _, err := io.ReadFull(r, idbuf); err != nil {
			return nil, fmt.Errorf("read string id: %w", err)
		}
		id := string(idbuf)

		if t == TypeUser {
			return User{id}, nil
		}
		return Group{id}, nil
	}

	var idbuf [4]byte
	if _, err := io.ReadFull(r, idbuf[:]); err != nil {
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
	case TypePackage:
		return Package{id}, nil
	case TypePackageSource:
		return PackageSource{id}, nil
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
	Source interface {
		NumericItem
		Owner
		Source()
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

var (
	_ NumericItem = Currency{}
	_ CanOwnMany  = Currency{}
	_ Mintable    = Currency{}
)

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

// Mintable because a limited asset can only ever come from a limited source, so the source's opening stock has to be minted alongside it – there's no later transfer that could top it up.
// Nothing but CreateLimitedSource ever constructs such a transfer, so this doesn't hand callers a mint.
func (LimitedAsset) Mintable() {}

func (LimitedAsset) CanOwnMany() {}

var (
	_ NumericItem = LimitedAsset{}
	_ CanOwnMany  = LimitedAsset{}
	_ Mintable    = LimitedAsset{}
)

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

var (
	_ NumericItem = UnlimitedAsset{}
	_ CanOwnOne   = UnlimitedAsset{}
)

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
func (LimitedSource) Source()    {}

// func (LimitedSource) Single()    {}

var (
	_ NumericItem = LimitedSource{}
	_ CanOwnOne   = LimitedSource{}
	_ Mintable    = LimitedSource{}
	_ Owner       = LimitedSource{}
	_ Source      = LimitedSource{}
)

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
func (UnlimitedSource) Source()    {}

// func (UnlimitedSource) Single()    {}

var (
	_ NumericItem = UnlimitedSource{}
	_ CanOwnOne   = UnlimitedSource{}
	_ Mintable    = UnlimitedSource{}
	_ Owner       = UnlimitedSource{}
	_ Source      = UnlimitedSource{}
)

func (i UnlimitedSource) Create() UnlimitedAsset {
	return UnlimitedAsset(i)
}

func RandUnlimitedSource() UnlimitedSource {
	return UnlimitedSource{RandNumericId()}
}

// A Package is the bundle asset itself. It's issued by a PackageSource in the same transfer that issues the package's contents, so a buyer never has a package without its components.
type Package struct {
	Id uint32
}

func (i Package) String() string {
	return fmt.Sprintf("package(%d)", i.Id)
}

func (Package) Type() Type {
	return TypePackage
}

func (i Package) ID() uint32 {
	return i.Id
}

func (Package) CanOwnOne() {}

var (
	_ NumericItem = Package{}
	_ CanOwnOne   = Package{}
)

// A PackageSource creates a Package and holds the sources for everything inside it, so it can reissue the whole bundle indefinitely. It is an ordinary source as far as the ledger is concerned: the only thing that makes it special is that its inventory contains other sources.
type PackageSource struct {
	Id uint32
}

func (i PackageSource) String() string {
	return fmt.Sprintf("package-source(%d)", i.Id)
}

func (PackageSource) Type() Type {
	return TypePackageSource
}

func (i PackageSource) ID() uint32 {
	return i.Id
}

func (PackageSource) CanOwnOne() {}
func (PackageSource) Mintable()  {}
func (PackageSource) Owner()     {}
func (PackageSource) Source()    {}

var (
	_ NumericItem = PackageSource{}
	_ CanOwnOne   = PackageSource{}
	_ Mintable    = PackageSource{}
	_ Owner       = PackageSource{}
	_ Source      = PackageSource{}
)

func (i PackageSource) Create() Package {
	return Package(i)
}

// CreateSource returns the source that issues this package. A package source holding this is what grants the right to reissue the package, so nesting a package means passing this source along.
func (i PackageSource) CreateSource() PackageSource {
	return i
}

func RandPackageSource() PackageSource {
	return PackageSource{RandNumericId()}
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

var (
	_ NumericItem = Place{}
	_ CanOwnOne   = Place{}
	_ Mintable    = Place{}
)

func RandPlace() Place {
	return Place{RandNumericId()}
}

// NewPlace builds a Place with an exact ID, for importing existing database-backed places.
func NewPlace(id uint32) Place {
	return Place{id}
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

var (
	_ StringItem = User{}
	_ Owner      = User{}
)

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

var (
	_ StringItem = Group{}
	_ CanOwnOne  = Group{}
	_ Mintable   = Group{}
	_ Owner      = Group{}
)

func RandGroup() Group {
	return Group{RandStringId()}
}

// NewGroup builds a Group with an exact ID, for importing existing database-backed groups.
func NewGroup(id string) Group {
	return Group{id}
}
