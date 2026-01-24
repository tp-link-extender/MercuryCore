package main

import (
	"bytes"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"time"

	gonanoid "github.com/matoous/go-nanoid/v2"
	bolt "go.etcd.io/bbolt"
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

func (t TransferID) Serialise() []byte {
	bs := make([]byte, 8+len(t.id))
	binary.BigEndian.PutUint64(bs[:8], t.timestamp)
	copy(bs[8:], t.id)
	return bs
}

func DeserialiseTransferID(data []byte) (t TransferID, err error) {
	if len(data) < 8 {
		return TransferID{}, errors.New("invalid TransferID data")
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
	return fmt.Sprintf("[%s] -> %v", s.Owner, s.Items)
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

func (s Send) Serialise(b *bytes.Buffer) {
	// encode Owner
	ok := SerialiseItem2(s.Owner, b)
	if !ok {
		panic(fmt.Sprintf("unknown Owner type: %T", s.Owner))
	}

	// encode Items
	if err := s.Items.Serialise(b); err != nil {
		panic(fmt.Sprintf("failed to serialise Items: %v", err))
	}
}

func DeserialiseSend(r io.Reader) (Send, error) {
	var s Send

	// decode Owner
	ownerItem, err := DeserialiseItem2(r)
	if err != nil {
		return s, fmt.Errorf("decode owner: %w", err)
	}

	if ownerItem != nil {
		owner, ok := ownerItem.(Owner)
		if !ok {
			return s, fmt.Errorf("item is not Owner: %T", ownerItem)
		}
		s.Owner = owner
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

func (t Transfer) Valid() error {
	// Can't have a transfer of nothing or between nobody
	if t[0].Owner == nil && t[1].Owner == nil {
		return errors.New("transfer has no source or destination")
	}
	if t[0].Items.IsEmpty() && t[1].Items.IsEmpty() {
		return errors.New("transfer has no items")
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
	if t[0].Owner == nil || t[1].Owner == nil || t[0].Items.IsEmpty() && t[1].Items.IsEmpty() {
		return false
	}

	return isSale(t) || isSale(t.Swap())
}

func (t Transfer) Equal(other Transfer) bool {
	return t[0].Equal(other[0]) && t[1].Equal(other[1])
}

func (t Transfer) Serialise(b *bytes.Buffer) {
	t[0].Serialise(b)
	t[1].Serialise(b)
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

func (os *OwnersOne) Add(o Owner) {
	if *os == nil {
		*os = OwnersOne{o: struct{}{}}
		return
	}
	(*os)[o] = struct{}{}
}

type OwnersMany map[Owner]Quantity

func (os *OwnersMany) Add(o Owner, qty Quantity) {
	if *os == nil {
		*os = OwnersMany{o: qty}
		return
	}
	(*os)[o] += qty
}

type State struct {
	ownerItems     map[Owner]*Items
	itemOwnersOne  map[CanOwnOne]*OwnersOne
	itemOwnersMany map[CanOwnMany]*OwnersMany
}

func makeState() State {
	return State{
		ownerItems:     make(map[Owner]*Items),
		itemOwnersOne:  make(map[CanOwnOne]*OwnersOne),
		itemOwnersMany: make(map[CanOwnMany]*OwnersMany),
	}
}

func (s *State) GetInventory(id Owner) *Items {
	inv, ok := s.ownerItems[id]
	if !ok {
		inv = &Items{}
		s.ownerItems[id] = inv
		return inv
	}

	for i, qty := range inv.Many {
		if qty == 0 {
			delete(inv.Many, i)
		}
	}
	s.ownerItems[id] = inv
	return inv
}

func (s *State) GetOwnersOne(item CanOwnOne) *OwnersOne {
	owners, ok := s.itemOwnersOne[item]
	if !ok {
		owners = &OwnersOne{}
		s.itemOwnersOne[item] = owners
	}
	return owners
}

func (s *State) GetOwnersMany(item CanOwnMany) *OwnersMany {
	owners, ok := s.itemOwnersMany[item]
	if !ok {
		owners = &OwnersMany{}
		s.itemOwnersMany[item] = owners
	}
	return owners
}

func (s State) CanApply(t Transfer) error {
	if err := t.Valid(); err != nil {
		return fmt.Errorf("invalid transfer: %w", err)
	}

	var errs []error

	for i, send := range t {
		if send.Items.IsEmpty() {
			continue
		}
		inv := s.GetInventory(send.Owner)
		otherinv := s.GetInventory(t[1-i].Owner)
		for item := range send.Items.One {
			// check if it's an asset mint from an unlimited source, if it is then skip this check
			if send.Owner != nil && !send.UnlimitedSourceAssetMint() && !inv.One.Has(item) {
				errs = append(errs, fmt.Errorf("item %v not owned by user %s", item, send.Owner))
			}

			// check for non-fungible item duplication
			if otherinv.One.Has(item) {
				errs = append(errs, fmt.Errorf("item %v already owned by user %s", item, t[1-i].Owner))
			}
		}
		for item, qty := range send.Items.Many {
			if send.Owner != nil && inv.Many[item] < qty {
				errs = append(errs, fmt.Errorf("insufficient quantity of item %v for user %s", item, send.Owner))
			}
		}
	}

	if len(errs) > 0 {
		return errors.Join(errs...)
	}
	return nil
}

func (s *State) addToSourceOwner(src CanOwnOne, item CanOwnMany, qty Quantity) {
	// add currency to to source owner
	var oo Owner
	for owner := range *s.GetOwnersOne(src) {
		oo = owner
		break
	}
	rdst := s.GetInventory(oo)

	rdst.Many.Add(item, qty)
	oMany := s.GetOwnersMany(item)
	oMany.Add(oo, qty)
}

// ⚠️ DANGEROUS!! ⚠️ Make sure you've called CanApply first!
func (s *State) ForceApply(t Transfer) {
	sale := t.Sale()

	for i, send := range t {
		if send.Owner != nil {
			src := s.GetInventory(send.Owner)
			for item := range send.Items.One {
				delete(src.One, item)
				oOne := s.GetOwnersOne(item)
				delete(*oOne, send.Owner)
			}
			for item, qty := range send.Items.Many {
				src.Many[item] -= qty
				oMany := s.GetOwnersMany(item)
				(*oMany)[send.Owner] -= qty
			}
		}

		other := t[1-i]
		if other.Owner == nil {
			// nil user, we need not send anything to them
			continue
		}

		dst := s.GetInventory(other.Owner)
		// fmt.Printf("Starting inventory for %v: %v\n", other.Owner, dst)
		for item := range send.Items.One {
			dst.One.Add(item)
			oOne := s.GetOwnersOne(item)
			oOne.Add(other.Owner)
		}

		if !sale {
			for item, qty := range send.Items.Many {
				dst.Many.Add(item, qty)
				oMany := s.GetOwnersMany(item)
				oMany.Add(other.Owner, qty)
			}
			continue
		}

		// TODO:
		// If the source owner is a user, this is handled correctly, items are added to their inventory
		// If the source owner is a group, this should work fine (funds should have to be withdrawn from groups manually)
		// we could make it the same for sources though I don't really see why
		for item, qty := range send.Items.Many {
			if src, ok := other.Owner.(CanOwnOne); ok {
				s.addToSourceOwner(src, item, qty)
			}
		}
		// fmt.Printf("Ending inventory for %v: %v\n", other.Owner, dst)
		// fmt.Printf("Ending inventory for %v: %v\n", other.Owner, s.GetInventory(other.Owner))
	}
}

func (s *State) TryApply(t Transfer) error {
	if err := s.CanApply(t); err != nil {
		return err
	}

	s.ForceApply(t)
	return nil
}

const bucketName = "ledger"

func applyKVPair(state *State) func(k, v []byte) error {
	return func(k, v []byte) error {
		tid, err := DeserialiseTransferID(k)
		if err != nil {
			return fmt.Errorf("decode transfer ID: %w", err)
		}

		// decode v into Transfer
		t, err := DeserialiseTransfer(bytes.NewReader(v))
		if err != nil {
			return fmt.Errorf("decode transfer %v: %w", tid, err)
		}

		if err := t.Valid(); err != nil {
			return fmt.Errorf("invalid transfer with ID %v: %w", tid, err)
		}

		// apply transfer to state
		if err := state.TryApply(t); err != nil {
			return fmt.Errorf("failed to apply transfer %v: %w", tid, err)
		}

		return nil
	}
}

func ReadState(db *bolt.DB) (State, error) {
	state := makeState()

	err := db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte(bucketName))
		if bucket == nil {
			return nil // empty state
		}

		return bucket.ForEach(applyKVPair(&state))
	})
	return state, err
}

type Ledger struct {
	db    *bolt.DB
	state State
}

func NewLedger(dbPath string) (*Ledger, error) {
	db, err := bolt.Open(dbPath, 0o600, nil)
	if err != nil {
		return nil, fmt.Errorf("open db: %w", err)
	}

	state, err := ReadState(db)
	if err != nil {
		return nil, fmt.Errorf("read state: %w", err)
	}

	return &Ledger{db, state}, nil
}

func (l *Ledger) Close() error {
	l.state = State{}
	return l.db.Close()
}

func (l *Ledger) Inventory(id Owner) *Items {
	return l.state.GetInventory(id)
}

func (l *Ledger) Transfer(tid TransferID, t Transfer) error {
	// Process the transfer
	if err := l.state.CanApply(t); err != nil {
		return fmt.Errorf("validate transfer: %w", err)
	}

	// Append the transfer to the database
	err := l.db.Update(func(tx *bolt.Tx) error {
		bucket, err := tx.CreateBucketIfNotExists([]byte(bucketName))
		if err != nil {
			return fmt.Errorf("create bucket: %w", err)
		}

		buf := &bytes.Buffer{}
		t.Serialise(buf)
		if err := bucket.Put(tid.Serialise(), buf.Bytes()); err != nil {
			return fmt.Errorf("put transfer: %w", err)
		}

		return nil
	})
	if err != nil {
		return fmt.Errorf("append transfer to db: %w", err)
	}

	// Apply the transfer to the in-memory state
	l.state.ForceApply(t)
	return nil
}

// Abstractions
type Economy struct {
	ledger                                                           *Ledger
	defaultCurrency                                                  Currency
	PlacePrice, GroupPrice, LimitedSourcePrice, UnlimitedSourcePrice Quantity
}

func NewEconomy(ledger *Ledger, placePrice, groupPrice, limitedSourcePrice, unlimitedSourcePrice Quantity) (*Economy) {
	return &Economy{
		ledger:               ledger,
		// default 0 currency
		PlacePrice:           placePrice,
		GroupPrice:           groupPrice,
		LimitedSourcePrice:   limitedSourcePrice,
		UnlimitedSourcePrice: unlimitedSourcePrice,
	}
}

func (e *Economy) OwnsOne(user Owner, item CanOwnOne) bool {
	// ea ledger
	// it's in the name
	inv := e.ledger.Inventory(user)
	return inv.One.Has(item)
}

func (e *Economy) OwnsMany(user Owner, item CanOwnMany) Quantity {
	inv := e.ledger.Inventory(user)
	return inv.Many[item]
}

func (e *Economy) OwnersOne(item CanOwnOne) OwnersOne {
	return *e.ledger.state.GetOwnersOne(item)
}

func (e *Economy) OwnersMany(item CanOwnMany) OwnersMany {
	return *e.ledger.state.GetOwnersMany(item)
}

func (e *Economy) Inventory(user Owner) Items {
	inv := *e.ledger.Inventory(user)
	return inv
}

func (e *Economy) Balance(user Owner) Quantity {
	return e.OwnsMany(user, e.defaultCurrency)
}

func (e *Economy) MintCurrency(user User, amount Quantity) (TransferID, error) {
	tf := Transfer{
		{Owner: user},
		{Items: Items{
			Many: ItemsMany{
				e.defaultCurrency: amount,
			},
		}},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return TransferID{}, fmt.Errorf("mint currency transfer %v: %w", tid, err)
	}

	return tid, nil
}

func (e *Economy) CreateLimitedSource(user User) (LimitedSource, TransferID, error) {
	src := RandLimitedSource()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.LimitedSourcePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return LimitedSource{}, TransferID{}, fmt.Errorf("create limited source transfer %v: %w", tid, err)
	}

	return src, tid, nil
}

func (e *Economy) CreateUnlimitedSource(user User) (UnlimitedSource, TransferID, error) {
	src := RandUnlimitedSource()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.UnlimitedSourcePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return UnlimitedSource{}, TransferID{}, fmt.Errorf("create unlimited source transfer %v: %w", tid, err)
	}

	return src, tid, nil
}

func (e *Economy) CreatePlace(user User) (Place, TransferID, error) {
	place := RandPlace()

	// tf (the fuck)
	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.PlacePrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				place: {},
			},
		}},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return Place{}, TransferID{}, fmt.Errorf("create place transfer %v: %w", tid, err)
	}

	return place, tid, nil
}

