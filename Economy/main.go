package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	c "github.com/TwiN/go-color"

	. "Economy/ledger"
)

type EconomyServer struct {
	*Economy
}

func (e *EconomyServer) ownsOneRoute(w http.ResponseWriter, r *http.Request) {
	oi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode owner: %v", err.Error()), http.StatusBadRequest)
		return
	}

	o, ok := oi.(Owner)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not Owner: %T", oi), http.StatusBadRequest)
	}

	cooi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	coo, ok := cooi.(CanOwnOne)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnOne: %T", cooi), http.StatusBadRequest)
	}

	fmt.Fprintf(w, "%t", e.OwnsOne(o, coo))
}

func (e *EconomyServer) ownsManyRoute(w http.ResponseWriter, r *http.Request) {
	oi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode owner: %v", err.Error()), http.StatusBadRequest)
		return
	}

	o, ok := oi.(Owner)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not Owner: %T", oi), http.StatusBadRequest)
	}

	comi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	item, ok := comi.(CanOwnMany)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnMany: %T", comi), http.StatusBadRequest)
	}

	fmt.Fprintf(w, "%d", e.OwnsMany(o, item))
}

func (e *EconomyServer) ownersOneRoute(w http.ResponseWriter, r *http.Request) {
	cooi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	coo, ok := cooi.(CanOwnOne)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnOne: %T", cooi), http.StatusBadRequest)
	}

	if err := e.OwnersOne(coo).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise OwnersOne: %v", err.Error()), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) ownersManyRoute(w http.ResponseWriter, r *http.Request) {
	comi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	com, ok := comi.(CanOwnMany)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnMany: %T", comi), http.StatusBadRequest)
	}

	if err := e.OwnersMany(com).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise OwnersMany: %v", err.Error()), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) inventoryRoute(w http.ResponseWriter, r *http.Request) {
	oi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode owner: %v", err.Error()), http.StatusBadRequest)
		return
	}

	o, ok := oi.(Owner)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not Owner: %T", oi), http.StatusBadRequest)
	}

	if err := e.Inventory(o).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise inventory: %v", err.Error()), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) balanceRoute(w http.ResponseWriter, r *http.Request) {
	oi, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode owner: %v", err.Error()), http.StatusBadRequest)
		return
	}

	o, ok := oi.(Owner)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not Owner: %T", oi), http.StatusBadRequest)
	}

	fmt.Fprintf(w, "%d", e.Balance(o))
}

// we'll expose MintCurrency some other time

func (e *EconomyServer) stipendRoute(w http.ResponseWriter, r *http.Request) {
	ui, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode user: %v", err.Error()), http.StatusBadRequest)
		return
	}

	u, ok := ui.(User)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not User: %T", ui), http.StatusBadRequest)
	}

	tid, err := e.Stipend(u)
	if err != nil {
		if err == ErrStipendNotReady {
			http.Error(w, ErrStipendNotReady.Error(), http.StatusTooManyRequests) // we're not using 425
		}

		http.Error(w, fmt.Sprintf("stipend error: %v", err.Error()), http.StatusBadRequest)
		return
	}

	fmt.Fprintf(w, "%s", tid.String())
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

	es := EconomyServer{e}

	http.HandleFunc("POST /ownsOne", es.ownsOneRoute)
	http.HandleFunc("POST /ownsMany", es.ownsManyRoute)
	http.HandleFunc("POST /ownersOne", es.ownersOneRoute)
	http.HandleFunc("POST /ownersMany", es.ownersManyRoute)
	http.HandleFunc("POST /inventory", es.inventoryRoute)
	http.HandleFunc("POST /balance", es.balanceRoute)
	http.HandleFunc("POST /stipend", es.stipendRoute)

	fmt.Println(c.InGreen("~ Economy service is up on port 2009 ~")) // 03/Jan/2009 Chancellor on brink of second bailout for banks
	if err := http.ListenAndServe(":2009", nil); err != nil {
		fmt.Println(c.InRed("Failed to start server: " + err.Error()))
		os.Exit(1)
	}
}
