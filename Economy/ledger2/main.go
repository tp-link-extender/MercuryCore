package main

import "fmt"

func main() {
	economy, err := NewEconomy("mydb.db")
	if err != nil {
		panic(err)
	}
	defer economy.Close()

	fmt.Println("Database opened successfully")
	fmt.Println()

	const user = User("test")

	tid := MakeTransferID()
	economy.Transfer(tid, Transfer{
		{
			User: user,
		},
		{
			Items: Items{
				IDCurrency(0): 100,
			},
		},
	})

	inv := economy.Inventory(user)
	fmt.Printf("Inventory for user %s: %+v\n", user, inv)
}