func (e *Economy) CreateGroup(user User) (Group, TransferID, error) {
	group := RandGroup()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: e.GroupPrice,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				group: {},
			},
		}},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return Group{}, TransferID{}, fmt.Errorf("create group transfer %v: %w", tid, err)
	}

	return group, tid, nil
}

func (e *Economy) BuyUnlimitedAsset(user User, src UnlimitedSource, price Quantity) (UnlimitedAsset, TransferID, error) {
	asset := src.Create()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: price,
				},
			},
		},
		{
			Owner: src,
			Items: Items{
				One: ItemsOne{
					asset: {},
				},
			},
		},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return UnlimitedAsset{}, TransferID{}, fmt.Errorf("buy unlimited asset transfer %v: %w", tid, err)
	}

	return asset, tid, nil
}

func (e *Economy) BuyLimitedAsset(user User, src LimitedSource, priceEach, qty Quantity) (LimitedAsset, TransferID, error) {
	asset := src.Create()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					e.defaultCurrency: priceEach * qty,
				},
			},
		},
		{
			Owner: src,
			Items: Items{
				Many: ItemsMany{
					asset: qty,
				},
			},
		},
	}

	tid := MakeTransferID()
	if err := e.ledger.Transfer(tid, tf); err != nil {
		return LimitedAsset{}, TransferID{}, fmt.Errorf("buy limited asset transfer %v: %w", tid, err)
	}

	return asset, tid, nil
}
