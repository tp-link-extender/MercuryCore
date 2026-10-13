package ledger_test

import (
	"bytes"
	"fmt"
	"os"
	"testing"
	"time"

	. "Economy/ledger"
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
		t.Fatalf("DeserialiseTransfer%v", err)
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
		t.Fatalf("Transfer.Val%v", err)
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
	if err := transfer.Serialise(tbuf); err != nil {
		t.Fatalf("serialise Transfer: %v", err)
	}

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

func TestTransferHistoryUser(t *testing.T) {
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

	history1, err := l.TransferHistoryOwner(1, user5)
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history1) != 1 {
		t.Fatalf("expected transfer history length 1, got %d", len(history1))
	}

	user6 := User{"user6"}
	history2, err := l.TransferHistoryOwner(1, user6)
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history2) != 0 {
		t.Fatalf("expected transfer history length 0, got %d", len(history2))
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

	placeOwners := e.OwnersOne(place)
	if len(placeOwners) != 1 {
		t.Fatalf("expected 1 owner of place %v, got %d", place, len(placeOwners))
	}

	if _, ok := placeOwners[user]; !ok {
		t.Fatalf("expected user to be owner of place %v", place)
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

	groupOwners := e.OwnersOne(group)
	if len(groupOwners) != 1 {
		t.Fatalf("expected 1 owner of group %v, got %d", group, len(groupOwners))
	}

	if _, ok := groupOwners[user]; !ok {
		t.Fatalf("expected user to be owner of group %v", group)
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
		t.Fatalf("expected user 0 to own source %v", source)
	}

	sourceOwners := e.OwnersOne(source)
	if len(sourceOwners) != 1 {
		t.Fatalf("expected 1 owner of source %v, got %d", source, len(sourceOwners))
	}

	if _, ok := sourceOwners[users[0]]; !ok {
		t.Fatalf("expected user 0 to be owner of source %v", source)
	}

	if e.Balance(users[0]) != 90 {
		t.Fatalf("expected user 0 balance 90, got %d", e.Balance(users[0]))
	}

	asset, _, err := e.BuyUnlimitedAsset(users[1], source, price1)
	if err != nil {
		t.Fatalf("BuyUnlimitedAsset: %v", err)
	}

	if !e.OwnsOne(users[1], asset) {
		t.Fatalf("expected user 1 to own asset %v", asset)
	}

	assetOwners := e.OwnersOne(asset)
	if len(assetOwners) != 1 {
		t.Fatalf("expected 1 owner of asset %v, got %d", asset, len(assetOwners))
	}

	if _, ok := assetOwners[users[1]]; !ok {
		t.Fatalf("expected user 1 to be owner of asset %v", asset)
	}

	if e.Balance(users[1]) != 85 {
		t.Fatalf("expected user 1 balance 85, got %d", e.Balance(users[1]))
	}

	if e.Balance(users[0]) != 105 {
		t.Fatalf("expected user 0 balance 105, got %d", e.Balance(users[0]))
	}

	if e.Balance(source) != 0 {
		t.Fatalf("expected source balance 0, got %d", e.Balance(source))
	}

	history, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history) != 5 {
		fmt.Printf("history: %v\n", history)
		t.Fatalf("expected transfer history length 5, got %d", len(history))
	}

	history0, err := e.TransferHistoryOwner(10, users[0])
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history0) != 2 {
		fmt.Printf("history0: %v\n", history0)
		t.Fatalf("expected transfer history length 2, got %d", len(history0))
	}

	history1, err := e.TransferHistoryOwner(10, users[1])
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history1) != 2 {
		fmt.Printf("history1: %v\n", history1)
		t.Fatalf("expected transfer history length 2, got %d", len(history1))
	}

	history2, err := e.TransferHistoryOwner(10, users[2])
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history2) != 1 {
		fmt.Printf("history2: %v\n", history2)
		t.Fatalf("expected transfer history length 1, got %d", len(history2))
	}
}

// newTestEconomy spins up a throwaway ledger with the usual test prices.
func newTestEconomy(t *testing.T) (*Ledger, *Economy) {
	t.Helper()

	name := os.TempDir() + "/ledger_test.db"
	os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	t.Cleanup(func() { os.Remove(name) })

	return l, NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)
}

