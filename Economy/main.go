// Mercury Economy service
// "imagine a blockchain but without the blocks or the chain" - Heliodex

package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	c "github.com/TwiN/go-color"
	gonanoid "github.com/matoous/go-nanoid/v2"
)

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

func randId() (id string) {
	id, _ = gonanoid.Generate(idchars, 15) // doesn't error at runtime, really
	return
}

type (
	user     string
	currency uint64
	asset    uint64 // uint64 is overkill? idgaf
)

const (
	folderpath = "../data/economy" // kinda jsonl file
	filepath   = folderpath + "/ledger"

	Micro currency = 1
	Milli          = 1e3 * Micro
	Unit           = 1e6 * Micro // standard unit
	Kilo           = 1e3 * Unit
	Mega           = 1e6 * Unit
	Giga           = 1e9 * Unit
	Tera           = 1e12 * Unit // uint64 means ~18 tera is the economy limit (we could use math/big but that would unleash horror)

	// Target Currency per User, the economy size will try to be this * user count (len(e.balances))
	// By "user", I mean every user who has ever transacted with the economy
	// The stipend and fee should change if the CCU is more than 10% off from this
	TCU         = float64(100 * Unit)
	baseStipend = float64(10 * Unit)
	baseFee     = 0.1
	stipendTime = 12 * 60 * 60 * 1000
)

var currentFilepath = filepath

func toReadable(c currency) string {
	return fmt.Sprintf("%d.%06d unit", c/Unit, c%Unit)
}

// For now, transaction outputs are overkill
// Since fees are stored as a separate value and are burned, I can't see a reason for them to exist for now
// UTXOs lmao
type SentTx struct {
	To, From   user
	Amount     currency
	Link, Note string // Transaction links might be a bit of an ass backwards concept for now but ion care
	Returns    []asset
}
type Tx struct {
	SentTx
	Fee  currency // we ?could? store the fee as a portion of the amount instead, unclear atm if it's worth it
	Time uint64
	Id   string
}

type SentMint struct {
	To     user
	Amount currency
	Note   string
}
type Mint struct {
	SentMint
	Time uint64
	Id   string
}

type SentBurn struct {
	From       user
	Amount     currency
	Note, Link string
	Returns    []asset
}
type Burn struct {
	SentBurn
	Time uint64
	Id   string
}

type Economy struct {
	data         io.ReadWriter
	balances     map[user]currency
	prevStipends map[user]uint64
}

func (e *Economy) validateTx(sent SentTx, fee currency) error {
	if sent.Amount == 0 {
		return errors.New("transaction must have an amount")
	}
	if sent.From == "" {
		return errors.New("transaction must have a sender")
	}
	if sent.To == "" {
		return errors.New("transaction must have a recipient")
	}
	if sent.From == sent.To {
		return fmt.Errorf("circular transaction: %s -> %s", sent.From, sent.To)
	}
	if sent.Note == "" {
		return errors.New("transaction must have a note")
	}
	if sent.Link == "" {
		return errors.New("transaction must have a link")
	}
	if total := sent.Amount + fee; total > e.balances[sent.From] {
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", toReadable(e.balances[sent.From]), toReadable(total))
	}
	return nil
}

func (Economy) validateMint(sent SentMint) error {
	if sent.Amount == 0 {
		return errors.New("mint must have an amount")
	}
	if sent.To == "" {
		return errors.New("mint must have a recipient")
	}
	if sent.Note == "" {
		return errors.New("mint must have a note")
	}
	return nil
}

func (e *Economy) validateBurn(sent SentBurn) error {
	if sent.Amount == 0 {
		return errors.New("burn must have an amount")
	}
	if sent.From == "" {
		return errors.New("burn must have a sender")
	}
	if sent.Amount > e.balances[sent.From] {
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", toReadable(e.balances[sent.From]), toReadable(sent.Amount))
	}
	if sent.Note == "" {
		return errors.New("burn must have a note")
	}
	if sent.Link == "" {
		return errors.New("burn must have a link")
	}
	return nil
}

func (e *Economy) economySize() (size currency) {
	for _, v := range e.balances {
		size += v
	}
	return
}

