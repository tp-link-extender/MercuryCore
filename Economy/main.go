package main

import (
	"bytes"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"reflect"
	"strconv"
	"time"

	c "github.com/TwiN/go-color"

	. "Economy/ledger"
)

const (
	maxRequestBodyBytes = 1 << 20 // 1 MiB
	maxHistoryEntries   = 1000
	maxResponseLogBytes = 64 << 10 // 64 KiB
)

// ahh b2i, my favourite (though this one's with uint8)
func b2i(b bool) uint8 {
	if b {
		return 1
	}
	return 0
}

type EconomyServer struct {
	*Economy
}

// itemTypeName is %T for type parameters: %T on a zero value prints <nil> when T is instantiated with an interface (nil interface = no dynamic type).
func itemTypeName[T any]() string {
	return reflect.TypeFor[T]().String()
}

func getItem[T Item](w http.ResponseWriter, r *http.Request) (t T, ok bool) {
	oi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode %s: %v", itemTypeName[T](), err), http.StatusBadRequest)
		return
	}

	o, ok := oi.(T)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not %s: %T", itemTypeName[T](), oi), http.StatusBadRequest)
		return
	}

	return o, true
}

func (e *EconomyServer) ownsOneRoute(w http.ResponseWriter, r *http.Request) {
	o, ok := getItem[Owner](w, r)
	if !ok {
		return
	}

	coo, ok := getItem[CanOwnOne](w, r)
	if !ok {
		return
	}

	w.Write([]byte{b2i(e.OwnsOne(o, coo))})
}

func (e *EconomyServer) ownsManyRoute(w http.ResponseWriter, r *http.Request) {
	o, ok := getItem[Owner](w, r)
	if !ok {
		return
	}

	com, ok := getItem[CanOwnMany](w, r)
	if !ok {
		return
	}

	fmt.Fprintf(w, "%d", e.OwnsMany(o, com))
}

func (e *EconomyServer) ownersOneRoute(w http.ResponseWriter, r *http.Request) {
	coo, ok := getItem[CanOwnOne](w, r)
	if !ok {
		return
	}

	if err := e.OwnersOne(coo).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise OwnersOne: %v", err.Error()), http.StatusInternalServerError)
		return
	}
}

func (e *EconomyServer) ownersManyRoute(w http.ResponseWriter, r *http.Request) {
	com, ok := getItem[CanOwnMany](w, r)
	if !ok {
		return
	}

	if err := e.OwnersMany(com).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise OwnersMany: %v", err.Error()), http.StatusInternalServerError)
		return
	}
}

func (e *EconomyServer) countOwnersOneRoute(w http.ResponseWriter, r *http.Request) {
	coo, ok := getItem[CanOwnOne](w, r)
	if !ok {
		return
	}

	fmt.Fprintf(w, "%d", e.CountOwnersOne(coo))
}

func (e *EconomyServer) countOwnersManyRoute(w http.ResponseWriter, r *http.Request) {
	com, ok := getItem[CanOwnMany](w, r)
	if !ok {
		return
	}

	fmt.Fprintf(w, "%d", e.CountOwnersMany(com))
}

func (e *EconomyServer) inventoryRoute(w http.ResponseWriter, r *http.Request) {
	o, ok := getItem[Owner](w, r) // oh ok
	if !ok {
		return
	}

	if err := e.Inventory(o).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise inventory: %v", err.Error()), http.StatusInternalServerError)
		return
	}
}

func (e *EconomyServer) balanceRoute(w http.ResponseWriter, r *http.Request) {
	o, ok := getItem[Owner](w, r)
	if !ok {
		return
	}

	fmt.Fprintf(w, "%d", e.Balance(o))
}

// pricesRoute returns the service's configured prices so clients can display exactly what will be charged. Prices are uint64 quantities, so this is returned as 6 consecutive big-endian uint64s in a fixed order.
func (e *EconomyServer) pricesRoute(w http.ResponseWriter, r *http.Request) {
	prices := []Quantity{
		e.PlacePrice,
		e.GroupPrice,
		e.LimitedSourcePrice,
		e.UnlimitedSourcePrice,
		e.PackageSourcePrice,
		e.StipendAmount,
	}

	buf := make([]byte, 8*len(prices))
	for i, p := range prices {
		binary.BigEndian.PutUint64(buf[i*8:], uint64(p))
	}

	w.Write(buf)
}

