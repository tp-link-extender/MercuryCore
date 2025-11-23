package main

import (
	"bytes"
	"encoding/binary"
	"encoding/gob"
	"fmt"
	"math/rand"
	"time"

	gonanoid "github.com/matoous/go-nanoid/v2"
	bolt "go.etcd.io/bbolt"
)

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

func RandStringId() (id string) {
	id, _ = gonanoid.Generate(idchars, 15) // doesn't error at runtime, really
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

func (id ID) MarshalBinary() ([]byte, error) {
	var buf bytes.Buffer
	buf.WriteString(string(id.Item))
	buf.WriteByte(':')
	buf.WriteString(id.Value)
	return buf.Bytes(), nil
}

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

func IDGroup(groupID string) ID {
	return ID{Item: ItemGroup, Value: groupID}
}

func RandIDGroup() ID {
	return ID{Item: ItemGroup, Value: RandStringId()}
}

type (
	Quantity uint64
	UserID   string // probably optimum
	Items    map[ID]Quantity
	Send     struct {
		UserID // The items are being REMOVED from this user and ADDED to another
		Items
	}
)

func (s Send) Valid() bool {
	return s.UserID != "" && len(s.Items) > 0
}

type TransferID struct {
	timestamp uint64
	id        string
}

func MakeTransferID() TransferID {
	return TransferID{
		timestamp: uint64(time.Now().UnixNano()),
		id:        RandStringId(),
	}
}

func (t TransferID) MarshalBinary() ([]byte, error) {
	bs := make([]byte, 8+len(t.id))
	binary.BigEndian.PutUint64(bs[:8], t.timestamp)
	copy(bs[8:], t.id)
	return bs, nil
}

func (t *TransferID) UnmarshalBinary(data []byte) error {
	if len(data) < 8 {
		return fmt.Errorf("invalid TransferID data")
	}
	t.timestamp = binary.BigEndian.Uint64(data[:8])
	t.id = string(data[8:])
	return nil
}

// A transfer with a From and To is a transaction
// A transfer with only a From is a burn
// A transfer with only a To is a mint
// A transfer with neither is INVALID!
type Transfer struct {
	From, To *Send
}

func (t Transfer) MarshalBinary() ([]byte, error) {
	var buf bytes.Buffer
	enc := gob.NewEncoder(&buf)
	if err := enc.Encode(t); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func (t *Transfer) UnmarshalBinary(data []byte) error {
	buf := bytes.NewReader(data)
	dec := gob.NewDecoder(buf)
	return dec.Decode(t)
}

func (t Transfer) Valid() bool {
	if t.From == nil && t.To == nil ||
		t.From != nil && !t.From.Valid() ||
		t.To != nil && !t.To.Valid() {
		return false
	}
	return true
}

type State map[UserID]Items

func (s State) CanApply(t Transfer) error {
	if !t.Valid() {
		return fmt.Errorf("invalid transfer")
	}

	for _, p := range []*Send{t.From, t.To} {
		if p == nil {
			continue
		}

		inv := s[p.UserID]
		for id, qty := range p.Items {
			if inv[id] < qty {
				return fmt.Errorf("insufficient quantity of item %v for user %s", id, p.UserID)
			}
		}
	}

	return nil
}

// ⚠️ DANGEROUS!! ⚠️
func (s *State) forceApply(t Transfer) {
	if t.From != nil {
		src := (*s)[t.From.UserID]
		dst := (*s)[t.To.UserID]
		for id, qty := range t.From.Items {
			src[id] -= qty
			dst[id] += qty
		}
	}

	if t.To != nil {
		src := (*s)[t.To.UserID]
		dst := (*s)[t.From.UserID]
		for id, qty := range t.To.Items {
			src[id] -= qty
			dst[id] += qty
		}
	}
}

func (s *State) TryApply(t Transfer) error {
	if err := s.CanApply(t); err != nil {
		return err
	}

	s.forceApply(t)
	return nil
}

const bucketName = "ledger"

func applyKVPair(state *State) func(k, v []byte) error {
	return func(k, v []byte) error {
		var tid TransferID
		if err := tid.UnmarshalBinary(k); err != nil {
			return fmt.Errorf("decode transfer ID: %v", err)
		}

		fmt.Printf("ID: %v, Data: %x\n", tid, v)

		// decode v into Transfer
		var t Transfer
		if err := t.UnmarshalBinary(v); err != nil {
			return fmt.Errorf("decode transfer %v: %v", tid, err)
		}

		fmt.Printf("Decoded Transfer: %+v\n", t)
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
	if err != nil {
		return nil, err
	}

	return state, nil
}

type Economy struct {
	db    *bolt.DB
	state State
}

func NewEconomy(dbPath string) (*Economy, error) {
	db, err := bolt.Open(dbPath, 0600, nil)
	if err != nil {
		return nil, err
	}

	state, err := ReadState(db)
	if err != nil {
		return nil, err
	}

	return &Economy{db, state}, nil
}

func (e *Economy) Close() error {
	e.state = nil
	return e.db.Close()
}

func (e *Economy) Inventory(userID UserID) Items {
	inv, ok := e.state[userID]
	if !ok {
		inv = make(Items)
		e.state[userID] = inv
	}
	return inv
}

func (e *Economy) Transfer(t Transfer, timestamp TransferID) error {
	// Validate the transfer
	if t.From == nil && t.To == nil {
		return fmt.Errorf("invalid transfer: must specify From or To")
	}

	// Process the transfer
	return nil
}

func main() {
	economy, err := NewEconomy("mydb.db")
	if err != nil {
		panic(err)
	}
	defer economy.Close()

	fmt.Println("Database opened successfully")

	const user = UserID("test")

	inv := economy.Inventory(user)
	fmt.Printf("Inventory for user %s: %+v\n", user, inv)

	stats := economy.db.Stats()
	fmt.Printf("DB Stats: %+v\n", stats)
}
