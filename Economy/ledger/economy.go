package ledger

import (
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"time"

	gonanoid "github.com/matoous/go-nanoid/v2"
)

func RandNumericId() (id uint32) {
	return uint32(rand.Intn(9e8) + 1e8) // 9 digit
}

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

func RandStringId() (id string) {
	id, _ = gonanoid.Generate(idchars, 20) // doesn't error at runtime, really
	return
}

// assets are the worst grey area ever
// they are fungible, because users can own (as in have bought) multiple of the same asset ID
// but also not, because only one user can own (as in being the seller) of an asset
// HERE'S MY SOLUTION
// we have 2 item types associated with assets: the asset itself, and the source of the asset
// with the asset itself being fungible and the source being non-fungible

type TransferID struct {
	timestamp uint64
	id        string
}

func (t TransferID) String() string {
	return fmt.Sprintf("%d-%s", t.timestamp, t.id)
}

func MakeTransferID() TransferID {
	return TransferID{
		timestamp: uint64(time.Now().UnixNano()),
		id:        RandStringId(),
	}
}

// The timestamp comes first so they are ordered chronologically when sorted lexicographically
func (t TransferID) Serialise() []byte {
	bs := make([]byte, 8+len(t.id))
	binary.BigEndian.PutUint64(bs[:8], t.timestamp)
	copy(bs[8:], t.id)
	return bs
}

var ErrInvalidTransferID = errors.New("invalid TransferID")

func DeserialiseTransferID(data []byte) (t TransferID, err error) {
	if len(data) < 8 {
		return TransferID{}, ErrInvalidTransferID
	}
	t.timestamp = binary.BigEndian.Uint64(data[:8])
	t.id = string(data[8:])
	return
}

// A Send represents items being sent FROM a user/group
type Send struct {
	Owner Owner // again no embed pls (not as much of an issue here)
	Items Items
}

func (s Send) String() string {
	if s.Owner == nil {
		return fmt.Sprintf("[] -> %v", s.Items)
	}
	return fmt.Sprintf("%s -> %v", s.Owner, s.Items)
}

func (s Send) Valid() error {
	for i := range s.Items.One {
		if s.Owner == nil && !IsMintable(i) {
			return fmt.Errorf("CanOwnOne %v cannot be minted", i)
		}
	}
	for i, qty := range s.Items.Many {
		if qty == 0 {
			return fmt.Errorf("CanOwnMany %v has zero quantity", i)
		}
		if s.Owner == nil && !IsMintable(i) {
			return fmt.Errorf("CanOwnMany %v cannot be minted", i)
		}
	}
	return nil
}

func (s Send) Equal(other Send) bool {
	if s.Owner != other.Owner {
		return false
	}
	return s.Items.Equal(other.Items)
}

func (s Send) UnlimitedSourceAssetMint() bool {
	ous, ok := s.Owner.(UnlimitedSource)
	if !ok {
		return false
	}

	return s.Items.Equal(Items{
		One: ItemsOne{
			ous.Create(): {},
		},
	})
}

func (s Send) Serialise(w io.Writer) {
	// encode Owner
	if !SerialiseItem(s.Owner, w) {
		panic(fmt.Sprintf("unknown Owner type: %T", s.Owner))
	}

	// encode Items
	if err := s.Items.Serialise(w); err != nil {
		panic(fmt.Sprintf("serialise Items: %v", err))
	}
}

func DeserialiseSend(r io.Reader) (Send, error) {
	var s Send

	// decode Owner
	oi, err := DeserialiseItem(r)
	if err != nil {
		return s, fmt.Errorf("decode owner: %w", err)
	}

	if oi != nil {
		o, ok := oi.(Owner)
		if !ok {
			return s, fmt.Errorf("item is not Owner: %T", oi)
		}
		s.Owner = o
	}

	// decode Items
	s.Items, err = DeserialiseItems(r)
	if err != nil {
		return s, fmt.Errorf("decode items: %w", err)
	}

	return s, nil
}

// A transfer with a From and To is a transaction
// A transfer with only a From is a burn
// A transfer with only a To is a mint
// A transfer with neither is INVALID!
// The empty UserID refers to the nil account for mints/burns
type Transfer [2]Send

func (t Transfer) String() string {
	return fmt.Sprintf("%s, %s", t[0], t[1])
}

type TransferWithID struct {
	ID       TransferID
	Transfer Transfer
}

func (t TransferWithID) String() string {
	return fmt.Sprintf("%s: %s", t.ID, t.Transfer)
}

var (
	ErrNoSourceOrDestination = errors.New("transfer has no source or destination")
	ErrNoItems               = errors.New("transfer has no items")
)

func (t Transfer) Valid() error {
	// Can't have a transfer of nothing or between nobody
	if t[0].Owner == nil && t[1].Owner == nil {
		return ErrNoSourceOrDestination
	}
	if t[0].Items.IsEmpty() && t[1].Items.IsEmpty() {
		return ErrNoItems
	}
	for i, send := range t {
		if err := send.Valid(); err != nil {
			return fmt.Errorf("invalid Send[%d]: %w", i, err)
		}
	}
	return nil
}

