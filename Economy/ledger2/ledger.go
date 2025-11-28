package main

import (
	"bytes"
	"encoding/binary"
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

// a user can own:

// multiple assets (fungible):
// - currency (of a given ID), with a quantity
// - assets (of a given ID), with a quantity

// singular assets (non-fungible):
// - place/game (of a given ID), only 1 of each
// - group (of a given ID), only 1 of each

type Item string

const (
	ItemCurrency Item = "currency"
	ItemAsset    Item = "asset"
	ItemPlace    Item = "place"
	ItemGroup    Item = "group"
)

func (it Item) Fungible() bool {
	return it == ItemCurrency || it == ItemAsset
}

type ID struct {
	Item
	Value string
}

func (id ID) String() string {
	return string(id.Item) + ":" + id.Value
}

func (id ID) marshalBinary() []byte {
	var buf bytes.Buffer
	buf.WriteString(string(id.Item))
	buf.WriteByte(':')
	buf.WriteString(id.Value)
	return buf.Bytes()
}

// func (id ID) MarshalBinary() ([]byte, error) {
// 	return id.marshalBinary(), nil
// }

func (id *ID) UnmarshalBinary(data []byte) error {
	i, v, found := bytes.Cut(data, []byte{':'})
	if !found {
		return fmt.Errorf("invalid ID format")
	}
	id.Item = Item(i)
	id.Value = string(v)
	return nil
}

func IDCurrency(currencyID uint) ID {
	return ID{Item: ItemCurrency, Value: fmt.Sprint(currencyID)}
}

func IDAsset(assetID uint) ID {
	return ID{Item: ItemAsset, Value: fmt.Sprint(assetID)}
}

func RandIDAsset() ID {
	return ID{Item: ItemAsset, Value: RandStringId()}
}

func IDPlace(placeID uint) ID {
	return ID{Item: ItemPlace, Value: fmt.Sprint(placeID)}
}

func RandIDPlace() ID {
	return ID{Item: ItemPlace, Value: RandStringId()}
}

func IDGroup(groupID string) (ID, error) {
	if strings.Contains(groupID, "\000") {
		return ID{}, fmt.Errorf("group ID contains invalid null byte")
	}
	return ID{Item: ItemGroup, Value: groupID}, nil
}

func RandIDGroup() ID {
	return ID{Item: ItemGroup, Value: RandStringId()}
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

func (is Items) marshalBinary() []byte {
	var buf bytes.Buffer

	for id, qty := range is {
		idBytes := id.marshalBinary()
		buf.Write(idBytes)
		buf.WriteByte(0) // separator
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
	for len(data) > 0 {
		sepI := bytes.IndexByte(data, 0)
		if sepI == -1 {
			sepI = len(data)
		}

		var id ID
		if err := id.UnmarshalBinary(data[:sepI]); err != nil {
			return fmt.Errorf("decode item ID: %v", err)
		}

		if len(data) < sepI+1+8 {
			return fmt.Errorf("incomplete quantity data for item %v", id)
		}
		qty := binary.BigEndian.Uint64(data[sepI+1:][:8])
		(*is)[id] = Quantity(qty)

		data = data[sepI+1+8:]
	}

	return nil
}

type User string // probably optimum

const NilUser User = ""

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
		return fmt.Errorf("invalid TransferID data")
	}
	t.timestamp = binary.BigEndian.Uint64(data[:8])
	t.id = string(data[8:])
	return nil
}

// A Send represents items being sent FROM a user
type Send struct {
	User
	Items
}

func (s Send) String() string {
	return fmt.Sprintf("[%s] -> %v", s.User, s.Items)
}

func (s Send) marshalBinary() []byte {
	var buf bytes.Buffer
	// encode User
	buf.WriteByte(uint8(len(s.User)))
	buf.WriteString(string(s.User))

	// encode Items
	buf.Write(s.Items.marshalBinary())
	return buf.Bytes()
}

// func (s Send) MarshalBinary() ([]byte, error) {
// 	return s.marshalBinary(), nil
// }

func (s *Send) UnmarshalBinary(data []byte) error {
	if len(data) < 1 {
		return fmt.Errorf("invalid Send data")
	}

	l := 1 + int(data[0])
	if len(data) < l {
		return fmt.Errorf("incomplete User data in Send")
	}
	s.User = User(data[1:l])

	if err := s.Items.UnmarshalBinary(data[l:]); err != nil {
		return fmt.Errorf("decode items: %v", err)
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
		return fmt.Errorf("invalid Transfer data")
	}

	l := 4 + int(binary.BigEndian.Uint32(data[:4]))
	if len(data) < l {
		return fmt.Errorf("incomplete Send[0] data in Transfer")
	}

	if err := t[0].UnmarshalBinary(data[4:l]); err != nil {
		return fmt.Errorf("decode Send[0]: %v", err)
	}

	// we're never getting a 4GiB send
	if err := t[1].UnmarshalBinary(data[l:]); err != nil {
		return fmt.Errorf("decode Send[1]: %v", err)
	}

	return nil
}

func (t Transfer) Valid() bool {
	// Can't have a transfer of nothing or between nobody
	return (t[0].User != "" || t[1].User != "") && (t[0].Items != nil || t[1].Items != nil)
}

type State map[User]Items

func (s *State) GetInventory(user User) Items {
	inv, ok := (*s)[user]
	if !ok {
		inv = make(Items)
		(*s)[user] = inv
	}
	return inv
}

func (s State) CanApply(t Transfer) error {
	if !t.Valid() {
		return fmt.Errorf("invalid transfer")
	}

	for _, send := range t {
		if send.User == "" || send.Items == nil {
			continue
		}
		inv := s[send.User]
		for id, qty := range send.Items {
			if inv[id] < qty {
				return fmt.Errorf("insufficient quantity of item %v for user %s", id, send.User)
			}
		}
	}

	return nil
}

// ⚠️ DANGEROUS!! ⚠️ Make sure you've called CanApply first!
func (s *State) ForceApply(t Transfer) {
	for i, send := range t {
		if send.User != "" {
			src := s.GetInventory(send.User)
			for itemID, qty := range send.Items {
				src[itemID] -= qty
			}
		}

		other := t[1-i]
		if other.User == "" {
			// nil user, we need not send anything to them
			continue
		}

		dst := s.GetInventory(other.User)
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
			return fmt.Errorf("decode transfer ID: %v", err)
		}

		// decode v into Transfer
		var t Transfer
		if err := t.UnmarshalBinary(v); err != nil {
			return fmt.Errorf("decode transfer %v: %v", tid, err)
		}

		fmt.Printf("Decoded %v: %+v\n", tid, t)
		if !t.Valid() {
			return fmt.Errorf("invalid transfer with ID %v", tid)
		}

		// apply transfer to state
		if err := state.TryApply(t); err != nil {
			return fmt.Errorf("failed to apply transfer %v: %v", tid, err)
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
		return nil, fmt.Errorf("open db: %v", err)
	}

	state, err := ReadState(db)
	if err != nil {
		return nil, fmt.Errorf("read state: %v", err)
	}

	return &Economy{db, state}, nil
}

func (e *Economy) Close() error {
	e.state = nil
	return e.db.Close()
}

func (e *Economy) Inventory(userID User) Items {
	inv, ok := e.state[userID]
	if !ok {
		inv = make(Items)
		e.state[userID] = inv
	}
	return inv
}

func (e *Economy) Transfer(tid TransferID, t Transfer) error {
	// Process the transfer
	if err := e.state.CanApply(t); err != nil {
		return fmt.Errorf("validate transfer: %v", err)
	}

	// Append the transfer to the database
	err := e.db.Update(func(tx *bolt.Tx) error {
		bucket, err := tx.CreateBucketIfNotExists([]byte(bucketName))
		if err != nil {
			return fmt.Errorf("create bucket: %v", err)
		}

		key := tid.marshalBinary()

		// var buf bytes.Buffer
		buf := t.marshalBinary()

		if err := bucket.Put(key, buf); err != nil {
			return fmt.Errorf("put transfer: %v", err)
		}

		return nil
	})
	if err != nil {
		return fmt.Errorf("append transfer to db: %v", err)
	}

	// Apply the transfer to the in-memory state
	e.state.ForceApply(t)
	return nil
}
