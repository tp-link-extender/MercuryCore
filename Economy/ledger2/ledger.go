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

// TODO: also check if the unlimited source has the same ID as the asset itself
func (s Send) UnlimitedSourceAssetMint() bool {
	ous, ok := s.Owner.(UnlimitedSource)
	if !ok {
		return false
	}

	return s.Items.Equal(Items{
		One: ItemsOne{
			UnlimitedAsset{ous.id}: {},
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

type State map[Owner]*Items

func (s *State) GetInventory(id Owner) *Items {
	// idk if we really want to do this
	// if !id.CanOwn() {
	// 	return nil, fmt.Errorf("%v cannot own items", id)
	// }

	inv, ok := (*s)[id]
	if !ok {
		inv = &Items{}
		(*s)[id] = inv
		return inv
	}

	for i, qty := range inv.Many {
		if qty == 0 {
			delete(inv.Many, i)
		}
	}
	(*s)[id] = inv
	return inv
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

// ⚠️ DANGEROUS!! ⚠️ Make sure you've called CanApply first!
func (s *State) ForceApply(t Transfer) {
	for i, send := range t {
		if send.Owner != nil {
			src := s.GetInventory(send.Owner)
			for item := range send.Items.One {
				delete(src.One, item)
			}
			for item, qty := range send.Items.Many {
				src.Many[item] -= qty
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
		}
		for item, qty := range send.Items.Many {
			dst.Many.Add(item, qty)
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
	state := make(State)

	err := db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte(bucketName))
		if bucket == nil {
			return nil // empty state
		}

		return bucket.ForEach(applyKVPair(&state))
	})
	return state, err
}

type Economy struct {
	db    *bolt.DB
	state State
}

func NewEconomy(dbPath string) (*Economy, error) {
	db, err := bolt.Open(dbPath, 0o600, nil)
	if err != nil {
		return nil, fmt.Errorf("open db: %w", err)
	}

	state, err := ReadState(db)
	if err != nil {
		return nil, fmt.Errorf("read state: %w", err)
	}

	return &Economy{db, state}, nil
}

func (e *Economy) Close() error {
	e.state = nil
	return e.db.Close()
}

func (e *Economy) Inventory(id Owner) *Items {
	return e.state.GetInventory(id)
}

func (e *Economy) Transfer(tid TransferID, t Transfer) error {
	// Process the transfer
	if err := e.state.CanApply(t); err != nil {
		return fmt.Errorf("validate transfer: %w", err)
	}

	// Append the transfer to the database
	err := e.db.Update(func(tx *bolt.Tx) error {
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
	e.state.ForceApply(t)
	return nil
}

// Abstractions
type EconomyAbstraction struct {
	economy                                                          *Economy
	defaultCurrency                                                  Currency
	placePrice, groupPrice, limitedSourcePrice, unlimitedSourcePrice Quantity
}

func (ea *EconomyAbstraction) OwnsOne(user Owner, item CanOwnOne) bool {
	inv := ea.economy.Inventory(user)
	return inv.One.Has(item)
}

func (ea *EconomyAbstraction) OwnsMany(user Owner, item CanOwnMany) Quantity {
	inv := ea.economy.Inventory(user)
	return inv.Many[item]
}

func (ea *EconomyAbstraction) Balance(user Owner) Quantity {
	return ea.OwnsMany(user, ea.defaultCurrency)
}

func (ea *EconomyAbstraction) MintCurrency(user User, amount Quantity) (TransferID, error) {
	tf := Transfer{
		{Owner: user},
		{Items: Items{
			Many: ItemsMany{
				ea.defaultCurrency: amount,
			},
		}},
	}

	tid := MakeTransferID()
	if err := ea.economy.Transfer(tid, tf); err != nil {
		return TransferID{}, fmt.Errorf("mint currency transfer %v: %w", tid, err)
	}

	return tid, nil
}

func (ea *EconomyAbstraction) CreateLimitedSource(user User) (LimitedSource, TransferID, error) {
	src := RandLimitedSource()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					ea.defaultCurrency: ea.limitedSourcePrice,
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
	if err := ea.economy.Transfer(tid, tf); err != nil {
		return LimitedSource{}, TransferID{}, fmt.Errorf("create limited source transfer %v: %w", tid, err)
	}

	return src, tid, nil
}

func (ea *EconomyAbstraction) CreateUnlimitedSource(user User) (UnlimitedSource, TransferID, error) {
	src := RandUnlimitedSource()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					ea.defaultCurrency: ea.unlimitedSourcePrice,
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
	if err := ea.economy.Transfer(tid, tf); err != nil {
		return UnlimitedSource{}, TransferID{}, fmt.Errorf("create unlimited source transfer %v: %w", tid, err)
	}

	return src, tid, nil
}

func (ea *EconomyAbstraction) CreatePlace(user User) (Place, TransferID, error) {
	place := RandPlace()

	// tf (the fuck)
	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					ea.defaultCurrency: ea.placePrice,
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
	if err := ea.economy.Transfer(tid, tf); err != nil {
		return Place{}, TransferID{}, fmt.Errorf("create place transfer %v: %w", tid, err)
	}

	return place, tid, nil
}

func (ea *EconomyAbstraction) CreateGroup(user User) (Group, TransferID, error) {
	group := RandGroup()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					ea.defaultCurrency: ea.groupPrice,
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
	if err := ea.economy.Transfer(tid, tf); err != nil {
		return Group{}, TransferID{}, fmt.Errorf("create group transfer %v: %w", tid, err)
	}

	return group, tid, nil
}
