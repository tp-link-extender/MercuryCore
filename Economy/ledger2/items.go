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

	ItemTypeGroup  ItemType = 'g'
	ItemTypeSource ItemType = 's'
	ItemTypePlace  ItemType = 'p'

	// Not ownable

	ItemTypeNil  ItemType = 0
	ItemTypeUser ItemType = 'u' // slavery 2.0
)

type Item interface {
	Type() ItemType
	Serialise() []byte
	Fungible() bool
	Mintable() bool
	CanOwn() bool
	CanBeOwned() bool
}

type ItemCurrency struct {
	ID uint64
}

func (ItemCurrency) Type() ItemType {
	return ItemTypeCurrency
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

func (ItemCurrency) CanBeOwned() bool {
	return true
}

type ItemAsset struct {
	limited bool
	ID      uint64
}

func (ItemAsset) Type() ItemType {
	return ItemTypeAsset
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

func (ItemAsset) CanBeOwned() bool {
	return true
}

type ItemSource struct {
	limited bool
	ID      string
}

func (ItemSource) Type() ItemType {
	return ItemTypeSource
}

func (it ItemSource) Serialise() []byte {
	buf := []byte{byte(ItemTypeSource)}
	if it.limited {
		buf = append(buf, 1)
	} else {
		buf = append(buf, 0)
	}
	buf = append(buf, []byte(it.ID)...)
	return buf
}

func (it ItemSource) Fungible() bool {
	return false
}

func (it ItemSource) Mintable() bool {
	return true
}

func (it ItemSource) CanOwn() bool {
	return true
}

func (it ItemSource) CanBeOwned() bool {
	return true
}

type ItemPlace struct {
	ID string
}

func (ItemPlace) Type() ItemType {
	return ItemTypePlace
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

func (ItemPlace) CanBeOwned() bool {
	return true
}

type OwnerType uint8

const (
	OwnerTypeNil   OwnerType = 0
	OwnerTypeUser  OwnerType = 1
	OwnerTypeGroup OwnerType = 2
)

type ItemOwner struct {
	OwnerType
	ID string
}

func (i ItemOwner) Type() ItemType {
	if i.OwnerType == OwnerTypeNil {
		return ItemTypeNil
	}
	if i.OwnerType == OwnerTypeGroup {
		return ItemTypeGroup
	}
	return ItemTypeUser
}

func (i ItemOwner) Serialise() []byte {
	buf := make([]byte, 1+len(i.ID))
	switch i.OwnerType {
	case OwnerTypeNil:
		buf[0] = byte(ItemTypeNil)
	case OwnerTypeGroup:
		buf[0] = byte(ItemTypeGroup)
	case OwnerTypeUser:
		buf[0] = byte(ItemTypeUser)
	}
	copy(buf[1:], []byte(i.ID))
	return buf
}

func (ItemOwner) Fungible() bool {
	return false
}

func (i ItemOwner) Mintable() bool {
	return i.OwnerType == OwnerTypeGroup
}

func (ItemOwner) CanOwn() bool {
	return true
}

func (i ItemOwner) CanBeOwned() bool {
	return i.OwnerType == OwnerTypeGroup
}

func (i ItemOwner) IsNil() bool {
	return i.OwnerType == OwnerTypeNil
}

func DeserialiseItemOwner(data []byte) (ItemOwner, error) {
	if len(data) == 0 {
		return ItemOwner{}, errors.New("empty data")
	}

	it := ItemType(data[0])
	switch it {
	case ItemTypeGroup:
		return ItemOwner{OwnerType: OwnerTypeGroup, ID: string(data[1:])}, nil
	case ItemTypeNil:
		return ItemOwner{OwnerType: OwnerTypeNil}, nil
	case ItemTypeUser:
		return ItemOwner{OwnerType: OwnerTypeUser, ID: string(data[1:])}, nil
	}

	return ItemOwner{}, fmt.Errorf("unknown ItemOwner type: %d", it)
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
		return ItemCurrency{ID: id}, nil
	case ItemTypeAsset:
		if l != 10 {
			return nil, fmt.Errorf("invalid asset item length: %d", l)
		}
		limited := data[1] != 0
		id := binary.BigEndian.Uint64(data[2:])
		return ItemAsset{limited: limited, ID: id}, nil
	// case ItemTypeGroup:
	// 	return ItemOwner{OwnerType: OwnerTypeGroup, ID: string(data)}, nil
	case ItemTypeSource:
		if l < 2 {
			return nil, fmt.Errorf("invalid source item length: %d", l)
		}
		limited := data[1] != 0
		id := string(data[2:])
		return ItemSource{limited: limited, ID: id}, nil
	case ItemTypePlace:
		return ItemPlace{ID: string(data[1:])}, nil
	case ItemTypeNil, ItemTypeUser, ItemTypeGroup:
		return DeserialiseItemOwner(data)
	}

	return nil, fmt.Errorf("unknown Item type: %d", it)
}
