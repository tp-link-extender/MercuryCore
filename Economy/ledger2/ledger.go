package main

import (
	"bytes"
	"fmt"

	bolt "go.etcd.io/bbolt"
)

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
	Item  Item
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

func (id ID) Fungible() (bool, error) {
	return id.Item.Fungible(), nil
}

func IDCurrency(currencyID uint) ID {
	return ID{Item: ItemCurrency, Value: fmt.Sprint(currencyID)}
}

func IDAsset(assetID uint) ID {
	return ID{Item: ItemAsset, Value: fmt.Sprint(assetID)}
}

func IDPlace(placeID uint) ID {
	return ID{Item: ItemPlace, Value: fmt.Sprint(placeID)}
}

func IDGroup(groupID string) ID {
	return ID{Item: ItemGroup, Value: groupID}
}

func main() {
	db, err := bolt.Open("mydb.db", 0600, nil)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	fmt.Println("Database opened successfully")

	err = db.Update(func(tx *bolt.Tx) error {
		bucket, err := tx.CreateBucketIfNotExists([]byte("test"))
		if err != nil {
			return err
		}

		return bucket.Put([]byte("key"), []byte("value"))
	})
	if err != nil {
		panic(err)
	}

	// read the value back
	err = db.View(func(tx *bolt.Tx) error {
		bucket := tx.Bucket([]byte("test"))
		if bucket == nil {
			return fmt.Errorf("Bucket not found")
		}

		val := bucket.Get([]byte("key"))
		fmt.Printf("The value of 'key' is: %s\n", val)
		return nil
	})
	if err != nil {
		panic(err)
	}
}
