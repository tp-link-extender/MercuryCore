// Mercury Economy service
// "imagine a blockchain but without the blocks or the chain" - Heliodex

package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"time"

	c "github.com/TwiN/go-color"

	. "Economy/ledger"
)

const (
	folderpath = "../data/economy" // kinda jsonl file
	filepath   = folderpath + "/ledger"

	stipendTime = 12 * 60 * 60 * 1000
)

var currentFilepath = filepath

func toReadable(c Currency) string {
	return fmt.Sprintf("%d.%06d unit", c/Unit, c%Unit)
}

type EconomyServer struct {
	*Economy
}

// func (e *EconomyServer) currentFeeRoute(w http.ResponseWriter, r *http.Request) {
// 	fmt.Fprint(w, e.GetCurrentFee())
// }

func (e *EconomyServer) currentStipendRoute(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, Stipend)
}

func (e *EconomyServer) balanceRoute(w http.ResponseWriter, r *http.Request) {
	var u User

	if _, err := fmt.Sscanf(r.PathValue("id"), "%s", &u); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Fprint(w, e.GetBalance(u))
}

func (e *EconomyServer) adminTransactionsRoute(w http.ResponseWriter, r *http.Request) {
	transactions, err := e.LastNTransactions(func(tx map[string]any) bool {
		return true
	}, 100)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if err := json.NewEncoder(w).Encode(transactions); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) transactionsRoute(w http.ResponseWriter, r *http.Request) {
	id := User(r.PathValue("id"))

	transactions, err := e.LastNTransactions(func(tx map[string]any) bool {
		return tx["From"] != nil && User(tx["From"].(string)) == id || tx["To"] != nil && User(tx["To"].(string)) == id
	}, 100)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if err := json.NewEncoder(w).Encode(transactions); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) transactRoute(w http.ResponseWriter, r *http.Request) {
	var stx SentTx

	if err := json.NewDecoder(r.Body).Decode(&stx); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if err := e.Transact(stx); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println(c.InGreen(fmt.Sprintf("Transaction successful  %s -[%s]-> %s", stx.From, toReadable(stx.Amount), stx.To)))
}

func (e *EconomyServer) mintRoute(w http.ResponseWriter, r *http.Request) {
	var sm SentMint

	if err := json.NewDecoder(r.Body).Decode(&sm); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if err := e.Mint(sm); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println(c.InGreen(fmt.Sprintf("Mint successful         %s <-[%s]-", sm.To, toReadable(sm.Amount))))
}

func (e *EconomyServer) burnRoute(w http.ResponseWriter, r *http.Request) {
	var sb SentBurn

	if err := json.NewDecoder(r.Body).Decode(&sb); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if err := e.Burn(sb); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println(c.InGreen(fmt.Sprintf("Burn successful         %s -[%s]->", sb.From, toReadable(sb.Amount))))
}

func (e *EconomyServer) stipendRoute(w http.ResponseWriter, r *http.Request) {
	var to User

	if _, err := fmt.Sscanf(r.PathValue("id"), "%s", &to); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if e.GetPrevStipend(to)+stipendTime > uint64(time.Now().UnixMilli()) {
		http.Error(w, "Next stipend not available yet", http.StatusBadRequest)
		return
	}
	if err := e.Stipend(to); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println(c.InGreen(fmt.Sprintf("Stipend successful      %s", to)))
}

func createFilepath() (file *os.File, err error) {
	if file, err = os.OpenFile(currentFilepath, os.O_CREATE|os.O_APPEND|os.O_RDWR, 0o644); err != nil {
		if !errors.Is(err, os.ErrNotExist) {
			return nil, fmt.Errorf("failed to open ledger: %w", err)
		}

		fmt.Println(c.InPurple("Economy data folder not found, creating..."))
		if err = os.MkdirAll(folderpath, 0o644); err != nil {
			return nil, fmt.Errorf("failed to create *Economy data folder: %w", err)
		}
		if file, err = os.Create(currentFilepath); err != nil {
			return nil, fmt.Errorf("failed to create ledger: %w", err)
		}
	}
	return
}

func main() {
	fmt.Println(c.InYellow("Loading ledger..."))
	// create the file if it dont exist

	file, err := createFilepath()
	if err != nil {
		fmt.Println(c.InRed("Failed to create or open ledger: " + err.Error()))
		os.Exit(1)
	}
	defer file.Close()

	e, err := NewEconomy(file)
	if err != nil {
		fmt.Println(c.InRed("Failed to create economy: " + err.Error()))
		os.Exit(1)
	}

	e.Stats()

	es := EconomyServer{Economy: e}

	// http.HandleFunc("GET /currentFee", es.currentFeeRoute)
	http.HandleFunc("GET /currentStipend", es.currentStipendRoute)
	http.HandleFunc("GET /balance/{id}", es.balanceRoute)
	http.HandleFunc("GET /transactions", es.adminTransactionsRoute)
	http.HandleFunc("GET /transactions/{id}", es.transactionsRoute)
	http.HandleFunc("POST /transact", es.transactRoute)
	http.HandleFunc("POST /mint", es.mintRoute)
	http.HandleFunc("POST /burn", es.burnRoute)
	http.HandleFunc("POST /stipend/{id}", es.stipendRoute)

	fmt.Println(c.InGreen("~ Economy service is up on port 2009 ~")) // 03/Jan/2009 Chancellor on brink of second bailout for banks
	if err := http.ListenAndServe(":2009", nil); err != nil {
		fmt.Println(c.InRed("Failed to start server: " + err.Error()))
		os.Exit(1)
	}
}
