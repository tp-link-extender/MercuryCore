package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"time"

	c "github.com/TwiN/go-color"

	. "Economy/ledger"
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

func getItem[T Item](w http.ResponseWriter, r *http.Request) (T, bool) {
	oi, err := DeserialiseItem(r.Body)
	if err != nil {
		var t T
		http.Error(w, fmt.Sprintf("decode %T: %v", t, err), http.StatusBadRequest)
		return t, false
	}

	o, ok := oi.(T)
	if !ok {
		var t T
		http.Error(w, fmt.Sprintf("item is not %T: %T", t, oi), http.StatusBadRequest)
		return t, false
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

	// again wdc about the tid because we'll probably be redirecting and the src is what we actually want
	src, _, err := e.CreateLimitedSource(u)
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
	statusCode int
}

func (w *CustomResponseWriter) WriteHeader(code int) {
	w.statusCode = code
	w.ResponseWriter.WriteHeader(code)
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
		// newr := r.Clone(r.Context())
		// next.ServeHTTP(w, newr)
		// // print response code
		// code := http.StatusOK

		crw := &CustomResponseWriter{w, http.StatusOK}
		next.ServeHTTP(crw, r)
		cs := crw.statusCode

		code := colourCode(cs)

		fmt.Printf("%s %s %s\n", c.InGray(t), code, c.InBlue(r.URL.Path))
	})
}

func main() {
	l, err := NewLedger("mydb.db")
	if err != nil {
		panic(err)
	}
	defer l.Close()

	fmt.Println("Database opened successfully")
	fmt.Println()

	e := NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)

	if history, err := e.TransferHistory(10); err == nil {
		fmt.Println("Recent transfer history:")
		for _, t := range history {
			fmt.Printf("- %s\n", t.Transfer)
		}
		fmt.Println()
	} else {
		fmt.Printf("Error fetching transfer history: %v\n", err)
	}

	es := EconomyServer{e}

	http.HandleFunc("POST /ownsOne", es.ownsOneRoute)
	http.HandleFunc("POST /ownsMany", es.ownsManyRoute)
	http.HandleFunc("POST /ownersOne", es.ownersOneRoute)
	http.HandleFunc("POST /ownersMany", es.ownersManyRoute)
	http.HandleFunc("POST /inventory", es.inventoryRoute)
	http.HandleFunc("POST /balance", es.balanceRoute)
	http.HandleFunc("POST /stipend", es.stipendRoute)
	http.HandleFunc("POST /createLimitedSource", es.createLimitedSourceRoute)
	http.HandleFunc("POST /createUnlimitedSource", es.createUnlimitedSourceRoute)
	http.HandleFunc("POST /createPlace", es.createPlaceRoute)
	http.HandleFunc("POST /createGroup", es.createGroupRoute)
	http.HandleFunc("POST /history", es.historyRoute)
	http.HandleFunc("POST /historyOwner", es.historyOwnerRoute)

	fmt.Println(c.InGreen("~ Economy service is up on port 2009 ~")) // 03/Jan/2009 Chancellor on brink of second bailout for banks
	if err := http.ListenAndServe(":2009", loggingHandler(http.DefaultServeMux)); err != nil {
		fmt.Println(c.InRed("Failed to start server: " + err.Error()))
		os.Exit(1)
	}
}
