package ledger

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

	if ownerItem == nil {
		http.Error(w, "expected owner, got nil", http.StatusBadRequest)
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

	if canOwnOneItem == nil {
		http.Error(w, "expected item, got nil", http.StatusBadRequest)
		return
	}

	item, ok := canOwnOneItem.(CanOwnOne)
	if !ok {
		http.Error(w, fmt.Sprintf("item is not CanOwnOne: %T", canOwnOneItem), http.StatusBadRequest)
	}

	fmt.Fprintf(w, "%t", e.OwnsOne(owner, item))
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
