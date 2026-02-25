package main

import (
	"bytes"
	"os"
	"testing"
	"time"
)

func TestEncTransferID(t *testing.T) {
	tid := MakeTransferID()

	b := tid.Serialise()

	const expLen = 28
	if len(b) != expLen {
		t.Fatalf("expected serialised TransferID length %d, got %d", expLen, len(b))
	}

	newTid, err := DeserialiseTransferID(b)
	if err != nil {
		t.Fatalf("DeserialiseTransferID: %v", err)
	}

	if tid != newTid {
		t.Fatalf("expected TransferID %v, got %v", tid, newTid)
	}
}

func TestEncItemsOne(t *testing.T) {
	items := Items{
		One: ItemsOne{
			RandPlace(): {},
		},
	}

	ibuf := &bytes.Buffer{}
	if err := items.Serialise(ibuf); err != nil {
		t.Fatalf("Items.Serialise: %v", err)
	}

	const expLen = 13
	if ibuf.Len() != expLen {
		t.Fatalf("expected serialised Items length %d, got %d", expLen, ibuf.Len())
	}

	newItems, err := DeserialiseItems(ibuf)
	if err != nil {
		t.Fatalf("DeserialiseItems: %v", err)
	}

	if !items.Equal(newItems) {
		t.Fatalf("expected Items %v, got %v", items, newItems)
	}
}

func encItemsMany(t *testing.T) Items {
	items := Items{
		Many: ItemsMany{
			Currency{}: 100,
		},
	}

	ibuf := &bytes.Buffer{}
	if err := items.Serialise(ibuf); err != nil {
		t.Fatalf("Items.Serialise: %v", err)
	}

	const expLen = 21
	if ibuf.Len() != expLen {
		t.Fatalf("expected serialised Items length %d, got %d", expLen, ibuf.Len())
	}

	newItems, err := DeserialiseItems(ibuf)
	if err != nil {
		t.Fatalf("DeserialiseItems: %v", err)
	}

	if !items.Equal(newItems) {
		t.Fatalf("expected Items %v, got %v", items, newItems)
	}
	return items
}

func encTransfer(t *testing.T, user User, items Items) {
	transfer := Transfer{
		{Owner: user},
		{Items: items},
	}
	if err := transfer.Valid(); err != nil {
		t.Fatalf("Transfer.Valid: %v", err)
	}

	for _, send := range transfer {
		sbuf := &bytes.Buffer{}
		send.Serialise(sbuf)

		newSend, err := DeserialiseSend(sbuf)
		if err != nil {
			t.Fatalf("DeserialiseSend: %v", err)
		}

		if !send.Equal(newSend) {
			t.Fatalf("expected Send %v, got %v", send, newSend)
		}
	}

	tbuf := &bytes.Buffer{}
	transfer.Serialise(tbuf)

	const expLen = 40
	if tbuf.Len() != expLen {
		t.Fatalf("expected serialised Transfer length %d, got %d", expLen, tbuf.Len())
	}

	newTransfer, err := DeserialiseTransfer(tbuf)
	if err != nil {
		t.Fatalf("DeserialiseTransfer: %v", err)
	}

	if !transfer.Equal(newTransfer) {
		t.Fatalf("expected Transfer %v, got %v", transfer, newTransfer)
	}
}

func TestEncodeDecode(t *testing.T) {
	user := User{"testuser"}
	items := encItemsMany(t)

	encTransfer(t, user, items)
}

