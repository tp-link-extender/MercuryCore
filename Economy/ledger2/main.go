package main

import "fmt"

	const user = User("test")


func encodeDecode() {
	tid := MakeTransferID()
	fmt.Printf("Transfer ID: %v\n", tid)

	b := tid.marshalBinary()
	fmt.Printf(" Marshalled: %d\n", len(b))

	var newTid TransferID
	if err := newTid.UnmarshalBinary(b); err != nil {
		panic(err)
	}
	fmt.Printf("Transfer ID: %v\n", newTid)
	fmt.Println()

	// items

	items := Items{
		IDCurrency(0): 100,
	}

	fmt.Printf("      Items: %+v\n", items)

	b = items.marshalBinary()
	fmt.Printf(" Marshalled: %d\n", len(b))

	var newItems Items

	if err := newItems.UnmarshalBinary(b); err != nil {
		panic(err)
	}
	fmt.Printf("      Items: %+v\n", newItems)
	fmt.Println()

	// send

	transfer := Transfer{
		{User: user},
		{Items: items},
	}

	for _, send := range transfer {
		fmt.Printf("       Send: %+v\n", send)

		b := send.marshalBinary()
		fmt.Printf(" Marshalled: %d\n", len(b))

		var newSend Send
		if err := newSend.UnmarshalBinary(b); err != nil {
			panic(err)
		}
		fmt.Printf("       Send: %+v\n", newSend)
		fmt.Println()
	}
}

func main() {
	encodeDecode()

	economy, err := NewEconomy("mydb.db")
	if err != nil {
		panic(err)
	}
	defer economy.Close()

	fmt.Println("Database opened successfully")
	fmt.Println()


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
