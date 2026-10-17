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

	e := NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)

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

	e := NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)

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

	return l, NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)
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

// The user is charged before any stock is granted, so a creation that fails partway through must not leave that stock behind. Otherwise anyone who can't afford a source can strand unlimited copies in the ledger forever, since the stock quantity is unbounded and there's nothing to claw it back with.
func TestCreateLimitedSourceFailureStrandsNoStock(t *testing.T) {
	_, e := newTestEconomy(t)

	// no currency at all, so the handover can't possibly be paid for
	broke := User{"broke"}

	const stock = 1000
	src, _, err := e.CreateLimitedSource(broke, stock)
	if err == nil {
		t.Fatalf("expected CreateLimitedSource to fail for a user with no currency")
	}

	// the whole point: nothing at all should have been written
	history, err := e.TransferHistory(10)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}

	if len(history) != 0 {
		t.Fatalf("expected a failed creation to write no transfers, got %d: %v", len(history), history[0])
	}

	// and specifically none of the stock we were about to grant
	if got := e.OwnersMany(src.Create())[src]; got != 0 {
		t.Fatalf("expected no stock to be stranded for %v, got %d", src.Create(), got)
	}
}

// a failed creation must not cost the user anything, and must not hand out a source
func TestCreateLimitedSourceFailureIsClean(t *testing.T) {
	_, e := newTestEconomy(t)

	broke := User{"broke"}

	src, _, err := e.CreateLimitedSource(broke, 1000)
	if err == nil {
		t.Fatalf("expected CreateLimitedSource to fail for a user with no currency")
	}

	if e.OwnsOne(broke, src) {
		t.Fatalf("expected a failed creation not to hand %v to the user", src)
	}

	if got := e.Balance(broke); got != 0 {
		t.Fatalf("expected a failed creation to cost nothing, got balance %d", got)
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

	reopenedEconomy := NewEconomy(reopened, 10, 10, 100, 10, 10, 10, time.Hour*12)

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

	e := NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)

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

// createPackageFixture builds a package source holding n component sources, which is the shape CreatePackageSource produces
func createPackageFixture(t *testing.T, e *Economy, creator User, n int) (PackageSource, []UnlimitedSource) {
	t.Helper()

	comps := make([]UnlimitedSource, n)
	sources := make([]PackageComponent, n)
	for i := range comps {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource for component %d: %v", i, err)
		}
		comps[i] = c
		sources[i] = c
	}

	pkgSrc, _, err := e.CreatePackageSource(creator, sources)
	if err != nil {
		t.Fatalf("CreatePackageSource: %v", err)
	}

	return pkgSrc, comps
}

// a package source is created, owned by its creator, and takes ownership of its component sources
func TestCreatePackageSource(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	fund(t, e, creator)

	pkgSrc, comps := createPackageFixture(t, e, creator, 2)

	if !e.OwnsOne(creator, pkgSrc) {
		t.Fatalf("expected creator to own %v", pkgSrc)
	}

	// the package source holds the component SOURCES, so it can reissue them forever
	for _, c := range comps {
		if !e.OwnsOne(pkgSrc, c) {
			t.Fatalf("expected %v to hold %v", pkgSrc, c)
		}
		if e.OwnsOne(creator, c) {
			t.Fatalf("expected creator to have handed over %v", c)
		}
	}

	// and it never holds the assets themselves
	for _, c := range comps {
		if e.OwnsOne(pkgSrc, c.Create()) {
			t.Fatalf("expected %v not to hold %v, only its source", pkgSrc, c.Create())
		}
	}
}

// a package with nothing in it isn't a package
func TestCreatePackageSourceNeedsContents(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	fund(t, e, creator)

	if _, _, err := e.CreatePackageSource(creator, nil); err != ErrEmptyPackage {
		t.Fatalf("expected ErrEmptyPackage, got %v", err)
	}
}

