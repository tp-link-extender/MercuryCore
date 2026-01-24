package main

import "fmt"

func main() {
	user := User{"user1"}

	l, err := NewLedger("mydb.db")
	if err != nil {
		panic(err)
	}
	defer l.Close()

	fmt.Println("Database opened successfully")
	fmt.Println()

	e := NewEconomy(l, 10, 10, 100, 10)

	if _, err := e.MintCurrency(user, 15); err != nil {
		panic(err)
	}

	place, _, err := e.CreatePlace(user)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Created place: %s\n", place)

	if !e.OwnsOne(user, place) {
		panic("user should own the place")
	}

	inv := l.Inventory(user)
	fmt.Printf("Inventory for user %s: %+v\n", user, inv)
}
