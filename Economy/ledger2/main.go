package main

import "fmt"

func encodeDecode(owner ItemOwner) {
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
		ItemCurrency{0}: 100,
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
		{Owner: owner},
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
}

func main() {
	owner := ItemOwner{OwnerTypeUser, "user1"}

	encodeDecode(owner)

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
			Owner: owner,
		},
		{
			Items: Items{
				ItemCurrency{0}: 100,
				RandIDPlace():   1,
			},
		},
	}); err != nil {
		panic(err)
	}

	inv := economy.Inventory(owner)
	fmt.Printf("Inventory for user %s: %+v\n", owner, inv)
}
