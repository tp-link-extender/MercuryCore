package main

import (
	"encoding/binary"
	"errors"
	"fmt"
)

type ItemType byte

const (
	// Fungible assets (users can own any number of these)

	ItemTypeCurrency ItemType = 'c'
	ItemTypeAsset    ItemType = 'a'

	// Non-fungible assets (users can only own 1 of these)

	ItemTypePlace ItemType = 'p'
	ItemTypeOwner ItemType = 'o'
)

type Item interface {
	Type() ItemType
	String() string
	Serialise() []byte
	Fungible() bool
	Mintable() bool
	CanOwn() bool
	Owned() bool
}

type ItemCurrency struct {
	ID uint64
}

func (ItemCurrency) Type() ItemType {
	return ItemTypeCurrency
}

func (i ItemCurrency) String() string {
	return fmt.Sprintf("currency(%d)", i.ID)
}

func (i ItemCurrency) Serialise() []byte {
	buf := make([]byte, 9)
	buf[0] = byte(ItemTypeCurrency)
	binary.BigEndian.PutUint64(buf[1:], i.ID)
	return buf
}

func (ItemCurrency) Fungible() bool {
	return true
}

func (ItemCurrency) Mintable() bool {
	return true
}

func (ItemCurrency) CanOwn() bool {
	return false
}

func (ItemCurrency) Owned() bool {
	return true
}

type ItemAsset struct {
	limited bool
	ID      uint64
}

func (ItemAsset) Type() ItemType {
	return ItemTypeAsset
}

func (i ItemAsset) String() string {
	if i.limited {
		return fmt.Sprintf("limited-asset(%d)", i.ID)
	}
	return fmt.Sprintf("unlimited-asset(%d)", i.ID)
}

func (i ItemAsset) Serialise() []byte {
	buf := make([]byte, 10)
	buf[0] = byte(ItemTypeAsset)
	if i.limited {
		buf[1] = 1
	}
	binary.BigEndian.PutUint64(buf[2:], i.ID)
	return buf
}

func (i ItemAsset) Fungible() bool {
	return !i.limited
}

func (ItemAsset) Mintable() bool {
	return false
}

func (ItemAsset) CanOwn() bool {
	return false
}

func (ItemAsset) Owned() bool {
	return true
}

type ItemPlace struct {
	ID string
}

func RandPlace() ItemPlace {
	return ItemPlace{RandStringId()}
}

func (ItemPlace) Type() ItemType {
	return ItemTypePlace
}

func (i ItemPlace) String() string {
	return fmt.Sprintf("place(%s)", i.ID)
}

func (it ItemPlace) Serialise() []byte {
	return append([]byte{byte(ItemTypePlace)}, []byte(it.ID)...)
}

func (ItemPlace) Fungible() bool {
	return false
}

func (ItemPlace) Mintable() bool {
	return true
}

func (ItemPlace) CanOwn() bool {
	return false
}

func (ItemPlace) Owned() bool {
	return true
}

// owners

type OwnerType uint8

const (
	OwnerTypeNil OwnerType = iota
	OwnerTypeUser
	OwnerTypeGroup
	OwnerTypeLimitedSource
	OwnerTypeUnlimitedSource
)

type Owner interface {
	OwnerType() OwnerType
	String() string
	Serialise() []byte
}

type OwnerUser struct {
	ID string
}

func (OwnerUser) OwnerType() OwnerType {
	return OwnerTypeUser
}

func (it OwnerUser) String() string {
	return fmt.Sprintf("user(%s)", it.ID)
}

func (it OwnerUser) Serialise() []byte {
	return append([]byte{byte(OwnerTypeUser)}, []byte(it.ID)...)
}

type OwnerGroup struct {
	ID string
}

func (OwnerGroup) OwnerType() OwnerType {
	return OwnerTypeGroup
}

func (it OwnerGroup) String() string {
	return fmt.Sprintf("group(%s)", it.ID)
}

func (it OwnerGroup) Serialise() []byte {
	return append([]byte{byte(OwnerTypeGroup)}, []byte(it.ID)...)
}

type OwnerLimitedSource struct {
	ID uint64
}

func (OwnerLimitedSource) OwnerType() OwnerType {
	return OwnerTypeLimitedSource
}

