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

type ItemPlace struct {
	ID string
}

func RandIDPlace() ItemPlace {
	return ItemPlace{ID: RandStringId()}
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

// owners

type OwnerType uint8

const (
	OwnerTypeUser OwnerType = iota + 1
	OwnerTypeGroup
	OwnerTypeSource
)

type Owner interface {
	OwnerType() OwnerType
	Serialise() []byte
}

type OwnerUser struct {
	ID string
}

func (OwnerUser) OwnerType() OwnerType {
	return OwnerTypeUser
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

func (it OwnerGroup) Serialise() []byte {
	return append([]byte{byte(OwnerTypeGroup)}, []byte(it.ID)...)
}

type OwnerSource struct {
	limited bool
	ID      uint64
}

func (OwnerSource) OwnerType() OwnerType {
	return OwnerTypeSource
}

func (i OwnerSource) Serialise() []byte {
	buf := make([]byte, 10)
	buf[0] = byte(OwnerTypeSource)
	if i.limited {
		buf[1] = 1
	}
	binary.BigEndian.PutUint64(buf[2:], i.ID)
	return buf
}

func DeserialiseOwner(data []byte) (Owner, error) {
	if len(data) == 0 {
		return nil, errors.New("empty data")
	}

	ot := OwnerType(data[0])
	l := len(data)
	switch ot {
	case OwnerTypeUser:
		return OwnerUser{ID: string(data[1:])}, nil
	case OwnerTypeGroup:
		return OwnerGroup{ID: string(data[1:])}, nil
	case OwnerTypeSource:
		if l != 10 {
			return nil, fmt.Errorf("invalid source owner length: %d", l)
		}
		limited := data[1] != 0
		id := binary.BigEndian.Uint64(data[2:])
		return OwnerSource{limited: limited, ID: id}, nil
	}

	return nil, fmt.Errorf("unknown Owner type: %d", ot)
}

type ItemOwner struct {
	Owner
}

func (i ItemOwner) String() string {
	switch i.Owner.OwnerType() {
	case OwnerTypeGroup:
		return fmt.Sprintf("group:%s", i.Owner)
	case OwnerTypeUser:
		return fmt.Sprintf("user:%s", i.Owner)
	}
	return "unknown"
}

func (i ItemOwner) Type() ItemType {
	return ItemTypeOwner
}

func (i ItemOwner) Serialise() []byte {
	buf := []byte{byte(ItemTypeOwner)}
	if i.Owner != nil {
		buf = append(buf, i.Owner.Serialise()...)
	}
	return buf
}

func (ItemOwner) Fungible() bool {
	return false
}

func (i ItemOwner) Mintable() bool {
	return i.Owner.OwnerType() == OwnerTypeGroup
}

func (ItemOwner) CanOwn() bool {
	return true
}

func (i ItemOwner) CanBeOwned() bool {
	return i.Owner.OwnerType() == OwnerTypeGroup
}

func (i ItemOwner) IsNil() bool {
	return i.Owner == nil
}

func DeserialiseItemOwner(data []byte) (ItemOwner, error) {
	if len(data) == 0 {
		return ItemOwner{}, errors.New("empty data")
	}

	it := OwnerType(data[0])
	switch it {
	case OwnerTypeGroup:
		i, err := DeserialiseOwner(data[1:])
		if err != nil {
			return ItemOwner{}, fmt.Errorf("decode group item: %w", err)
		}
		return ItemOwner{i}, nil
	case OwnerTypeUser:
		i, err := DeserialiseOwner(data[1:])
		if err != nil {
			return ItemOwner{}, fmt.Errorf("decode user item: %w", err)
		}
		return ItemOwner{i}, nil
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
	case ItemTypePlace:
		return ItemPlace{ID: string(data[1:])}, nil
	case ItemTypeOwner:
		return DeserialiseItemOwner(data[1:])
	}

	return nil, fmt.Errorf("unknown Item type: %d", it)
}
