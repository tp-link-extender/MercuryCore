package main

import (
	"bytes"
	"encoding/binary"
	"errors"
	"fmt"
	"math/rand"
	"strings"
	"time"

	gonanoid "github.com/matoous/go-nanoid/v2"
	bolt "go.etcd.io/bbolt"
)

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

func RandStringId() (id string) {
	id, _ = gonanoid.Generate(idchars, 20) // doesn't error at runtime, really
	return
}

func RandIntId() (id int) {
	return rand.Intn(9e8) + 1e8 // 9 digit
}

// assets are the worst grey area ever
// they are fungible, because users can own (as in have bought) multiple of the same asset ID
// but also not, because only one user can own (as in being the seller) of an asset
// HERE'S MY SOLUTION
// we have 2 item types associated with assets: the asset itself, and the source of the asset
// with the asset itself being fungible and the source being non-fungible

type Item byte

const (
	// Fungible assets (users can own any number of these)

	ItemCurrency Item = 'c'
	ItemAsset    Item = 'a'

	// Non-fungible assets (users can only own 1 of these)

	ItemGroup  Item = 'g'
	ItemSource Item = 's'
	ItemPlace  Item = 'p'

	// Not ownable
	ItemNil  Item = 0
	ItemUser Item = 'u' // slavery 2.0
)

func (it Item) Fungible() bool {
	return it == ItemCurrency || it == ItemAsset
}

func (it Item) Mintable() bool {
	return it == ItemCurrency || it == ItemGroup || it == ItemSource || it == ItemPlace
}

func (it Item) CanOwn() bool {
	return it == ItemUser || it == ItemGroup
}

func (it Item) CanBeOwned() bool {
	return it != ItemUser && it != ItemNil
}

type ID struct {
	Item
	Value string
}

func (id ID) String() string {
	return string(id.Item) + ":" + id.Value
}

func (id ID) IsNil() bool {
	return id.Item == ItemNil && id.Value == ""
}

func (id ID) marshalBinary() []byte {
	bs := make([]byte, 1+len(id.Value))
	bs[0] = byte(id.Item)
	copy(bs[1:], id.Value)
	return bs
}

// func (id ID) MarshalBinary() ([]byte, error) {
// 	return id.marshalBinary(), nil
// }

func (id *ID) UnmarshalBinary(data []byte) error {
	if len(data) == 0 {
		return errors.New("invalid ID")
	}

	id.Item = Item(data[0])
	id.Value = string(data[1:])
	return nil
}

func IDCurrency(currencyID uint) ID {
	return ID{Item: ItemCurrency, Value: fmt.Sprint(currencyID)}
}

func IDAsset(assetID uint) ID {
	return ID{Item: ItemAsset, Value: fmt.Sprint(assetID)}
}

func IDGroup(groupID string) ID {
	return ID{Item: ItemGroup, Value: groupID}
}

func RandIDGroup() ID {
	return ID{Item: ItemGroup, Value: RandStringId()}
}

func IDSource(assetID uint) ID {
	return ID{Item: ItemSource, Value: fmt.Sprint(assetID)}
}

func RandIDSource() ID {
	return ID{Item: ItemSource, Value: RandStringId()}
}

func IDPlace(placeID uint) ID {
	return ID{Item: ItemPlace, Value: fmt.Sprint(placeID)}
}

func RandIDPlace() ID {
	return ID{Item: ItemPlace, Value: RandStringId()}
}

func IDUser(userID string) ID {
	return ID{Item: ItemUser, Value: userID}
}

type (
	Quantity uint64
	Items    map[ID]Quantity
)