func mintTest(l *Ledger, t *testing.T, currency Currency, user User) TransferID {
	xinv := Items{
		Many: ItemsMany{
			currency: 100,
		},
	}

	tf := Transfer{
		{Owner: user},
		{Items: xinv},
	}

	tid := MakeTransferID()
	if err := l.Transfer(tid, tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	return tid
}

func TestMint(t *testing.T) {
	// create temp file
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	// let there be rocks
	currency := Currency{0}
	user1 := User{"user1"}

	mintTest(l, t, currency, user1)
}

func TestStipend(t *testing.T) {
	// create temp file
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	// let there be rocks
	currency := Currency{0}
	user1 := User{"user1"}

	tid := mintTest(l, t, currency, user1)
	tid2, ok := l.GetUserLastStipend(user1)

	if !ok {
		t.Fatalf("expected last stipend for user %v, got none", user1)
	}
	if tid != tid2 {
		t.Fatalf("expected last stipend %v, got %v", tid, tid2)
	}
}

func createSourceTest(l *Ledger, t *testing.T, user User, currency Currency) UnlimitedSource {
	src := UnlimitedSource{1}

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 50,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				src: {},
			},
		}},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			src: {},
		},
		Many: ItemsMany{
			currency: 50, // user bought asset from themselves, so balance unchanged
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	return src
}

func buyAssetTest(l *Ledger, t *testing.T, user User, currency Currency, src UnlimitedSource) {
	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 10,
				},
			},
		},
		{
			Owner: src,
			Items: Items{
				One: ItemsOne{
					src.Create(): {},
				},
			},
		},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			src:          {},
			src.Create(): {},
		},
		Many: ItemsMany{
			currency: 50,
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}
}

func TestCreateSource(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency1 := Currency{1}
	user2 := User{"user2"}

	mintTest(l, t, currency1, user2)
	src := createSourceTest(l, t, user2, currency1)
	buyAssetTest(l, t, user2, currency1, src)
}

func createPlaceTest(l *Ledger, t *testing.T, user User, currency Currency) {
	place := RandPlace()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 10,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				place: {},
			},
		}},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			place: {},
		},
		Many: ItemsMany{
			currency: 90,
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	if err := l.Transfer(MakeTransferID(), tf); err == nil {
		t.Fatalf("expected error on duplicate transfer, got nil")
	}
}

func TestCreatePlace(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency2 := Currency{2}
	user3 := User{"user3"}

	mintTest(l, t, currency2, user3)
	createPlaceTest(l, t, user3, currency2)
}

