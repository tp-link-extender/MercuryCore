package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"io"
	"strings"
)

func SerialiseNumeric(i NumericItem) []byte {
	idbuf := make([]byte, 5)
	idbuf[0] = byte(i.Type())
	binary.BigEndian.PutUint32(idbuf[1:], i.ID())
	return idbuf
}

func SerialiseString(i StringItem) []byte {
	idstr := i.ID()
	id := make([]byte, 2+len(idstr))
	id[0] = byte(i.Type())
	id[1] = byte(len(idstr))
	copy(id[2:], idstr)
	return id
}

func SerialiseItem2(i Item, b *bytes.Buffer) bool {
	if i == nil {
		b.WriteByte(byte(TypeNil))
	} else if ni, ok := i.(NumericItem); ok {
		b.Write(SerialiseNumeric(ni))
	} else if si, ok := i.(StringItem); ok {
		b.Write(SerialiseString(si))
	} else {
		return false
	}
	return true
}

func DeserialiseItem2(r io.Reader) (Item, error) {
	var typeByte [1]byte
	if _, err := r.Read(typeByte[:]); err != nil {
		return nil, fmt.Errorf("read type: %w", err)
	}

	t := Type(typeByte[0])
	if t == TypeNil {
		return nil, nil
	}

	if t == TypeUser || t == TypeGroup {
		var lenByte [1]byte
		if _, err := r.Read(lenByte[:]); err != nil {
			return nil, fmt.Errorf("read string id length: %w", err)
		}

		idbuf := make([]byte, lenByte[0])
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

type ItemsOne map[CanOwnOne]struct{}

func (is ItemsOne) String() string {
	parts := make([]string, 0, len(is))
	for i := range is {
		parts = append(parts, i.String())
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (is ItemsOne) Equal(other ItemsOne) bool {
	if len(is) != len(other) {
		return false
	}
	for i := range is {
		if _, ok := other[i]; !ok {
			return false
		}
	}
	return true
}

func (is ItemsOne) Has(i CanOwnOne) bool {
	_, ok := is[i]
	return ok
}

func (is *ItemsOne) Add(i CanOwnOne) {
	if *is == nil {
		*is = ItemsOne{i: struct{}{}}
		return
	}
	(*is)[i] = struct{}{}
}

func (is ItemsOne) Serialise(b *bytes.Buffer) error {
	var lbuf [4]byte
	// watch out don't have more than 4 billion inventory items lolll
	binary.BigEndian.PutUint32(lbuf[:], uint32(len(is)))
	b.Write(lbuf[:])

	for i := range is {
		if !SerialiseItem2(i, b) {
			return fmt.Errorf("unknown CanOwnOne type: %T", i)
		}
	}
	return nil
}

func DeserialiseItemsOne(r io.Reader) (ItemsOne, error) {
	var lbuf [4]byte
	if _, err := r.Read(lbuf[:]); err != nil {
		return nil, fmt.Errorf("read ItemsOne length: %w", err)
	}
	l := binary.BigEndian.Uint32(lbuf[:])

	is := make(ItemsOne, l)
	for range l {
		i, err := DeserialiseItem2(r)
		if err != nil {
			return nil, fmt.Errorf("deserialise item: %w", err)
		}
		coo, ok := i.(CanOwnOne)
		if !ok {
			return nil, fmt.Errorf("item is not CanOwnOne: %T", i)
		}
		is[coo] = struct{}{}
	}
	return is, nil
}

type (
	Quantity  uint64
	ItemsMany map[CanOwnMany]Quantity
)

func (i ItemsMany) String() string {
	parts := make([]string, 0, len(i))
	for id, qty := range i {
		parts = append(parts, fmt.Sprintf("%s: %d", id.String(), qty))
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (i ItemsMany) Equal(other ItemsMany) bool {
	if len(i) != len(other) {
		return false
	}
	for id := range i {
		if qty, ok := other[id]; !ok || qty != i[id] {
			return false
		}
	}
	return true
}

func (i *ItemsMany) Add(item CanOwnMany, qty Quantity) {
	if *i == nil {
		*i = ItemsMany{item: qty}
		return
	}
	(*i)[item] += qty
}

func (is ItemsMany) Serialise(b *bytes.Buffer) error {
	var lbuf [4]byte
	binary.BigEndian.PutUint32(lbuf[:], uint32(len(is)))
	b.Write(lbuf[:])

	for i, qty := range is {
		if !SerialiseItem2(i, b) {
			return fmt.Errorf("unknown CanOwnMany type: %T", i)
		}
		var qtybuf [8]byte
		binary.BigEndian.PutUint64(qtybuf[:], uint64(qty))
		b.Write(qtybuf[:])
	}
	return nil
}

func DeserialiseItemsMany(r io.Reader) (ItemsMany, error) {
	var lbuf [4]byte
	if _, err := r.Read(lbuf[:]); err != nil {
		return nil, fmt.Errorf("read ItemsMany length: %w", err)
	}
	l := binary.BigEndian.Uint32(lbuf[:])

	is := make(ItemsMany, l)
	for range l {
		i, err := DeserialiseItem2(r)
		if err != nil {
			return nil, fmt.Errorf("deserialise item: %w", err)
		}
		com, ok := i.(CanOwnMany)
		if !ok {
			return nil, fmt.Errorf("item is not CanOwnMany: %T", i)
		}

		var qtybuf [8]byte
		if _, err := r.Read(qtybuf[:]); err != nil {
			return nil, fmt.Errorf("read quantity: %w", err)
		}
		qty := binary.BigEndian.Uint64(qtybuf[:])

		is[com] = Quantity(qty)
	}
	return is, nil
}

type Items struct {
	One  ItemsOne
	Many ItemsMany
}

func (i Items) String() string {
	if i.One == nil && i.Many == nil {
		return "Items {}"
	}

	var b strings.Builder
	b.WriteString("Items {")
	if len(i.One) > 0 {
		b.WriteString("\n\tOne ")
		b.WriteString(i.One.String())
	}
	if len(i.Many) > 0 {
		b.WriteString("\n\tMany ")
		b.WriteString(i.Many.String())
	}
	b.WriteByte('}')
	return b.String()
}

func (i Items) Equal(other Items) bool {
	return i.One.Equal(other.One) && i.Many.Equal(other.Many)
}

func (i Items) IsEmpty() bool {
	return len(i.One) == 0 && len(i.Many) == 0
}

func (is Items) Serialise(b *bytes.Buffer) error {
	if err := is.One.Serialise(b); err != nil {
		return fmt.Errorf("serialise ItemsOne: %w", err)
	}

	if err := is.Many.Serialise(b); err != nil {
		return fmt.Errorf("serialise ItemsMany: %w", err)
	}

	return nil
}

func DeserialiseItems(r io.Reader) (Items, error) {
	one, err := DeserialiseItemsOne(r)
	if err != nil {
		return Items{}, fmt.Errorf("deserialise ItemsOne: %w", err)
	}

	many, err := DeserialiseItemsMany(r)
	if err != nil {
		return Items{}, fmt.Errorf("deserialise ItemsMany: %w", err)
	}

	return Items{one, many}, nil
}