func (t Transfer) Swap() Transfer {
	return Transfer{t[1], t[0]}
}

func isSale(t Transfer) bool {
	switch t[0].Owner.(type) {
	case LimitedSource, UnlimitedSource:
	default:
		return false
	}

	_, ok := t[1].Owner.(User)
	return ok
}

// This is how an angel dies
// I blame it on my own sick pride
// Blame it on my ADD, baby
func (t Transfer) Sale() bool {
	// items could be empty on one side if the item is free or smth
	if t[0].Items.IsEmpty() && t[1].Items.IsEmpty() {
		return false
	}

	return isSale(t) || isSale(t.Swap())
}

func isStipend(t Transfer) bool {
	// A stipend has a nil owner and only currency in one direction, and a user on the other
	if t[0].Owner != nil || t[1].Owner == nil || t[0].Items.IsEmpty() || !t[1].Items.IsEmpty() || len(t[0].Items.One) > 0 || len(t[0].Items.Many) != 1 {
		return false
	}

	if _, ok := t[1].Owner.(User); !ok {
		return false
	}

	for i := range t[0].Items.Many {
		_, ok := i.(Currency)
		return ok // there's only one item here
	}

	return false // never reached i guess
}

func (t Transfer) Stipend() bool {
	return isStipend(t) || isStipend(t.Swap())
}

func (t Transfer) Equal(other Transfer) bool {
	return t[0].Equal(other[0]) && t[1].Equal(other[1])
}

func (t Transfer) Serialise(w io.Writer) {
	t[0].Serialise(w)
	t[1].Serialise(w)
}

func DeserialiseTransfer(r io.Reader) (t Transfer, err error) {
	if t[0], err = DeserialiseSend(r); err != nil {
		return Transfer{}, fmt.Errorf("decode Send[0]: %w", err)
	}

	if t[1], err = DeserialiseSend(r); err != nil {
		return Transfer{}, fmt.Errorf("decode Send[1]: %w", err)
	}

	return
}

type OwnersOne map[Owner]struct{}

func (oo *OwnersOne) Add(o Owner) {
	if *oo == nil {
		*oo = OwnersOne{o: struct{}{}}
		return
	}
	(*oo)[o] = struct{}{}
}

func (oo OwnersOne) Serialise(w io.Writer) error {
	var lbuf [4]byte
	binary.BigEndian.PutUint32(lbuf[:], uint32(len(oo)))
	w.Write(lbuf[:])

	for o := range oo {
		if !SerialiseItem(o, w) {
			return fmt.Errorf("unknown Owner type: %T", o)
		}
	}
	return nil
}

func DeserialiseOwnersOne(r io.Reader) (OwnersOne, error) {
	var lbuf [4]byte
	if _, err := r.Read(lbuf[:]); err != nil {
		return nil, fmt.Errorf("read OwnersOne length: %w", err)
	}
	l := binary.BigEndian.Uint32(lbuf[:])

	oo := make(OwnersOne, l)
	for range l {
		i, err := DeserialiseItem(r)
		if err != nil {
			return nil, fmt.Errorf("decode owner: %w", err)
		}
		o, ok := i.(Owner)
		if !ok {
			return nil, fmt.Errorf("item is not Owner: %T", i)
		}
		oo[o] = struct{}{}
	}
	return oo, nil
}

type OwnersMany map[Owner]Quantity

func (om *OwnersMany) Add(o Owner, qty Quantity) {
	if *om == nil {
		*om = OwnersMany{o: qty}
		return
	}
	(*om)[o] += qty
}

func (om OwnersMany) Serialise(w io.Writer) error {
	var lbuf [4]byte
	binary.BigEndian.PutUint32(lbuf[:], uint32(len(om)))
	w.Write(lbuf[:])

	for o, qty := range om {
		if !SerialiseItem(o, w) {
			return fmt.Errorf("unknown Owner type: %T", o)
		}

		var qtybuf [8]byte
		binary.BigEndian.PutUint64(qtybuf[:], uint64(qty))
		w.Write(qtybuf[:])
	}
	return nil
}

func DeserialiseOwnersMany(r io.Reader) (OwnersMany, error) {
	var lbuf [4]byte
	if _, err := r.Read(lbuf[:]); err != nil {
		return nil, fmt.Errorf("read OwnersMany length: %w", err)
	}
	l := binary.BigEndian.Uint32(lbuf[:])

	om := make(OwnersMany, l)
	for range l {
		i, err := DeserialiseItem(r)
		if err != nil {
			return nil, fmt.Errorf("decode owner: %w", err)
		}
		o, ok := i.(Owner)
		if !ok {
			return nil, fmt.Errorf("item is not Owner: %T", i)
		}

		var qtybuf [8]byte
		if _, err := r.Read(qtybuf[:]); err != nil {
			return nil, fmt.Errorf("read quantity: %w", err)
		}
		qty := binary.BigEndian.Uint64(qtybuf[:])
		om[o] = Quantity(qty)
	}
	return om, nil
}
