package main

import "fmt"

func main() {
	user := User{"user1"}

	economy, err := NewEconomy("mydb.db")
	if err != nil {
		panic(err)
	}
	defer economy.Close()

	fmt.Println("Database opened successfully")
	fmt.Println()

	tid := MakeTransferID()
	if err = economy.Transfer(tid, Transfer{
		{
			Owner: user,
		},
		{
			Items: Items{
				One: ItemsOne{
					RandPlace(): {},
				},
				Many: ItemsMany{
					Currency{0}: 500,
				},
			},
		},
	}); err != nil {
		panic(err)
	}

	inv := economy.Inventory(user)
	fmt.Printf("Inventory for user %s: %+v\n", user, inv)
}