// we'll expose MintCurrency some other time

func (e *EconomyServer) stipendRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	// wdc about the tid (what would we even do with it in where this API is called from??)
	if _, err := e.Stipend(u); err != nil {
		if err == ErrStipendNotReady {
			http.Error(w, ErrStipendNotReady.Error(), http.StatusTooManyRequests) // we're not using 425
			return
		}

		http.Error(w, fmt.Sprintf("stipend error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (e *EconomyServer) createLimitedSourceRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	qty, err := DeserialiseUint64(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode stock quantity: %v", err.Error()), http.StatusBadRequest)
		return
	}

	// again wdc about the tid because we'll probably be redirecting and the src is what we actually want
	src, _, err := e.CreateLimitedSource(u, Quantity(qty))
	if err != nil {
		http.Error(w, fmt.Sprintf("create limited source error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	SerialiseNumeric(src, w)
}

func (e *EconomyServer) createUnlimitedSourceRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	src, _, err := e.CreateUnlimitedSource(u)
	if err != nil {
		http.Error(w, fmt.Sprintf("create unlimited source error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	SerialiseNumeric(src, w)
}

func (e *EconomyServer) createPlaceRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	p, _, err := e.CreatePlace(u)
	if err != nil {
		http.Error(w, fmt.Sprintf("create place error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	SerialiseNumeric(p, w)
}

func (e *EconomyServer) createGroupRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	g, _, err := e.CreateGroup(u)
	if err != nil {
		http.Error(w, fmt.Sprintf("create group error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	SerialiseString(g, w)
}

func (e *EconomyServer) createPackageSourceRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	count, err := DeserialiseUint32(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode component count: %v", err.Error()), http.StatusBadRequest)
		return
	}
	if count > MaxCollectionEntries {
		http.Error(w, fmt.Sprintf("component count %d exceeds limit %d", count, MaxCollectionEntries), http.StatusBadRequest)
		return
	}

	comps := make([]PackageComponent, 0, count)
	for i := uint32(0); i < count; i++ {
		i, err := DeserialiseItem(r.Body)
		if err != nil {
			http.Error(w, fmt.Sprintf("decode component %d: %v", i, err.Error()), http.StatusBadRequest)
			return
		}

		c, ok := i.(PackageComponent)
		if !ok {
			http.Error(w, fmt.Sprintf("component %d is not a package component: %T", i, i), http.StatusBadRequest)
			return
		}
		comps = append(comps, c)
	}

	src, _, err := e.CreatePackageSource(u, comps)
	if err != nil {
		http.Error(w, fmt.Sprintf("create package source error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	SerialiseNumeric(src, w)
}

func (e *EconomyServer) buyPackageRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	src, ok := getItem[PackageSource](w, r)
	if !ok {
		return
	}

	price, err := DeserialiseUint64(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode price: %v", err.Error()), http.StatusBadRequest)
		return
	}

	if _, _, err := e.BuyPackage(u, src, Quantity(price)); err != nil {
		http.Error(w, fmt.Sprintf("buy package error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// serialiseItemsOne writes an ItemsOne as a full Items payload. ItemsOne.Serialise on its own only emits the One section, which leaves the trailing ItemsMany length off the end and makes the response unparseable.
func serialiseItemsOne(items ItemsOne, w io.Writer) error {
	return Items{One: items}.Serialise(w)
}

func (e *EconomyServer) packageContentsRoute(w http.ResponseWriter, r *http.Request) {
	src, ok := getItem[PackageSource](w, r)
	if !ok {
		return
	}

	if err := serialiseItemsOne(e.PackageContents(src), w); err != nil {
		http.Error(w, fmt.Sprintf("serialise package contents: %v", err.Error()), http.StatusInternalServerError)
		return
	}
}

func (e *EconomyServer) packageItemsRoute(w http.ResponseWriter, r *http.Request) {
	if err := serialiseItemsOne(e.PackageItems(), w); err != nil {
		http.Error(w, fmt.Sprintf("serialise package items: %v", err.Error()), http.StatusInternalServerError)
		return
	}
}

func (e *EconomyServer) buyUnlimitedAssetRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	src, ok := getItem[UnlimitedSource](w, r)
	if !ok {
		return
	}

	price, err := DeserialiseUint64(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode price: %v", err.Error()), http.StatusBadRequest)
		return
	}

	if _, _, err := e.BuyUnlimitedAsset(u, src, Quantity(price)); err != nil {
		http.Error(w, fmt.Sprintf("buy unlimited asset error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	// really I don't think there's a need to return any actual data here
	w.WriteHeader(http.StatusNoContent)
}

func (e *EconomyServer) buyLimitedAssetRoute(w http.ResponseWriter, r *http.Request) {
	u, ok := getItem[User](w, r)
	if !ok {
		return
	}

	src, ok := getItem[LimitedSource](w, r)
	if !ok {
		return
	}

	priceEach, err := DeserialiseUint64(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode priceEach: %v", err.Error()), http.StatusBadRequest)
		return
	}

	qty, err := DeserialiseUint64(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode quantity: %v", err.Error()), http.StatusBadRequest)
		return
	}

	if _, _, err := e.BuyLimitedAsset(u, src, Quantity(priceEach), Quantity(qty)); err != nil {
		http.Error(w, fmt.Sprintf("buy limited asset error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (e *EconomyServer) historyRoute(w http.ResponseWriter, r *http.Request) {
	n, err := DeserialiseUint32(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode number: %v", err.Error()), http.StatusBadRequest)
		return
	}
	if n > maxHistoryEntries {
		http.Error(w, fmt.Sprintf("history limit is %d", maxHistoryEntries), http.StatusBadRequest)
		return
	}

	history, err := e.TransferHistory(n)
	if err != nil {
		http.Error(w, fmt.Sprintf("fetch transfer history: %v", err.Error()), http.StatusInternalServerError)
		return
	}

	for _, t := range history {
		if err := t.Serialise(w); err != nil {
			http.Error(w, fmt.Sprintf("serialise transfer: %v", err.Error()), http.StatusInternalServerError)
			return
		}
	}
}

func (e *EconomyServer) historyOwnerRoute(w http.ResponseWriter, r *http.Request) {
	n, err := DeserialiseUint32(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode number: %v", err.Error()), http.StatusBadRequest)
		return
	}
	if n > maxHistoryEntries {
		http.Error(w, fmt.Sprintf("history limit is %d", maxHistoryEntries), http.StatusBadRequest)
		return
	}

	o, ok := getItem[Owner](w, r)
	if !ok {
		return
	}

	history, err := e.TransferHistoryOwner(n, o)
	if err != nil {
		http.Error(w, fmt.Sprintf("fetch transfer history: %v", err.Error()), http.StatusInternalServerError)
		return
	}

	for _, t := range history {
		if err := t.Serialise(w); err != nil {
			http.Error(w, fmt.Sprintf("serialise transfer: %v", err.Error()), http.StatusInternalServerError)
			return
		}
	}
}

type CustomResponseWriter struct {
	http.ResponseWriter
	log        []byte
	statusCode int
}

func (w *CustomResponseWriter) WriteHeader(code int) {
	w.statusCode = code
	w.ResponseWriter.WriteHeader(code)
}

func (w *CustomResponseWriter) Write(b []byte) (int, error) {
	if remaining := maxResponseLogBytes - len(w.log); remaining > 0 {
		if len(b) < remaining {
			w.log = append(w.log, b...)
		} else {
			w.log = append(w.log, b[:remaining]...)
		}
	}
	return w.ResponseWriter.Write(b)
}

func colourCode(cs int) string {
	scs := strconv.Itoa(cs)

	if cs >= 500 {
		return c.InRed(scs)
	}
	if cs >= 400 {
		return c.InYellow(scs)
	}
	return c.InGreen(scs)
}

func loggingHandler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		t := time.Now().Format("2006-01-02 15:04:05")

		bodyBytes, err := io.ReadAll(http.MaxBytesReader(w, r.Body, maxRequestBodyBytes))
		if err != nil {
			status := http.StatusBadRequest
			var maxErr *http.MaxBytesError
			if errors.As(err, &maxErr) {
				status = http.StatusRequestEntityTooLarge
			}

			crw := &CustomResponseWriter{
				ResponseWriter: w,
				statusCode:     status,
			}
			http.Error(crw, http.StatusText(status), status)

			fmt.Printf("%s %s %s\n", c.InGray(t), colourCode(status), c.InBlue(r.URL.Path))
			fmt.Println(c.InRed(fmt.Sprintf("Failed to read request body: %v", err)))
			fmt.Println(c.InPurple(string(crw.log)))
			return
		}

		// log the body, then let handlers read it from memory
		fmt.Println(c.InWhite(bodyBytes))
		r.Body = io.NopCloser(bytes.NewReader(bodyBytes))

		crw := &CustomResponseWriter{
			ResponseWriter: w,
			statusCode:     http.StatusOK,
		}
		next.ServeHTTP(crw, r)
		cs := crw.statusCode

		code := colourCode(cs)

		fmt.Printf("%s %s %s\n", c.InGray(t), code, c.InBlue(r.URL.Path))
		fmt.Println(c.InPurple(string(crw.log)))
	})
}

// routes are kept in step with the Route union in client/api.ts
var routes = []struct {
	path string
	h    func(*EconomyServer, http.ResponseWriter, *http.Request)
}{
	{"ownsOne", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.ownsOneRoute(w, r) }},
	{"ownsMany", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.ownsManyRoute(w, r) }},
	{"ownersOne", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.ownersOneRoute(w, r) }},
	{"ownersMany", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.ownersManyRoute(w, r) }},
	{"countOwnersOne", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.countOwnersOneRoute(w, r) }},
	{"countOwnersMany", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.countOwnersManyRoute(w, r) }},
	{"inventory", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.inventoryRoute(w, r) }},
	{"balance", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.balanceRoute(w, r) }},
	{"prices", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.pricesRoute(w, r) }},
	{"stipend", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.stipendRoute(w, r) }},
	{"createLimitedSource", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.createLimitedSourceRoute(w, r) }},
	{"createUnlimitedSource", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.createUnlimitedSourceRoute(w, r) }},
	{"createPlace", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.createPlaceRoute(w, r) }},
	{"createGroup", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.createGroupRoute(w, r) }},
	{"buyUnlimitedAsset", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.buyUnlimitedAssetRoute(w, r) }},
	{"buyLimitedAsset", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.buyLimitedAssetRoute(w, r) }},
	{"createPackageSource", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.createPackageSourceRoute(w, r) }},
	{"buyPackage", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.buyPackageRoute(w, r) }},
	{"packageContents", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.packageContentsRoute(w, r) }},
	{"packageItems", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.packageItemsRoute(w, r) }},
	{"history", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.historyRoute(w, r) }},
	{"historyOwner", func(s *EconomyServer, w http.ResponseWriter, r *http.Request) { s.historyOwnerRoute(w, r) }},
}