func (it OwnerLimitedSource) String() string {
	return fmt.Sprintf("limited-source(%d)", it.ID)
}

func (i OwnerLimitedSource) Serialise() []byte {
	buf := make([]byte, 9)
	buf[0] = byte(OwnerTypeLimitedSource)
	binary.BigEndian.PutUint64(buf[1:], i.ID)
	return buf
}

type OwnerUnlimitedSource struct {
	ID uint64
}

func (OwnerUnlimitedSource) OwnerType() OwnerType {
	return OwnerTypeUnlimitedSource
}

func (it OwnerUnlimitedSource) String() string {
	return fmt.Sprintf("unlimited-source(%d)", it.ID)
}

func (i OwnerUnlimitedSource) Serialise() []byte {
	buf := make([]byte, 9)
	buf[0] = byte(OwnerTypeUnlimitedSource)
	binary.BigEndian.PutUint64(buf[1:], i.ID)
	return buf
}

func DeserialiseOwner(data []byte) (Owner, error) {
	if len(data) == 0 {
		return nil, errors.New("empty data")
	}

	ot := OwnerType(data[0])
	l := len(data)
	switch ot {
	case OwnerTypeNil:
		return nil, nil
	case OwnerTypeUser:
		return OwnerUser{ID: string(data[1:])}, nil
	case OwnerTypeGroup:
		return OwnerGroup{ID: string(data[1:])}, nil
	case OwnerTypeLimitedSource:
		if l != 9 {
			return nil, fmt.Errorf("invalid limited source owner length: %d", l)
		}
		id := binary.BigEndian.Uint64(data[1:])
		return OwnerLimitedSource{ID: id}, nil
	case OwnerTypeUnlimitedSource:
		if l != 9 {
			return nil, fmt.Errorf("invalid unlimited source owner length: %d", l)
		}
		id := binary.BigEndian.Uint64(data[1:])
		return OwnerUnlimitedSource{ID: id}, nil
	}

	return nil, fmt.Errorf("unknown Owner type: %d", ot)
}

type ItemOwner struct {
	Owner Owner // don't embed, because we don't want ItemOwner to satisfy Owner
}

func (i ItemOwner) Type() ItemType {
	return ItemTypeOwner
}

func (i ItemOwner) String() string {
	if i.Owner == nil {
		return "owner(nil)"
	}
	return i.Owner.String()
}

func (i ItemOwner) Serialise() []byte {
	if i.Owner == nil {
		return []byte{byte(OwnerTypeNil)}
	}
	buf := []byte{byte(i.Owner.OwnerType())}
	if i.Owner != nil {
		buf = append(buf, i.Owner.Serialise()...)
	}
	return buf
}

func (ItemOwner) Fungible() bool {
	return false
}

func (i ItemOwner) Mintable() bool {
	return i.Owner.OwnerType() != OwnerTypeUser
}

func (ItemOwner) CanOwn() bool {
	return true
}

func (i ItemOwner) Owned() bool {
	return i.Owner.OwnerType() != OwnerTypeUser
}

func (i ItemOwner) IsNil() bool {
	return i.Owner == nil
}

func DeserialiseItem(data []byte) (Item, error) {
	if len(data) == 0 {
		return nil, errors.New("empty data")
	}

	it := ItemType(data[0])
	l := len(data)
	switch it {
	case ItemTypeCurrency:
		if l != 9 {
			return nil, fmt.Errorf("invalid currency item length: %d", l)
		}
		id := binary.BigEndian.Uint64(data[1:])
		return ItemCurrency{id}, nil
	case ItemTypeAsset:
		if l != 10 {
			return nil, fmt.Errorf("invalid asset item length: %d", l)
		}
		limited := data[1] != 0
		id := binary.BigEndian.Uint64(data[2:])
		return ItemAsset{limited: limited, ID: id}, nil
	case ItemTypePlace:
		return ItemPlace{string(data[1:])}, nil
	case ItemTypeOwner:
		o, err := DeserialiseOwner(data[1:])
		if err != nil {
			return nil, fmt.Errorf("decode owner: %w", err)
		}
		return ItemOwner{o}, nil
	}

	return nil, fmt.Errorf("unknown Item type: %d", it)
}