func fund(t *testing.T, e *Economy, users ...User) {
	t.Helper()
	for _, user := range users {
		if _, err := e.MintCurrency(user, 200); err != nil {
			t.Fatalf("MintCurrency %v: %v", user, err)
		}
	}
}

// a source can issue its own asset as many times as it likes without ever holding it
func TestSourceReissuesOwnAsset(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer1 := User{"buyer1"}
	buyer2 := User{"buyer2"}
	fund(t, e, creator, buyer1, buyer2)

	src, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	for i, buyer := range []User{buyer1, buyer2} {
		asset, _, err := e.BuyUnlimitedAsset(buyer, src, 25)
		if err != nil {
			t.Fatalf("BuyUnlimitedAsset %d: %v", i, err)
		}
		if !e.OwnsOne(buyer, asset) {
			t.Fatalf("expected buyer %d to own %v", i, asset)
		}
		if e.OwnsOne(creator, asset) {
			t.Fatalf("expected creator not to own %v", asset)
		}
	}
}

// this is the package case: a source that holds another source can issue that source's asset indefinitely, without ever holding the asset itself
func TestSourceReissuesHeldSourceAsset(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer1 := User{"buyer1"}
	buyer2 := User{"buyer2"}
	fund(t, e, creator, buyer1, buyer2)

	// pkgSrc stands in for a PackageSource, compSrc for one of its components
	pkgSrc, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource pkg: %v", err)
	}
	compSrc, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource comp: %v", err)
	}

	// hand the component source over to the package source, which is what CreatePackageSource will do
	if err := l.Transfer(MakeTransferID(), Transfer{
		{Owner: creator, Items: Items{One: ItemsOne{compSrc: {}}}},
		{Owner: pkgSrc, Items: Items{}},
	}); err != nil {
		t.Fatalf("transfer component source: %v", err)
	}

	compAsset := compSrc.Create()

	for i, buyer := range []User{buyer1, buyer2} {
		if err := l.Transfer(MakeTransferID(), Transfer{
			{Owner: buyer, Items: Items{Many: ItemsMany{Currency{0}: 25}}},
			{Owner: pkgSrc, Items: Items{One: ItemsOne{compAsset: {}}}},
		}); err != nil {
			t.Fatalf("issue component %d: %v", i, err)
		}

		if !e.OwnsOne(buyer, compAsset) {
			t.Fatalf("expected buyer %d to own %v", i, compAsset)
		}
	}

	// the package source never held the asset, and still holds the source for it
	if e.OwnsOne(pkgSrc, compAsset) {
		t.Fatalf("expected package source not to hold %v", compAsset)
	}
	if !e.OwnsOne(pkgSrc, compSrc) {
		t.Fatalf("expected package source to still hold %v", compSrc)
	}
}

// entitlement comes from holding the source, so a source can't issue an asset it has no claim to
func TestSourceCannotIssueUnheldSourceAsset(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	pkgSrc, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource pkg: %v", err)
	}
	strangerSrc, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource stranger: %v", err)
	}

	// the creator never handed strangerSrc over to pkgSrc
	if err := l.Transfer(MakeTransferID(), Transfer{
		{Owner: buyer, Items: Items{Many: ItemsMany{Currency{0}: 25}}},
		{Owner: pkgSrc, Items: Items{One: ItemsOne{strangerSrc.Create(): {}}}},
	}); err == nil {
		t.Fatalf("expected issue of unheld %v to be rejected", strangerSrc.Create())
	}
}

