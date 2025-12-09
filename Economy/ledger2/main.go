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

	tid := MakeTransferID()
	if err = l.Transfer(tid, Transfer{
		{Owner: user},
		{Items: Items{
			One: ItemsOne{
				RandPlace(): {},
			},
			Many: ItemsMany{
				Currency{0}: 500,
			},
		}},
	}); err != nil {
		panic(err)
	}

	inv := l.Inventory(user)
	fmt.Printf("Inventory for user %s: %+v\n", user, inv)
}
