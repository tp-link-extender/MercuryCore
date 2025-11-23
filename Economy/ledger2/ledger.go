package main

import (
	"bytes"
	"fmt"
	"math/rand"

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
	parts := bytes.SplitN(data, []byte(":"), 2)
	if len(parts) != 2 {
		return fmt.Errorf("invalid ID format")
	}
	id.Item = Item(parts[0])
	id.Value = string(parts[1])
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
	Quantity  uint64
	UserID    string // probably optimum
	Inventory map[ID]Quantity
	State     map[UserID]Inventory
)

const bucketName = "ledger"

func ReadState(db *bolt.DB) (State, error) {
	state := make(State)

	err := db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte(bucketName))
		if bucket == nil {
			return nil // empty state
		}

		// return bucket.ForEach(func(k, v []byte) error {
		return nil
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

func (e *Economy) Inventory(userID UserID) Inventory {
	inv, ok := e.state[userID]
	if !ok {
		inv = make(Inventory)
		e.state[userID] = inv
	}
	return inv
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