func (is Items) String() string {
	var parts []string
	for id, qty := range is {
		parts = append(parts, fmt.Sprintf("%s: %d", id, qty))
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (is Items) Equal(other Items) bool {
	if len(is) != len(other) {
		return false
	}
	for id, qty := range is {
		if other[id] != qty {
			return false
		}
	}
	return true
}

func (is Items) marshalBinary() []byte {
	var buf bytes.Buffer

	for id, qty := range is {
		idBytes := id.marshalBinary()
		buf.WriteByte(uint8(len(idBytes)))
		buf.Write(idBytes)
		binary.Write(&buf, binary.BigEndian, qty)
	}

	return buf.Bytes()
}

// func (is Items) MarshalBinary() ([]byte, error) {
// 	return is.marshalBinary(), nil
// }

func (is *Items) UnmarshalBinary(data []byte) error {
	*is = make(Items)
	// parts := bytes.Split(data, []byte{0})
	for i := 0; i < len(data); i += 8 {
		l := int(data[i])
		i++

		if len(data)-i < l+8 {
			return errors.New("incomplete item data")
		}

		var id ID
		if err := id.UnmarshalBinary(data[i:][:l]); err != nil {
			return fmt.Errorf("decode item ID: %w", err)
		}
		i += l

		qty := binary.BigEndian.Uint64(data[i:][:8])
		(*is)[id] = Quantity(qty)
	}

	return nil
}

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

func (t TransferID) marshalBinary() []byte {
	bs := make([]byte, 8+len(t.id))
	binary.BigEndian.PutUint64(bs[:8], t.timestamp)
	copy(bs[8:], t.id)
	return bs
}

// func (t TransferID) MarshalBinary() ([]byte, error) {
// 	return t.marshalBinary(), nil
// }

func (t *TransferID) UnmarshalBinary(data []byte) error {
	if len(data) < 8 {
		return errors.New("invalid TransferID data")
	}
	t.timestamp = binary.BigEndian.Uint64(data[:8])
	t.id = string(data[8:])
	return nil
}

// A Send represents items being sent FROM a user/group
type Send struct {
	Owner ID
	Items
}

func (s Send) String() string {
	return fmt.Sprintf("[%s] -> %v", s.Owner, s.Items)
}

func (s Send) Valid() error {
	if !s.Owner.CanOwn() && !s.Owner.IsNil() {
		return fmt.Errorf("owner %v cannot own items", s.Owner)
	}

	for i, qty := range s.Items {
		if qty == 0 {
			return fmt.Errorf("item %v has zero quantity", i)
		}
		if !i.CanBeOwned() {
			return fmt.Errorf("item %v cannot be owned", i)
		}
		if !i.Fungible() && qty > 1 {
			return fmt.Errorf("item %v is non-fungible but has quantity %d", i, qty)
		}
		if s.Owner.IsNil() && !i.Mintable() {
			return fmt.Errorf("item %v cannot be minted", i)
		}
	}
	return nil
}

func (s Send) marshalBinary() []byte {
	var buf bytes.Buffer
	// encode Owner
	ownerBytes := s.Owner.marshalBinary()
	buf.WriteByte(byte(len(ownerBytes)))
	buf.Write(ownerBytes)

	// encode Items
	buf.Write(s.Items.marshalBinary())
	return buf.Bytes()
}

// func (s Send) MarshalBinary() ([]byte, error) {
// 	return s.marshalBinary(), nil
// }

func (s *Send) UnmarshalBinary(data []byte) error {
	if len(data) < 1 {
		return errors.New("invalid Send data")
	}

	ownerLen := int(data[0])
	l := 1 + ownerLen
	if len(data) < l {
		return errors.New("incomplete Owner data in Send")
	}

	if err := s.Owner.UnmarshalBinary(data[1:l]); err != nil {
		return fmt.Errorf("decode owner: %w", err)
	}

	if err := s.Items.UnmarshalBinary(data[l:]); err != nil {
		return fmt.Errorf("decode items: %w", err)
	}

	return nil
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
	if t[0].Owner.IsNil() && t[1].Owner.IsNil() {
		return errors.New("transfer has no source or destination")
	}
	if t[0].Items == nil && t[1].Items == nil {
		return errors.New("transfer has no items")
	}
	for i, send := range t {
		if err := send.Valid(); err != nil {
			return fmt.Errorf("invalid Send[%d]: %w", i, err)
		}
	}
	return nil
}

func (t Transfer) marshalBinary() []byte {
	var buf bytes.Buffer

	s0 := t[0].marshalBinary()
	binary.Write(&buf, binary.BigEndian, uint32(len(s0)))

	buf.Write(s0)
	buf.Write(t[1].marshalBinary())

	return buf.Bytes()
}

// func (t Transfer) MarshalBinary() ([]byte, error) {
// 	return t.marshalBinary(), nil
// }

func (t *Transfer) UnmarshalBinary(data []byte) error {
	if len(data) < 4 {
		return errors.New("invalid Transfer data")
	}

	l := 4 + int(binary.BigEndian.Uint32(data[:4]))
	if len(data) < l {
		return errors.New("incomplete Send[0] data in Transfer")
	}

	if err := t[0].UnmarshalBinary(data[4:l]); err != nil {
		return fmt.Errorf("decode Send[0]: %w", err)
	}

	// we're never getting a 4GiB send
	if err := t[1].UnmarshalBinary(data[l:]); err != nil {
		return fmt.Errorf("decode Send[1]: %w", err)
	}

	return nil
}

type State map[ID]Items

func (s *State) GetInventory(id ID) Items {
	// idk if we really want to do this
	// if !id.CanOwn() {
	// 	return nil, fmt.Errorf("%v cannot own items", id)
	// }

	inv, ok := (*s)[id]
	if !ok {
		inv = make(Items)
		(*s)[id] = inv
	}
	return inv
}

func (s State) CanApply(t Transfer) error {
	if err := t.Valid(); err != nil {
		return fmt.Errorf("invalid transfer: %w", err)
	}

	var errs []error

	for i, send := range t {
		if send.Owner.IsNil() || send.Items == nil {
			continue
		}
		inv := s[send.Owner]
		otherinv := s[t[1-i].Owner]
		for id, qty := range send.Items {
			if inv[id] < qty {
				errs = append(errs, fmt.Errorf("insufficient quantity of item %v for user %s", id, send.Owner))
			}
			if otherinv != nil {
				// check for non-fungible item duplication
				if !id.Fungible() && otherinv[id] > 0 {
					errs = append(errs, fmt.Errorf("item %v already owned by user %s", id, t[1-i].Owner))
				}
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
		if !send.Owner.IsNil() {
			src := s.GetInventory(send.Owner)
			for itemID, qty := range send.Items {
				src[itemID] -= qty
			}
		}

		other := t[1-i]
		if other.Owner.IsNil() {
			// nil user, we need not send anything to them
			continue
		}

		dst := s.GetInventory(other.Owner)
		for itemID, qty := range send.Items {
			dst[itemID] += qty
		}
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
		var tid TransferID
		if err := tid.UnmarshalBinary(k); err != nil {
			return fmt.Errorf("decode transfer ID: %w", err)
		}

		// decode v into Transfer
		var t Transfer
		if err := t.UnmarshalBinary(v); err != nil {
			return fmt.Errorf("decode transfer %v: %w", tid, err)
		}

		fmt.Printf("Decoded %v: %+v\n", tid, t)
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
	db, err := bolt.Open(dbPath, 0600, nil)
	if err != nil {
		return nil, fmt.Errorf("open db: %w", err)
	}

	// clear database
	db.Update(func(tx *bolt.Tx) error {
		return tx.DeleteBucket([]byte(bucketName))
	})

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

func (e *Economy) Inventory(id ID) (Items, error) {
	if !id.CanOwn() {
		return nil, fmt.Errorf("%v cannot own items", id)
	}

	return e.state.GetInventory(id), nil
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

		if err := bucket.Put(tid.marshalBinary(), t.marshalBinary()); err != nil {
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