// Current Currency per User
func (e *Economy) CCU() float64 {
	users := len(e.balances)
	if users == 0 {
		return 0 // Division by zero causes overflowz
	}
	return float64(e.economySize()) / float64(users)
}

// If the economy is too small, stipends will increase
// If the economy is near or above desired size, stipends will be baseStipend
func (e *Economy) currentStipend() currency {
	return currency(max((TCU-e.CCU()+baseStipend)/2, baseStipend))
}

// If the economy is too large, fees will increase
// If the economy is near or below desired size, fees will be baseFee
func (e *Economy) currentFee() float64 {
	return max((1+(e.CCU()*0.9-TCU)/TCU*4)*baseFee, baseFee)
}

func (e *Economy) handleTxTypes(lines []string) (err error) {
	for _, line := range lines {
		// split line at first space, with the transaction type being the first part
		parts := strings.SplitN(line, " ", 2)
		switch data := []byte(parts[1]); parts[0] {
		case "Transaction":
			var tx Tx
			if err = json.Unmarshal(data, &tx); err != nil {
				return fmt.Errorf("failed to decode transaction from ledger: %w", err)
			}

			if tx.Amount+tx.Fee > e.balances[tx.From] {
				fmt.Println("Invalid transaction in ledger")
				os.Exit(1)
			}

			e.loadTx(tx)
		case "Mint":
			var mint Mint
			if err = json.Unmarshal(data, &mint); err != nil {
				return fmt.Errorf("failed to decode mint from ledger: %w", err)
			}

			e.loadMint(mint)
		case "Burn":
			var burn Burn
			if err = json.Unmarshal(data, &burn); err != nil {
				return fmt.Errorf("failed to decode burn from ledger: %w", err)
			}

			if burn.Amount > e.balances[burn.From] {
				fmt.Println("Invalid burn in ledger")
				os.Exit(1)
			}

			e.loadBurn(burn)
		default:
			fmt.Println(c.InRed("Unknown transaction type in ledger"))
		}
	}
	return
}

func (e *Economy) loadTx(tx Tx) {
	e.balances[tx.From] -= tx.Amount + tx.Fee
	e.balances[tx.To] += tx.Amount
}

func (e *Economy) loadMint(mint Mint) {
	e.balances[mint.To] += mint.Amount
	if mint.Note == "Stipend" {
		e.prevStipends[mint.To] = mint.Time
	}
}

func (e *Economy) loadBurn(burn Burn) {
	e.balances[burn.From] -= burn.Amount
}

func (e *Economy) loadData() (err error) {
	bytes, err := io.ReadAll(e.data)
	if err != nil {
		return
	}

	lines := strings.Split(string(bytes), "\n")
	return e.handleTxTypes(lines[:len(lines)-1] /* remove last empty line */)
}

func NewEconomy(data io.ReadWriter) (e *Economy, err error) {
	e = &Economy{
		data:         data,
		balances:     make(map[user]currency),
		prevStipends: make(map[user]uint64),
	}

	if err = e.loadData(); err != nil {
		return nil, fmt.Errorf("failed to load economy data: %w", err)
	}

	return e, nil
}

func (e *Economy) appendEvent(event any, eventType string) error {
	if _, err := e.data.Write([]byte(eventType + " ")); err != nil { // Lol good luck error handling this
		fmt.Println(err.Error())
	}
	return json.NewEncoder(e.data).Encode(event)
}

func (e *Economy) transact(sent SentTx) (err error) {
	fee := currency(float64(sent.Amount) * e.currentFee())
	if err = e.validateTx(sent, fee); err != nil {
		return
	} else if err = e.appendEvent(
		Tx{sent, fee, uint64(time.Now().UnixMilli()), randId()},
		"Transaction",
	); err != nil {
		return
	}

	// successfully written
	e.balances[sent.From] -= sent.Amount + fee
	e.balances[sent.To] += sent.Amount
	return
}

func (e *Economy) mint(sent SentMint, time uint64) (err error) {
	if err = e.validateMint(sent); err != nil {
		return
	}
	if err = e.appendEvent(Mint{sent, time, randId()}, "Mint"); err != nil {
		return
	}

	// successfully written
	e.balances[sent.To] += sent.Amount
	return
}