// a user who can afford the components but not the package shouldn't lose them
func TestCreatePackageSourceFailureKeepsComponents(t *testing.T) {
	_, e := newTestEconomy(t)

	poor := User{"poor"}

	// exactly enough for two component sources (2 x 10), and nothing left for the package
	if _, err := e.MintCurrency(poor, 20); err != nil {
		t.Fatalf("MintCurrency: %v", err)
	}

	comps := make([]UnlimitedSource, 2)
	sources := make([]PackageComponent, 2)
	for i := range comps {
		c, _, err := e.CreateUnlimitedSource(poor)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		comps[i] = c
		sources[i] = c
	}

	if got := e.Balance(poor); got != 0 {
		t.Fatalf("expected the fixture to leave the user broke, got balance %d", got)
	}

	// must fail on the package source price
	if _, _, err := e.CreatePackageSource(poor, sources); err == nil {
		t.Fatalf("expected CreatePackageSource to fail for a user who can't afford it")
	}

	// the components must still be theirs, and must not have been moved into a package source
	for _, c := range comps {
		if !e.OwnsOne(poor, c) {
			t.Fatalf("expected %v to still be held after a failed package creation", c)
		}
	}

	// and nothing at all should have been written by the failed attempt
	history, err := e.TransferHistory(50)
	if err != nil {
		t.Fatalf("TransferHistory: %v", err)
	}
	// 1 mint + 2 component sources = 3 successful transfers
	if len(history) != 3 {
		t.Fatalf("expected only the 3 successful transfers, got %d", len(history))
	}

}

// buying a package gives the buyer the package and every component, in one transfer
func TestBuyPackage(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	pkgSrc, comps := createPackageFixture(t, e, creator, 3)

	const price = 40
	pkg, _, err := e.BuyPackage(buyer, pkgSrc, price)
	if err != nil {
		t.Fatalf("BuyPackage: %v", err)
	}

	if pkg != pkgSrc.Create() {
		t.Fatalf("expected %v, got %v", pkgSrc.Create(), pkg)
	}

	if !e.OwnsOne(buyer, pkg) {
		t.Fatalf("expected buyer to own the package %v", pkg)
	}

	for _, c := range comps {
		if !e.OwnsOne(buyer, c.Create()) {
			t.Fatalf("expected buyer to own component %v", c.Create())
		}
	}

	// one price for the whole bundle
	if got := e.Balance(buyer); got != 200-price {
		t.Fatalf("expected buyer balance %d, got %d", 200-price, got)
	}

	// creator paid 10 per component source, 10 for the package source, then earned the sale price
	if got, want := e.Balance(creator), Quantity(200-3*10-10+price); got != want {
		t.Fatalf("expected creator balance %d, got %d", want, got)
	}
}

// a package source can sell the same bundle over and over, since it can always reissue
func TestBuyPackageRepeatedly(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyers := []User{{Id: "buyer1"}, {Id: "buyer2"}, {Id: "buyer3"}}
	fund(t, e, creator)
	fund(t, e, buyers...)

	pkgSrc, comps := createPackageFixture(t, e, creator, 2)

	for i, buyer := range buyers {
		if _, _, err := e.BuyPackage(buyer, pkgSrc, 20); err != nil {
			t.Fatalf("BuyPackage %d: %v", i, err)
		}
	}

	for _, buyer := range buyers {
		if !e.OwnsOne(buyer, pkgSrc.Create()) {
			t.Fatalf("expected %v to own the package", buyer)
		}
		for _, c := range comps {
			if !e.OwnsOne(buyer, c.Create()) {
				t.Fatalf("expected %v to own component %v", buyer, c.Create())
			}
		}
	}
}

// a repeat purchase of the same package is rejected and costs nothing
func TestBuyPackageRejectsRepeat(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	pkgSrc, _ := createPackageFixture(t, e, creator, 2)

	if _, _, err := e.BuyPackage(buyer, pkgSrc, 20); err != nil {
		t.Fatalf("BuyPackage: %v", err)
	}

	before := e.Balance(buyer)
	if _, _, err := e.BuyPackage(buyer, pkgSrc, 20); err == nil {
		t.Fatalf("expected a second purchase of the same package to be rejected")
	}
	if got := e.Balance(buyer); got != before {
		t.Fatalf("expected a rejected purchase to cost nothing, balance went %d -> %d", before, got)
	}
}