func createGroupTest(l *Ledger, t *testing.T, user User, currency Currency) {
	group := RandGroup()

	tf := Transfer{
		{
			Owner: user,
			Items: Items{
				Many: ItemsMany{
					currency: 10,
				},
			},
		},
		{Items: Items{
			One: ItemsOne{
				group: {},
			},
		}},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	xinv := Items{
		One: ItemsOne{
			group: {},
		},
		Many: ItemsMany{
			currency: 90,
		},
	}

	if inv := l.Inventory(user); !inv.Equal(xinv) {
		t.Fatalf("expected inventory %v, got %v", xinv, inv)
	}

	if err := l.Transfer(MakeTransferID(), tf); err == nil {
		t.Fatalf("expected error on duplicate transfer, got nil")
	}
}

func TestCreateGroup(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency2 := Currency{2}
	user3 := User{"user3"}

	mintTest(l, t, currency2, user3)
	createGroupTest(l, t, user3, currency2)
}

func TestReopen(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	currency3 := Currency{3}
	user4 := User{"user4"}

	const qty = 100

	for i := Quantity(qty); i < 10*qty; i += qty {
		l, err := NewLedger(name)
		if err != nil {
			t.Fatalf("create ledger: %v", err)
		}

		tf := Transfer{
			{Owner: user4},
			{Items: Items{
				Many: ItemsMany{
					currency3: qty,
				},
			}},
		}

		if err := l.Transfer(MakeTransferID(), tf); err != nil {
			t.Fatalf("transfer: %v", err)
		}

		xinv := Items{
			Many: ItemsMany{
				currency3: i,
			},
		}

		if inv := l.Inventory(user4); !inv.Equal(xinv) {
			t.Fatalf("expected inventory %v, got %v", xinv, inv)
		}
		l.Close()
	}
}

func TestTransferHistory(t *testing.T) {
	// create temp file
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency4 := Currency{4}
	user5 := User{"user5"}

	tf := Transfer{
		{Owner: user5},
		{Items: Items{
			Many: ItemsMany{
				currency4: 100,
			},
		}},
	}

	if err := l.Transfer(MakeTransferID(), tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	history, err := l.TransferHistory(1)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	if len(history) != 1 {
		t.Fatalf("expected transfer history length 1, got %d", len(history))
	}

	if !history[0].Transfer.Equal(tf) {
		t.Fatalf("expected transfer %v, got %v", tf, history[0])
	}
}

func TestGetTransfer(t *testing.T) {
	// create temp file
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	currency5 := Currency{5}
	user6 := User{"user6"}

	tf := Transfer{
		{Owner: user6},
		{Items: Items{
			Many: ItemsMany{
				currency5: 100,
			},
		}},
	}

	tid := MakeTransferID()
	if err := l.Transfer(tid, tf); err != nil {
		t.Fatalf("transfer: %v", err)
	}

	// i love titanfall 2
	tf2, err := l.GetTransfer(tid)
	if err != nil {
		t.Fatalf("GetTransfer: %v", err)
	}

	if !tf2.Equal(tf) {
		t.Fatalf("expected transfer %v, got %v", tf, tf2)
	}
}

func TestAbstractions1(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	e := NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)

	user := User{"testuser"}

	if _, err := e.MintCurrency(user, 100); err != nil {
		t.Fatalf("MintCurrency: %v", err)
	}

	if e.Balance(user) != 100 {
		t.Fatalf("expected balance 100, got %d", e.Balance(user))
	}

	place, _, err := e.CreatePlace(user)
	if err != nil {
		t.Fatalf("CreatePlace: %v", err)
	}

	if e.Balance(user) != 90 {
		t.Fatalf("expected balance 90, got %d", e.Balance(user))
	}

	if !e.OwnsOne(user, place) {
		t.Fatalf("expected user to own place %v", place)
	}

	group, _, err := e.CreateGroup(user)
	if err != nil {
		t.Fatalf("CreateGroup: %v", err)
	}

	if e.Balance(user) != 80 {
		t.Fatalf("expected balance 80, got %d", e.Balance(user))
	}

	if !e.OwnsOne(user, group) {
		t.Fatalf("expected user to own group %v", group)
	}
}

func TestAbstractions2(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	e := NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)

	users := [3]User{
		{"user0"},
		{"user1"},
		{"user2"},
	}

	for _, user := range users {
		if _, err := e.MintCurrency(user, 100); err != nil {
			t.Fatalf("MintCurrency: %v", err)
		}
	}

	const price1 = 15
	source, _, err := e.CreateUnlimitedSource(users[0])
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	if !e.OwnsOne(users[0], source) {
		t.Fatalf("expected user to own source %v", source)
	}

	if e.Balance(users[0]) != 90 {
		t.Fatalf("expected balance 90, got %d", e.Balance(users[0]))
	}

	asset, _, err := e.BuyUnlimitedAsset(users[1], source, price1)
	if err != nil {
		t.Fatalf("BuyUnlimitedAsset: %v", err)
	}

	if !e.OwnsOne(users[1], asset) {
		t.Fatalf("expected user to own asset %v", asset)
	}

	if e.Balance(users[1]) != 85 {
		t.Fatalf("expected balance 85, got %d", e.Balance(users[1]))
	}

	if e.Balance(users[0]) != 105 {
		t.Fatalf("expected balance 105, got %d", e.Balance(users[0]))
	}

	if e.Balance(source) != 0 {
		t.Fatalf("expected source balance 0, got %d", e.Balance(source))
	}
}

func TestAbstractions3(t *testing.T) {
	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)
	defer os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	defer l.Close()

	e := NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)
	
	user := User{"testuser3"}

	if _, err := e.Stipend(user, 10); err != nil {
		t.Fatalf("Stipend: %v", err)
	}

	if _, err := e.Stipend(user, 10); err != ErrStipendNotReady {
		t.Fatalf("expected ErrStipendNotReady, got %v", err)
	}

	if e.Balance(user) != 10 {
		t.Fatalf("expected balance 10, got %d", e.Balance(user))
	}
}
