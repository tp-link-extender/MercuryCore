package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"sync"
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
	case PackageSource:
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

	e := NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)
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
		"createPackageSource", "buyPackage", "packageContents", "packageItems",
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

// a zero price means no currency entry, not a zero-quantity one, which the transfer validator rejects
func TestBuyFreeAssetOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	buyer := User{Id: "buyer"}

	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency creator: %v", err)
	}

	src, _, err := e.CreateUnlimitedSource(creator)
	if err != nil {
		t.Fatalf("CreateUnlimitedSource: %v", err)
	}

	before := e.Balance(creator)

	body := &bytes.Buffer{}
	serialiseItem(buyer, body)
	serialiseItem(src, body)
	putUint64(body, 0)

	res := post(t, srv, "buyUnlimitedAsset", body)
	defer res.Body.Close()

	if res.StatusCode != http.StatusNoContent {
		buf := new(bytes.Buffer)
		buf.ReadFrom(res.Body)
		t.Fatalf("expected 204, got %d: %s", res.StatusCode, buf.String())
	}

	if !e.OwnsOne(buyer, src.Create()) {
		t.Fatalf("expected buyer to own %v", src.Create())
	}
	if got := e.Balance(buyer); got != 0 {
		t.Fatalf("expected the buyer to pay nothing, got balance %d", got)
	}
	if got := e.Balance(creator); got != before {
		t.Fatalf("expected the creator to receive nothing, balance went %d -> %d", before, got)
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

// Concurrent HTTP purchases must be serialised, or they can all validate against the same stock and oversell.
func TestConcurrentBuyLimitedAssetOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	if _, err := e.MintCurrency(creator, 400); err != nil {
		t.Fatalf("MintCurrency creator: %v", err)
	}

	const stock = 5
	src, _, err := e.CreateLimitedSource(creator, stock)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	const buyers = 20
	bodies := make([]*bytes.Buffer, buyers)
	for i := range bodies {
		buyer := User{Id: fmt.Sprintf("buyer%d", i)}
		if _, err := e.MintCurrency(buyer, 10); err != nil {
			t.Fatalf("MintCurrency %v: %v", buyer, err)
		}

		body := &bytes.Buffer{}
		serialiseItem(buyer, body)
		serialiseItem(src, body)
		putUint64(body, 10)
		putUint64(body, 1)
		bodies[i] = body
	}

	start := make(chan struct{})
	statuses := make(chan int, buyers)
	var wg sync.WaitGroup
	for _, body := range bodies {
		wg.Add(1)
		go func(body *bytes.Buffer) {
			defer wg.Done()
			<-start
			res, err := srv.Client().Post(srv.URL+"/buyLimitedAsset", "application/octet-stream", body)
			if err != nil {
				statuses <- 0
				return
			}
			res.Body.Close()
			statuses <- res.StatusCode
		}(body)
	}

	close(start)
	wg.Wait()
	close(statuses)

	ok, rejected := 0, 0
	for status := range statuses {
		switch status {
		case http.StatusNoContent:
			ok++
		case http.StatusBadRequest:
			rejected++
		default:
			t.Fatalf("unexpected status %d", status)
		}
	}

	if ok != stock || rejected != buyers-stock {
		t.Fatalf("expected %d purchases and %d rejections, got %d and %d", stock, buyers-stock, ok, rejected)
	}

	sold := Quantity(0)
	for _, qty := range e.OwnersMany(src.Create()) {
		sold += qty
	}
	if sold != stock {
		t.Fatalf("expected %d limited assets sold, got %d", stock, sold)
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

// the whole package flow over HTTP: create a package source, then sell it
func TestPackageOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	buyer := User{Id: "buyer"}
	for _, u := range []User{creator, buyer} {
		if _, err := e.MintCurrency(u, 200); err != nil {
			t.Fatalf("MintCurrency %v: %v", u, err)
		}
	}

	// two component sources
	var comps []UnlimitedSource
	for range 2 {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		comps = append(comps, c)
	}

	// create the package source over HTTP
	body := &bytes.Buffer{}
	serialiseItem(creator, body)
	putUint32(body, uint32(len(comps)))
	for _, c := range comps {
		serialiseItem(c, body)
	}

	res := post(t, srv, "createPackageSource", body)
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		t.Fatalf("expected 200 from createPackageSource, got %d", res.StatusCode)
	}

	buf := new(bytes.Buffer)
	buf.ReadFrom(res.Body)
	srcBytes := buf.Bytes()
	if len(srcBytes) != 5 {
		t.Fatalf("expected a 5 byte source id, got %d bytes", len(srcBytes))
	}
	if srcBytes[0] != byte(10) {
		t.Fatalf("expected type byte %d for PackageSource, got %d", 10, srcBytes[0])
	}
	pkgSrc := PackageSource{Id: binary.BigEndian.Uint32(srcBytes[1:])}

	// buy it over HTTP
	body = &bytes.Buffer{}
	serialiseItem(buyer, body)
	serialiseItem(pkgSrc, body)
	putUint64(body, 35)

	res2 := post(t, srv, "buyPackage", body)
	defer res2.Body.Close()

	if res2.StatusCode != http.StatusNoContent {
		t.Fatalf("expected 204 from buyPackage, got %d", res2.StatusCode)
	}

	if !e.OwnsOne(buyer, pkgSrc.Create()) {
		t.Fatalf("expected buyer to own the package")
	}
	for _, c := range comps {
		if !e.OwnsOne(buyer, c.Create()) {
			t.Fatalf("expected buyer to own component %v", c.Create())
		}
	}
	if got := e.Balance(buyer); got != 200-35 {
		t.Fatalf("expected buyer balance %d, got %d", 200-35, got)
	}
}