// buying a package when you already own one of its components still hands over the rest
func TestBuyPackageSkipsOwnedComponents(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	pkgSrc, comps := createPackageFixture(t, e, creator, 2)

	// the buyer already owns one component directly
	if _, _, err := e.BuyUnlimitedAsset(buyer, comps[0], 15); err != nil {
		t.Fatalf("BuyUnlimitedAsset: %v", err)
	}

	pkg, _, err := e.BuyPackage(buyer, pkgSrc, 40)
	if err != nil {
		t.Fatalf("expected the package purchase to succeed, got %v", err)
	}

	if !e.OwnsOne(buyer, pkg) {
		t.Fatalf("expected buyer to own the package")
	}
	if !e.OwnsOne(buyer, comps[1].Create()) {
		t.Fatalf("expected buyer to own the component they didn't have")
	}
}

// nested packages: buying the outer package hands over the inner package and its contents
func TestBuyNestedPackage(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	innerComps := make([]UnlimitedSource, 2)
	innerSources := make([]PackageComponent, 2)
	for i := range innerComps {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		innerComps[i] = c
		innerSources[i] = c
	}

	innerSrc, _, err := e.CreatePackageSource(creator, innerSources)
	if err != nil {
		t.Fatalf("CreatePackageSource inner: %v", err)
	}

	// the outer package contains the inner package source, so buying it should hand over the inner package itself along with everything inside the inner package
	outerSrc, _, err := e.CreatePackageSource(creator, []PackageComponent{innerSrc.CreateSource()})
	if err != nil {
		t.Fatalf("CreatePackageSource outer: %v", err)
	}

	if _, _, err := e.BuyPackage(buyer, outerSrc, 50); err != nil {
		t.Fatalf("BuyPackage: %v", err)
	}

	if !e.OwnsOne(buyer, outerSrc.Create()) {
		t.Fatalf("expected buyer to own the outer package")
	}
	if !e.OwnsOne(buyer, innerSrc.Create()) {
		t.Fatalf("expected buyer to own the nested package")
	}
	for _, c := range innerComps {
		if !e.OwnsOne(buyer, c.Create()) {
			t.Fatalf("expected buyer to own %v from inside the nested package", c.Create())
		}
	}
}

// ownerOf returns the single package source the user owns, for tests that don't capture the id
func ownerOf(t *testing.T, e *Economy, u User) PackageSource {
	t.Helper()

	inv := e.Inventory(u)
	var found []PackageSource
	for item := range inv.One {
		if ps, ok := item.(PackageSource); ok {
			found = append(found, ps)
		}
	}

	if len(found) != 1 {
		t.Fatalf("expected %v to own exactly 1 package source, got %d", u, len(found))
	}
	return found[0]
}

// a package must not be able to contain itself
func TestPackageCannotNestItself(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{"creator"}
	fund(t, e, creator)

	pkgSrc, comps := createPackageFixture(t, e, creator, 1)

	if _, err := e.AddPackageComponent(creator, pkgSrc, pkgSrc); err != ErrSelfNestedPackage {
		t.Fatalf("expected ErrSelfNestedPackage, got %v", err)
	}

	_ = comps
}

// the bundle has to survive a restart, since contents are reconstructed by replay
func TestPackageSurvivesReopen(t *testing.T) {
	l, e := newTestEconomy(t)

	creator := User{"creator"}
	buyer := User{"buyer"}
	fund(t, e, creator, buyer)

	pkgSrc, comps := createPackageFixture(t, e, creator, 2)

	if err := l.Close(); err != nil {
		t.Fatalf("close ledger: %v", err)
	}

	name := os.TempDir() + "/ledger_test.db"
	reopened, err := NewLedger(name)
	if err != nil {
		t.Fatalf("reopen ledger: %v", err)
	}
	defer reopened.Close()

	re := NewEconomy(reopened, 10, 10, 100, 10, 10, 10, time.Hour*12)

	if !re.OwnsOne(creator, pkgSrc) {
		t.Fatalf("expected creator to still own %v after reopen", pkgSrc)
	}
	for _, c := range comps {
		if !re.OwnsOne(pkgSrc, c) {
			t.Fatalf("expected %v to still hold %v after reopen", pkgSrc, c)
		}
	}

	// and it can still be sold
	if _, _, err := re.BuyPackage(buyer, pkgSrc, 30); err != nil {
		t.Fatalf("expected to still be able to sell the package after reopen, got %v", err)
	}
}

