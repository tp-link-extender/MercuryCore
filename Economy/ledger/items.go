package ledger

import (
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
	idl := len(idstr)
	id := make([]byte, 2+idl)
	id[0] = byte(i.Type())
	id[1] = byte(idl)
	copy(id[2:], idstr)
	return id
}

func SerialiseItem(i Item, w io.Writer) bool {
	if i == nil {
		w.Write([]byte{byte(TypeNil)})
	} else if ni, ok := i.(NumericItem); ok {
		w.Write(SerialiseNumeric(ni))
	} else if si, ok := i.(StringItem); ok {
		w.Write(SerialiseString(si))
	} else {
		return false
	}
	return true
}

func DeserialiseItem(r io.Reader) (Item, error) {
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

func (io ItemsOne) String() string {
	parts := make([]string, 0, len(io))
	for coo := range io {
		parts = append(parts, coo.String())
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (io ItemsOne) Equal(other ItemsOne) bool {
	if len(io) != len(other) {
		return false
	}
	for coo := range io {
		if _, ok := other[coo]; !ok {
			return false
		}
	}
	return true
}

func (io ItemsOne) Has(i CanOwnOne) bool {
	_, ok := io[i]
	return ok
}

func (io *ItemsOne) Add(i CanOwnOne) {
	if *io == nil {
		*io = ItemsOne{i: struct{}{}}
		return
	}
	(*io)[i] = struct{}{}
}

func (io ItemsOne) Serialise(w io.Writer) error {
	var lbuf [4]byte
	// watch out don't have more than 4 billion inventory items lolll
	binary.BigEndian.PutUint32(lbuf[:], uint32(len(io)))
	w.Write(lbuf[:])

	for i := range io {
		if !SerialiseItem(i, w) {
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

	io := make(ItemsOne, l)
	for range l {
		i, err := DeserialiseItem(r)
		if err != nil {
			return nil, fmt.Errorf("decode item: %w", err)
		}
		coo, ok := i.(CanOwnOne)
		if !ok {
			return nil, fmt.Errorf("item is not CanOwnOne: %T", i)
		}
		io[coo] = struct{}{}
	}
	return io, nil
}

type (
	Quantity  uint64
	ItemsMany map[CanOwnMany]Quantity
)

func (im ItemsMany) String() string {
	parts := make([]string, 0, len(im))
	for com, qty := range im {
		parts = append(parts, fmt.Sprintf("%s: %d", com.String(), qty))
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (im ItemsMany) Equal(other ItemsMany) bool {
	if len(im) != len(other) {
		return false
	}
	for com := range im {
		if qty, ok := other[com]; !ok || qty != im[com] {
			return false
		}
	}
	return true
}

func (im *ItemsMany) Add(i CanOwnMany, qty Quantity) {
	if *im == nil {
		*im = ItemsMany{i: qty}
		return
	}
	(*im)[i] += qty
}

func (im ItemsMany) Serialise(w io.Writer) error {
	var lbuf [4]byte
	binary.BigEndian.PutUint32(lbuf[:], uint32(len(im)))
	w.Write(lbuf[:])

	for i, qty := range im {
		if !SerialiseItem(i, w) {
			return fmt.Errorf("unknown CanOwnMany type: %T", i)
		}

		var qtybuf [8]byte
		binary.BigEndian.PutUint64(qtybuf[:], uint64(qty))
		w.Write(qtybuf[:])
	}
	return nil
}

func DeserialiseItemsMany(r io.Reader) (ItemsMany, error) {
	var lbuf [4]byte
	if _, err := r.Read(lbuf[:]); err != nil {
		return nil, fmt.Errorf("read ItemsMany length: %w", err)
	}
	l := binary.BigEndian.Uint32(lbuf[:])

	im := make(ItemsMany, l)
	for range l {
		i, err := DeserialiseItem(r)
		if err != nil {
			return nil, fmt.Errorf("decode item: %w", err)
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
		im[com] = Quantity(qty)
	}
	return im, nil
}

type Items struct {
	One  ItemsOne
	Many ItemsMany
}

func (is Items) String() string {
	if is.One == nil && is.Many == nil {
		return "Items {}"
	}

	var b strings.Builder
	b.WriteString("Items {")
	if len(is.One) > 0 {
		b.WriteString("\n\tOne ")
		b.WriteString(is.One.String())
	}
	if len(is.Many) > 0 {
		b.WriteString("\n\tMany ")
		b.WriteString(is.Many.String())
	}
	b.WriteString("\n}")
	return b.String()
}

func (is Items) Equal(other Items) bool {
	return is.One.Equal(other.One) && is.Many.Equal(other.Many)
}

func (is Items) IsEmpty() bool {
	return len(is.One) == 0 && len(is.Many) == 0
}

func (is Items) Serialise(w io.Writer) error {
	if err := is.One.Serialise(w); err != nil {
		return fmt.Errorf("serialise ItemsOne: %w", err)
	}

	if err := is.Many.Serialise(w); err != nil {
		return fmt.Errorf("serialise ItemsMany: %w", err)
	}

	return nil
}

func DeserialiseItems(r io.Reader) (is Items, err error) {
	if is.One, err = DeserialiseItemsOne(r); err != nil {
		return Items{}, fmt.Errorf("decode ItemsOne: %w", err)
	}

	if is.Many, err = DeserialiseItemsMany(r); err != nil {
		return Items{}, fmt.Errorf("decode ItemsMany: %w", err)
	}

	return
}
