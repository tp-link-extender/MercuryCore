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
	ownerItem, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode owner: %v", err.Error()), http.StatusBadRequest)
		return
	}

	owner, ok := ownerItem.(Owner)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not Owner: %T", ownerItem), http.StatusBadRequest)
	}

	canOwnOneItem, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	item, ok := canOwnOneItem.(CanOwnOne)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnOne: %T", canOwnOneItem), http.StatusBadRequest)
	}

	fmt.Fprintf(w, "%t", e.OwnsOne(owner, item))
}

func (e *EconomyServer) ownsManyRoute(w http.ResponseWriter, r *http.Request) {
	ownerItem, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode owner: %v", err.Error()), http.StatusBadRequest)
		return
	}

	owner, ok := ownerItem.(Owner)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not Owner: %T", ownerItem), http.StatusBadRequest)
	}

	canOwnManyItem, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	item, ok := canOwnManyItem.(CanOwnMany)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnMany: %T", canOwnManyItem), http.StatusBadRequest)
	}

	fmt.Fprintf(w, "%d", e.OwnsMany(owner, item))
}

func (e *EconomyServer) ownersOneRoute(w http.ResponseWriter, r *http.Request) {
	canOwnOneItem, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	item, ok := canOwnOneItem.(CanOwnOne)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnOne: %T", canOwnOneItem), http.StatusBadRequest)
	}

	if err := e.OwnersOne(item).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise OwnersOne: %v", err.Error()), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) ownersManyRoute(w http.ResponseWriter, r *http.Request) {
	canOwnManyItem, err := DeserialiseItem(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("decode item: %v", err.Error()), http.StatusBadRequest)
		return
	}

	item, ok := canOwnManyItem.(CanOwnMany)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnMany: %T", canOwnManyItem), http.StatusBadRequest)
	}

	if err := e.OwnersMany(item).Serialise(w); err != nil {
		http.Error(w, fmt.Sprintf("serialise OwnersMany: %v", err.Error()), http.StatusInternalServerError)
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

	e := NewEconomy(l, 10, 10, 100, 10, 10, time.Hour*12)

	es := EconomyServer{e}

	http.HandleFunc("POST /ownsOne", es.ownsOneRoute)

	fmt.Println(c.InGreen("~ Economy service is up on port 2009 ~")) // 03/Jan/2009 Chancellor on brink of second bailout for banks
	if err := http.ListenAndServe(":2009", nil); err != nil {
		fmt.Println(c.InRed("Failed to start server: " + err.Error()))
		os.Exit(1)
	}
}
