package ledger

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"slices"
	"strings"
	"time"

	gonanoid "github.com/matoous/go-nanoid/v2"
)

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

func RandId() (id string) {
	id, _ = gonanoid.Generate(idchars, 15) // doesn't error at runtime, really
	return
}

type (
	User     string
	Currency uint64
	Asset    uint64 // uint64 is overkill? idgaf
)

func (c Currency) Readable() string {
	return fmt.Sprintf("%d.%06d unit", c/Unit, c%Unit)
}

const (
	Micro Currency = 1
	Milli          = 1e3 * Micro
	Unit           = 1e6 * Micro // standard unit
	Kilo           = 1e3 * Unit
	Mega           = 1e6 * Unit
	Giga           = 1e9 * Unit
	Tera           = 1e12 * Unit // uint64 means ~18 tera is the economy limit (we could use math/big but that would unleash horror)

	// Target Currency per User, the economy size will try to be this * user count (len(e.balances))
	// By "user", I mean every user who has ever transacted with the economy
	// The stipend and fee should change if the CCU is more than 10% off from this
	// TCU         = float64(100 * Unit)
	Stipend = 10 * Unit
	// baseFee     = 0.1
)

// For now, transaction outputs are overkill
// Since fees are stored as a separate value and are burned, I can't see a reason for them to exist for now
// UTXOs lmao
type SentTx struct {
	To, From   User
	Amount     Currency
	Link, Note string // Transaction links might be a bit of an ass backwards concept for now but ion care
	Returns    []Asset
}
type Tx struct {
	SentTx
	// Fee  Currency
	Time uint64
	Id   string
}

type SentMint struct {
	To     User
	Amount Currency
	Note   string
}
type Mint struct {
	SentMint
	Time uint64
	Id   string
}

type SentBurn struct {
	From       User
	Amount     Currency
	Note, Link string
	Returns    []Asset
}
type Burn struct {
	SentBurn
	Time uint64
	Id   string
}

type Economy struct {
	data         io.ReadWriter
	balances     map[User]Currency
	prevStipends map[User]uint64
}

func (e *Economy) GetBalance(u User) Currency {
	return e.balances[u]
}

func (e *Economy) GetPrevStipend(u User) uint64 {
	return e.prevStipends[u]
}

func (e *Economy) GetUserCount() int {
	return len(e.balances)
}

func (e *Economy) GetEconomySize() (size Currency) {
	for _, v := range e.balances {
		size += v
	}
	return
}

// Current Currency per User
func (e *Economy) CCU() Currency {
	users := len(e.balances)
	if users == 0 {
		return 0 // Division by zero causes overflowz
	}
	return e.GetEconomySize() / Currency(users)
}

func (e *Economy) validateTx(sent SentTx) error {
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
	if total := sent.Amount; total > e.balances[sent.From] {
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", e.balances[sent.From].Readable(), total.Readable())
	}
	return nil
}

func (*Economy) validateMint(sent SentMint) error {
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
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", e.balances[sent.From].Readable(), sent.Amount.Readable())
	}
	if sent.Note == "" {
		return errors.New("burn must have a note")
	}
	if sent.Link == "" {
		return errors.New("burn must have a link")
	}
	return nil
}

// // If the economy is too small, stipends will increase
// // If the economy is near or above desired size, stipends will be baseStipend
// func (e *Economy) GetCurrentStipend() Currency {
// 	return Currency(max((TCU-e.CCU()+baseStipend)/2, baseStipend))
// }

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

			if tx.Amount > e.balances[tx.From] {
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
			return fmt.Errorf("unknown transaction type in ledger: %s", parts[0])
		}
	}
	return
}

func (e *Economy) loadTx(tx Tx) {
	e.balances[tx.From] -= tx.Amount
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
		balances:     make(map[User]Currency),
		prevStipends: make(map[User]uint64),
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

func (e *Economy) Transact(sent SentTx) (err error) {
	if err = e.validateTx(sent); err != nil {
		return
	}

	t := uint64(time.Now().UnixMilli())
	if err = e.appendEvent(Tx{sent, t, RandId()}, "Transaction"); err != nil {
		return
	}

	// successfully written
	e.balances[sent.From] -= sent.Amount
	e.balances[sent.To] += sent.Amount
	return
}

func (e *Economy) Mint(sent SentMint) (t uint64, err error) {
	if err = e.validateMint(sent); err != nil {
		return
	}

	t = uint64(time.Now().UnixMilli())
	if err = e.appendEvent(Mint{sent, t, RandId()}, "Mint"); err != nil {
		return
	}

	// successfully written
	e.balances[sent.To] += sent.Amount
	return
}

func (e *Economy) Burn(sent SentBurn) (err error) {
	if err = e.validateBurn(sent); err != nil {
		return
	}

	t := uint64(time.Now().UnixMilli())
	if err = e.appendEvent(Burn{sent, t, RandId()}, "Burn"); err != nil {
		return
	}

	// successfully written
	e.balances[sent.From] -= sent.Amount
	return
}

func (e *Economy) Stipend(to User) (err error) {
	time, err := e.Mint(SentMint{to, Currency(Stipend), "Stipend"})
	if err != nil {
		return
	}

	e.prevStipends[to] = time
	return
}

func (e *Economy) readTransactions() ([]string, error) {
	bytes, err := io.ReadAll(e.data)
	if err != nil {
		return nil, fmt.Errorf("failed to read transactions from ledger: %w", err)
	}

	lines := strings.Split(string(bytes), "\n")
	return lines[:len(lines)-1], nil
}

func (e *Economy) readReversed() (lines []string, err error) {
	if lines, err = e.readTransactions(); err != nil {
		return
	}

	// l := len(lines)
	// for i := range l / 2 {
	// 	j := l - i - 1
	// 	lines[i], lines[j] = lines[j], lines[i]
	// }

	// return lines[1:], l - 1, nil
	slices.Reverse(lines)
	return
}

func (e *Economy) LastNTransactions(validate func(tx map[string]any) bool, n int) (transactions []map[string]any, err error) {
	lines, err := e.readReversed()
	if err != nil {
		return
	}
	ll := len(lines)

	for _, line := range lines[:min(n, ll)] { // Get the last 100 transactions
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

func (e *Economy) Stats() {
	fmt.Println("User count    ", e.GetUserCount())
	fmt.Println("Economy size  ", e.GetEconomySize().Readable())
	fmt.Println("CCU           ", e.CCU().Readable())
}
