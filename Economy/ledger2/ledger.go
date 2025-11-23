package main

import (
	"fmt"

	bolt "go.etcd.io/bbolt"
)

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