// PackageContents reports a package plus everything inside it, which is what a buyer receives
func TestPackageContents(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{Id: "creator"}
	fund(t, e, creator)

	pkgSrc, comps := createPackageFixture(t, e, creator, 3)

	contents := e.PackageContents(pkgSrc)

	if !contents.Has(pkgSrc.Create()) {
		t.Fatalf("expected contents to include the package itself")
	}
	for _, c := range comps {
		if !contents.Has(c.Create()) {
			t.Fatalf("expected contents to include %v", c.Create())
		}
	}
	if len(contents) != len(comps)+1 {
		t.Fatalf("expected %d items in contents, got %d", len(comps)+1, len(contents))
	}
}

// nested packages: the outer package's contents include the inner package's assets
func TestPackageContentsNested(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{Id: "creator"}
	fund(t, e, creator)

	innerComps := make([]UnlimitedSource, 2)
	innerSources := make([]PackageComponent, 2)
	for i := range innerComps {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		innerComps[i] = c
		innerSources[i] = c
	}

	innerSrc, _, err := e.CreatePackageSource(creator, innerSources)
	if err != nil {
		t.Fatalf("CreatePackageSource inner: %v", err)
	}

	outerSrc, _, err := e.CreatePackageSource(creator, []PackageComponent{innerSrc})
	if err != nil {
		t.Fatalf("CreatePackageSource outer: %v", err)
	}

	contents := e.PackageContents(outerSrc)

	// the outer package, the inner package, and both assets inside it
	if !contents.Has(outerSrc.Create()) {
		t.Fatalf("expected contents to include the outer package")
	}
	if !contents.Has(innerSrc.Create()) {
		t.Fatalf("expected contents to include the nested package")
	}
	for _, c := range innerComps {
		if !contents.Has(c.Create()) {
			t.Fatalf("expected contents to include %v from the nested package", c.Create())
		}
	}
}

// PackageItems is the reverse lookup: every asset that sits inside some package
func TestPackageItems(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{Id: "creator"}
	fund(t, e, creator)

	// a loose asset that isn't in any package
	loose, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	pkgSrc, comps := createPackageFixture(t, e, creator, 2)

	items := e.PackageItems()

	for _, c := range comps {
		if !items.Has(c.Create()) {
			t.Fatalf("expected %v to be reported as a package item", c.Create())
		}
	}

	// the package itself is purchasable, so it isn't a package item
	if items.Has(pkgSrc.Create()) {
		t.Fatalf("expected the package itself not to be a package item")
	}

	// nor is an asset sold on its own
	if items.Has(loose.Create()) {
		t.Fatalf("expected %v not to be a package item", loose.Create())
	}
}

// buying a package doesn't change which assets are package items
func TestPackageItemsStableAcrossSales(t *testing.T) {
	_, e := newTestEconomy(t)

	creator := User{Id: "creator"}
	buyer := User{Id: "buyer"}
	fund(t, e, creator, buyer)

	pkgSrc, comps := createPackageFixture(t, e, creator, 2)

	before := e.PackageItems()

	if _, _, err := e.BuyPackage(buyer, pkgSrc, 30); err != nil {
		t.Fatalf("BuyPackage: %v", err)
	}

	after := e.PackageItems()

	if !before.Equal(after) {
		t.Fatalf("expected package items to be unchanged by a sale")
	}
	for _, c := range comps {
		if !after.Has(c.Create()) {
			t.Fatalf("expected %v to still be a package item after being sold", c.Create())
		}
	}
}
