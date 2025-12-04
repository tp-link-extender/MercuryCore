package main

import "fmt"

func encodeDecode(user User) {
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
		Many: ItemsMany{
			Currency{0}: 100,
		},
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
		{Owner: user},
		{Items: items},
	}
	if err := transfer.Valid(); err != nil {
		panic(err)
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

	fmt.Printf("   Transfer: %+v\n", transfer)

	b = transfer.marshalBinary()
	fmt.Printf(" Marshalled: %d\n", len(b))

	var newTransfer Transfer
	if err := newTransfer.UnmarshalBinary(b); err != nil {
		panic(err)
	}
	fmt.Printf("   Transfer: %+v\n", newTransfer)
	fmt.Println()
}

func main() {
	user := User{"user1"}

	encodeDecode(user)

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