func registerRoutes(mux *http.ServeMux, es *EconomyServer) {
	for _, r := range routes {
		mux.HandleFunc("POST /"+r.path, func(w http.ResponseWriter, req *http.Request) {
			r.h(es, w, req)
		})
	}
}

func main() {
	l, err := NewLedger("mydb.db")
	if err != nil {
		panic(err)
	}
	defer l.Close()

	fmt.Println("Database opened successfully")
	fmt.Println()

	e := NewEconomy(l, 10, 10, 100, 10, 10, 10, time.Hour*12)

	if history, err := e.TransferHistory(10); err == nil {
		fmt.Println("Recent transfer history:")
		for _, t := range history {
			fmt.Printf("- %s\n", t.Transfer)
		}
		fmt.Println()
	} else {
		fmt.Printf("Error fetching transfer history: %v\n", err)
	}

	registerRoutes(http.DefaultServeMux, &EconomyServer{e})

	fmt.Println(c.InGreen("~ Economy service is up on port 2009 ~")) // 03/Jan/2009 Chancellor on brink of second bailout for banks
	if err := http.ListenAndServe(":2009", loggingHandler(http.DefaultServeMux)); err != nil {
		fmt.Println(c.InRed("Failed to start server: " + err.Error()))
		os.Exit(1)
	}
}