func TestCreateLimitedSourceStocks(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	fund(t, e, creator)

	const stock = 5
	src, _, err := e.CreateLimitedSource(creator, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	if !e.OwnsOne(creator, src) {
		t.Fatalf("expected creator to own %v", src)
	}

	if got := e.OwnersMany(src.Create())[src]; got != stock {
		t.Fatalf("expected source to be stocked with %d %v, got %d", stock, src.Create(), got)
	}
}

func TestCreateLimitedSourceNeedsStock(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	fund(t, e, creator)

	if _, _, err := e.CreateLimitedSource(creator, 0); err != ErrNoStock {
		t.Fatalf("expected ErrNoStock, got %v", err)
	}
}

func TestBuyLimitedAsset(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	const stock = 5
	const price = 10
	const qty = 3

	src, _, err := e.CreateLimitedSource(creator, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	asset, _, err := e.BuyLimitedAsset(buyer, src, price, qty)
	if err != nil {
		t.Fatalf("BuyLimitedAsset: %v", err)
	}

	if asset != src.Create() {
		t.Fatalf("expected %v, got %v", src.Create(), asset)
	}

	// the buyer actually receives the asset, which is what the ForceApply sale path used to drop
	if got := e.OwnsMany(buyer, asset); got != qty {
		t.Fatalf("expected buyer to own %d %v, got %d", qty, asset, got)
	}

	// stock depletes, and the reverse index tracks it
	if got := e.OwnersMany(asset)[src]; got != stock-qty {
		t.Fatalf("expected source to have %d %v left, got %d", stock-qty, asset, got)
	}
	if got := e.OwnersMany(asset)[buyer]; got != qty {
		t.Fatalf("expected buyer to own %d %v, got %d", qty, asset, got)
	}

	// the creator is paid for exactly what sold, on top of the 100 spent on the source
	if got := e.Balance(creator); got != 200-100+price*qty {
		t.Fatalf("expected creator balance %d, got %d", 200-100+price*qty, got)
	}
	if got := e.Balance(buyer); got != 200-price*qty {
		t.Fatalf("expected buyer balance %d, got %d", 200-price*qty, got)
	}
}

// a source can't oversell itself
func TestBuyLimitedAssetRespectsStock(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	const stock = 2
	src, _, err := e.CreateLimitedSource(creator, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	if _, _, err := e.BuyLimitedAsset(buyer, src, 10, stock); err != nil {
		t.Fatalf("BuyLimitedAsset: %v", err)
	}

	if _, _, err := e.BuyLimitedAsset(buyer, src, 10, 1); err == nil {
		t.Fatalf("expected buying past stock to fail, got nil")
	}
}

// stock has to survive a restart, since it arrives via a mint that replay has to accept
func TestLimitedStockSurvivesReopen(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	fund(t, e, creator)

	const stock = 7
	src, _, err := e.CreateLimitedSource(creator, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	if err := l.Close(); err != nil {
		t.Fatalf("close ledger: %v", err)
	}

	name := os.TempDir() + "/ledger_test.db"
	reopened, err := NewLedger(name)
	if err != nil {
		t.Fatalf("reopen ledger: %v", err)
	}
	defer reopened.Close()

	reopenedEconomy := NewEconomy(reopened, 10, 10, 100, 10, 10, time.Hour*12)

	if !reopenedEconomy.OwnsOne(creator, src) {
		t.Fatalf("expected creator to still own %v", src)
	}
	if got := reopenedEconomy.OwnersMany(src.Create())[src]; got != stock {
		t.Fatalf("expected source to still be stocked with %d, got %d", stock, got)
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

	sid, err := e.Stipend(user)
	if err != nil {
		t.Fatalf("Stipend: %v", err)
	}

	if _, err := e.Stipend(user); err != ErrStipendNotReady {
		t.Fatalf("expected ErrStipendNotReady, got %v", err)
	}

	if e.Balance(user) != 10 {
		t.Fatalf("expected balance 10, got %d", e.Balance(user))
	}

	history1, err := e.TransferHistoryOwner(2, user)
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history1) != 1 {
		t.Fatalf("expected transfer history length 1, got %d", len(history1))
	}

	if history1[0].ID != sid {
		t.Fatalf("expected transfer ID %v, got %v", sid, history1[0].ID)
	}

	user2 := User{"testuser4"}
	history2, err := e.TransferHistoryOwner(2, user2)
	if err != nil {
		t.Fatalf("TransferHistoryOwner: %v", err)
	}

	if len(history2) != 0 {
		t.Fatalf("expected transfer history length 0, got %d", len(history2))
	}
}