// createdSrc decodes the 5 byte response a create*Source route returns
func createdSrc(t *testing.T, body io.Reader) PackageSource {
	t.Helper()

	buf := new(bytes.Buffer)
	buf.ReadFrom(body)
	if buf.Len() != 5 {
		t.Fatalf("expected a 5 byte source id, got %d bytes", buf.Len())
	}
	return PackageSource{Id: binary.BigEndian.Uint32(buf.Bytes()[1:5])}
}

func putUint32(w *bytes.Buffer, v uint32) {
	b := make([]byte, 4)
	binary.BigEndian.PutUint32(b, v)
	w.Write(b)
}

// packageContents and packageItems over HTTP, so the Site can read bundle contents from the ledger
func TestPackageContentsOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency: %v", err)
	}

	comps := make([]UnlimitedSource, 2)
	sources := make([]PackageComponent, 2)
	for i := range comps {
		c, _, err := e.CreateUnlimitedSource(creator)
		if err != nil {
			t.Fatalf("CreateUnlimitedSource: %v", err)
		}
		comps[i] = c
		sources[i] = c
	}

	body := &bytes.Buffer{}
	serialiseItem(creator, body)
	putUint32(body, uint32(len(sources)))
	for _, c := range comps {
		serialiseItem(c, body)
	}

	res := post(t, srv, "createPackageSource", body)
	if res.StatusCode != http.StatusOK {
		t.Fatalf("createPackageSource: %d", res.StatusCode)
	}
	pkgSrc := createdSrc(t, res.Body)
	res.Body.Close()

	body = &bytes.Buffer{}
	serialiseItem(pkgSrc, body)
	res = post(t, srv, "packageContents", body)
	if res.StatusCode != http.StatusOK {
		t.Fatalf("packageContents: %d", res.StatusCode)
	}

	buf := new(bytes.Buffer)
	buf.ReadFrom(res.Body)
	contents, err := DeserialiseItems(bytes.NewReader(buf.Bytes()))
	if err != nil {
		t.Fatalf("deserialise contents: %v", err)
	}

	if !contents.One.Has(pkgSrc.Create()) {
		t.Fatalf("expected contents to include the package")
	}
	for _, c := range comps {
		if !contents.One.Has(c.Create()) {
			t.Fatalf("expected contents to include %v", c.Create())
		}
	}

	// the global package item list, which the catalog uses to hide contents
	res = post(t, srv, "packageItems", bytes.NewBuffer(nil))
	if res.StatusCode != http.StatusOK {
		t.Fatalf("packageItems: %d", res.StatusCode)
	}
	buf = new(bytes.Buffer)
	buf.ReadFrom(res.Body)
	items, err := DeserialiseItems(bytes.NewReader(buf.Bytes()))
	if err != nil {
		t.Fatalf("deserialise package items: %v", err)
	}

	for _, c := range comps {
		if !items.One.Has(c.Create()) {
			t.Fatalf("expected %v in the package item list", c.Create())
		}
	}
	if items.One.Has(pkgSrc.Create()) {
		t.Fatalf("expected the package itself not to be in the package item list")
	}
}

// a limited source can't be a package component, and the HTTP response has to say so
func TestCreatePackageSourceRejectsLimitedOverHTTP(t *testing.T) {
	srv, e := testServer(t)
	defer srv.Close()

	creator := User{Id: "creator"}
	if _, err := e.MintCurrency(creator, 200); err != nil {
		t.Fatalf("MintCurrency: %v", err)
	}

	limited, _, err := e.CreateLimitedSource(creator, 5)
	if err != nil {
		t.Fatalf("CreateLimitedSource: %v", err)
	}

	body := &bytes.Buffer{}
	serialiseItem(creator, body)
	putUint32(body, 1)
	serialiseItem(limited, body)

	res := post(t, srv, "createPackageSource", body)
	defer res.Body.Close()

	if res.StatusCode != http.StatusBadRequest {
		t.Fatalf("expected 400 for a limited component, got %d", res.StatusCode)
	}

	buf := new(bytes.Buffer)
	buf.ReadFrom(res.Body)
	if !bytes.Contains(buf.Bytes(), []byte("limited")) {
		t.Fatalf("expected the response to name the problem, got %q", buf.String())
	}
}