func (e *Economy) burn(sent SentBurn) (err error) {
	if err = e.validateBurn(sent); err != nil {
		return
	}
	if err = e.appendEvent(Burn{sent, uint64(time.Now().UnixMilli()), randId()}, "Burn"); err != nil {
		return
	}

	// successfully written
	e.balances[sent.From] -= sent.Amount
	return
}

func (e *Economy) stipend(to user) (err error) {
	time := uint64(time.Now().UnixMilli())
	if err = e.mint(SentMint{to, e.currentStipend(), "Stipend"}, time); err != nil {
		return
	}

	e.prevStipends[to] = time
	return
}

func (e *Economy) readTransactions() (txs []string, err error) {
	bytes, err := io.ReadAll(e.data)
	if err != nil {
		fmt.Println(c.InRed("Failed to read transactions from ledger:"), err)
		return
	}
	return strings.Split(string(bytes), "\n"), nil
}

func (e *Economy) readReversed() (lines []string, ll int, err error) {
	if lines, err = e.readTransactions(); err != nil {
		return
	}

	l := len(lines)
	for i := range l / 2 {
		j := l - i - 1
		lines[i], lines[j] = lines[j], lines[i]
	}

	return lines[1:], l - 1, nil
}

func (e *Economy) enumerateTransactions(validate func(tx map[string]any) bool) (transactions []map[string]any, err error) {
	lines, linesLen, err := e.readReversed()
	if err != nil {
		return
	}

	for _, line := range lines[:min(100, linesLen)] { // Get the last 100 transactions
		parts := strings.SplitN(line, " ", 2)

		var tx any
		if err = json.Unmarshal([]byte(parts[1]), &tx); err != nil {
			return
		}

		casted := tx.(map[string]any)
		if !validate(casted) {
			continue
		}
		casted["Type"] = parts[0]
		transactions = append(transactions, casted)
	}

	return
}

type EconomyServer struct {
	*Economy
}

func (e *EconomyServer) currentFeeRoute(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, e.currentFee())
}

func (e *EconomyServer) currentStipendRoute(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, e.currentStipend())
}

func (e *EconomyServer) balanceRoute(w http.ResponseWriter, r *http.Request) {
	var u user

	if _, err := fmt.Sscanf(r.PathValue("id"), "%s", &u); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Fprint(w, e.balances[u])
}

func (e *EconomyServer) adminTransactionsRoute(w http.ResponseWriter, r *http.Request) {
	transactions, err := e.enumerateTransactions(func(tx map[string]any) bool {
		return true
	})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if err := json.NewEncoder(w).Encode(transactions); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (e *EconomyServer) transactionsRoute(w http.ResponseWriter, r *http.Request) {
	id := user(r.PathValue("id"))

	transactions, err := e.enumerateTransactions(func(tx map[string]any) bool {
		return tx["From"] != nil && user(tx["From"].(string)) == id || tx["To"] != nil && user(tx["To"].(string)) == id
	})
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
	if err := e.transact(stx); err != nil {
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
	if err := e.mint(sm, uint64(time.Now().UnixMilli())); err != nil {
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
	if err := e.burn(sb); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println(c.InGreen(fmt.Sprintf("Burn successful         %s -[%s]->", sb.From, toReadable(sb.Amount))))
}

func (e *EconomyServer) stipendRoute(w http.ResponseWriter, r *http.Request) {
	var to user

	if _, err := fmt.Sscanf(r.PathValue("id"), "%s", &to); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if e.prevStipends[to]+stipendTime > uint64(time.Now().UnixMilli()) {
		http.Error(w, "Next stipend not available yet", http.StatusBadRequest)
		return
	}
	if err := e.stipend(to); err != nil {
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

	fmt.Println("User count    ", len(e.balances))
	fmt.Println("Economy size  ", toReadable(e.economySize()))
	fmt.Println("CCU           ", toReadable(currency(e.CCU())))
	fmt.Println("TCU           ", toReadable(currency(TCU)))
	fmt.Println("Fee percentage", int(e.currentFee()*100))
	fmt.Println("Stipend size  ", toReadable(e.currentStipend()))

	es := EconomyServer{Economy: e}

	http.HandleFunc("GET /currentFee", es.currentFeeRoute)
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
