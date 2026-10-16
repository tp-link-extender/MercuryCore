package main

import (
	"bytes"
	"encoding/binary"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
	"time"

	. "Economy/ledger"
)

// serialiseItem mirrors SerialiseItem in the ledger package, which isn't exported. numeric items are a type byte plus a big-endian uint32; string items are a type byte, a length byte, then the raw id
func serialiseItem(i Item, w *bytes.Buffer) {
	switch i := i.(type) {
	case Currency:
		putNumeric(i, w)
	case UnlimitedSource:
		putNumeric(i, w)
	case LimitedSource:
		putNumeric(i, w)
	case User:
		id := i.ID()
		b := make([]byte, 2+len(id))
		b[0] = byte(i.Type())
		b[1] = byte(len(id))
		copy(b[2:], id)
		w.Write(b)
	default:
		panic("serialiseItem: unhandled item type")
	}
}

func putNumeric(i NumericItem, w *bytes.Buffer) {
	b := make([]byte, 5)
	b[0] = byte(i.Type())
	binary.BigEndian.PutUint32(b[1:], i.ID())
	w.Write(b)
}

func putUint64(w *bytes.Buffer, v uint64) {
	b := make([]byte, 8)
	binary.BigEndian.PutUint64(b, v)
	w.Write(b)
}

func testServer(t *testing.T) (*httptest.Server, *Economy) {
	t.Helper()

	name := os.TempDir() + "/economy_main_test.db"
	os.Remove(name)

	l, err := NewLedger(name)
	if err != nil {
		t.Fatalf("create ledger: %v", err)
	}
	t.Cleanup(func() {
		l.Close()
		os.Remove(name)
	})

	e := NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)
	return httptest.NewServer(loggingHandler(registerRoutesMux(l, e))), e
}

func registerRoutesMux(l *Ledger, e *Economy) *http.ServeMux {
	mux := http.NewServeMux()
	registerRoutes(mux, &EconomyServer{e})
	return mux
}

func post(t *testing.T, srv *httptest.Server, route string, body *bytes.Buffer) *http.Response {
	t.Helper()
	res, err := srv.Client().Post(srv.URL+"/"+route, "application/octet-stream", body)
	if err != nil {
		t.Fatalf("POST %s: %v", route, err)
	}
	return res
}

// Every route the TS client can call has to actually be registered, or it 404s at runtime.
// buyUnlimitedAsset and buyLimitedAsset shipped unregistered with fully written handlers.
func TestAllRoutesRegistered(t *testing.T) {
	srv, _ := testServer(t)
	defer srv.Close()

	// keep in step with the Route union in client/api.ts
	expected := []string{
		"ownsOne", "ownsMany", "ownersOne", "ownersMany",
		"countOwnersOne", "countOwnersMany", "inventory", "balance",
		"prices", "stipend", "createLimitedSource", "createUnlimitedSource",
		"createPlace", "createGroup", "buyUnlimitedAsset", "buyLimitedAsset",
		"history", "historyOwner",
	}

	for _, route := range expected {
		// an empty body decodes to nothing, which is enough to tell 404 apart from a handler running
		res, err := srv.Client().Post(srv.URL+"/"+route, "application/octet-stream", bytes.NewBuffer(nil))
		if err != nil {
			t.Fatalf("POST %s: %v", route, err)
		}
		res.Body.Close()

		if res.StatusCode == http.StatusNotFound {
			t.Errorf("route %s is not registered", route)
		}
	}

	if len(routes) != len(expected) {
		t.Errorf("server has %d routes, client expects %d", len(routes), len(expected))
	}
}

// an end-to-end unlimited purchase over HTTP, which is what the catalog buy action does
func TestBuyUnlimitedAssetOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	buyer := User{Id: "buyer"}

	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency creator: %v", err)
	}
	if _, err := e.MintCurrency(buyer, 200); err != nil {
		t.Fatalf("MintCurrency buyer: %v", err)
	}

	src, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	body := &bytes.Buffer{}
	serialiseItem(buyer, body)
	serialiseItem(src, body)
	putUint64(body, 25)

	res := post(t, srv, "buyUnlimitedAsset", body)
	defer res.Body.Close()

	if res.StatusCode != http.StatusNoContent {
		t.Fatalf("expected 204, got %d", res.StatusCode)
	}

	if !e.OwnsOne(buyer, src.Create()) {
		t.Fatalf("expected buyer to own %v", src.Create())
	}
	if got := e.Balance(buyer); got != 200-25 {
		t.Fatalf("expected buyer balance %d, got %d", 200-25, got)
	}
	// creator paid the 10 UnlimitedSourcePrice up front, then earned the 25 sale price
	if got := e.Balance(creator); got != 200-10+25 {
		t.Fatalf("expected creator balance %d, got %d", 200-10+25, got)
	}
}

// the same for a limited purchase, which exercises the stocking path end to end
func TestBuyLimitedAssetOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	buyer := User{Id: "buyer"}

	if _, err := e.MintCurrency(creator, 400); err != nil {
		t.Fatalf("MintCurrency creator: %v", err)
	}
	if _, err := e.MintCurrency(buyer, 200); err != nil {
		t.Fatalf("MintCurrency buyer: %v", err)
	}

	src, _, err := e.CreateLimitedSource(creator, 5)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	body := &bytes.Buffer{}
	serialiseItem(buyer, body)
	serialiseItem(src, body)
	putUint64(body, 10)
	putUint64(body, 3)

	res := post(t, srv, "buyLimitedAsset", body)
	defer res.Body.Close()

	if res.StatusCode != http.StatusNoContent {
		t.Fatalf("expected 204, got %d", res.StatusCode)
	}

	if got := e.OwnsMany(buyer, src.Create()); got != 3 {
		t.Fatalf("expected buyer to own 3 %v, got %d", src.Create(), got)
	}
	if got := e.Balance(buyer); got != 170 {
		t.Fatalf("expected buyer balance 170, got %d", got)
	}
}

// the loop variable in registerRoutes must not leak between routes, or every route would end up dispatching to whichever handler ran last
func TestRegisterRoutesDispatchesIndependently(t *testing.T) {
	srv, _ := testServer(t)
	defer srv.Close()

	// balance takes a User and writes a decimal; ownsOne takes two items and writes a byte if both routed to the same handler these would disagree
	body := &bytes.Buffer{}
	serialiseItem(User{Id: "someone"}, body)
	putUint64(body, 0) // a stray uint64 so a mis-dispatch shows up as a decode error

	res := post(t, srv, "balance", body)
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		t.Fatalf("expected 200 from balance, got %d", res.StatusCode)
	}

	buf := new(bytes.Buffer)
	buf.ReadFrom(res.Body)
	if buf.Len() == 0 {
		t.Fatalf("expected balance to write a value")
	}
}
