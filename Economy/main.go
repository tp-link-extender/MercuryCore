// Mercury Economy service

package main

import (
	"encoding/json"
	"fmt"
	"os"
	"slices"
	"strings"
	"time"

	c "github.com/TwiN/go-color"
	gonanoid "github.com/matoous/go-nanoid/v2"
)

const filepath = "../data/ledger" // jsonl file

func randId() string {
	id, _ := gonanoid.Generate("0123456789abcdefghijklmnopqrstuvwxyz", 15)
	return id
}

func Log(txt string) {
	// I HATE GO DATE FORMATTING!!! I HATE GO DATE FORMATTING!!!
	fmt.Println(time.Now().Format("02/01/2006, 15:04:05 "), txt)
}

func Assert(err error, txt string) {
	// so that I don't have to write this every time
	if err != nil {
		Log(c.InRed(txt+": ") + err.Error())
		os.Exit(1)
	}
}

type (
	userNumber uint32
	currency   uint64
)

const (
	Micro currency = 1
	Milli          = 1e3 * Micro
	Unit           = 1e6 * Micro // standard unit

	Kilo = 1e3 * Unit
	Mega = 1e6 * Unit
	Giga = 1e9 * Unit
	Tera = 1e12 * Unit // uint64 means 18 tera is the economy limit
)

func ToReadable(c currency) string {
	return fmt.Sprintf("%d.%06d unit", c/Unit, c%Unit)
}

func PrintRichest() {
	// sort balances
	type kv struct {
		Key   userNumber
		Value currency
	}
	var sorted []kv
	for k, v := range balances {
		sorted = append(sorted, kv{k, v})
	}

	// sort
	slices.SortFunc(sorted, func(a kv, b kv) int {
		return int(b.Value - a.Value)
	})

	// print top 10
	for i, kv := range sorted {
		if i == 10 {
			break
		}
		fmt.Printf("%d  %s\n", kv.Key, ToReadable(kv.Value))
	}
}

type TxOutput struct {
	To     userNumber
	Amount currency
}

type Transaction struct {
	From           userNumber
	Outputs        []TxOutput
	Fee            currency
	Time           uint64
	Link, Note, Id string
}

type Mint struct {
	To       userNumber
	Amount   currency
	Time     uint64
	Note, Id string
}

var balances = map[userNumber]currency{}

func MakeOutput(to userNumber, amount currency) TxOutput {
	return TxOutput{To: to, Amount: amount}
}

func ValidateTx(from userNumber, outputs []TxOutput, fee currency) error {
	if len(outputs) == 0 {
		return fmt.Errorf("transaction must have at least one output")
	}

	var total currency
	outs := map[userNumber]bool{}
	for _, out := range outputs {
		if out.Amount == 0 {
			return fmt.Errorf("output amount must be positive")
		} else if outs[out.To] {
			return fmt.Errorf("duplicate output")
		}
		outs[out.To] = true

		if out.To == from {
			return fmt.Errorf("circular transaction: %d -> %d", from, out.To)
		}
		total += out.Amount
	}

	if fee < currency(float64(total)*0.3) {
		return fmt.Errorf("fee too low, must be at least 30%% of total amount: expected %s, got %s", ToReadable(currency(float64(total)*0.3)), ToReadable(fee))
	} else if total+fee > balances[from] {
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", ToReadable(balances[from]), ToReadable(total+fee))
	}
	return nil
}

func ValidateMint(to userNumber, amount currency) error {
	if amount == 0 {
		return fmt.Errorf("mint amount must be positive")
	}
	return nil
}

func CalcFee(outputs []TxOutput) currency {
	var total currency
	for _, out := range outputs {
		total += out.Amount
	}

	return currency(float64(total) * 0.3)
}

type EventMaker struct {
	file *os.File
}

func (e *EventMaker) Append(tx any, txType string) error {
	_, err := e.file.WriteString(txType + " ")
	if err != nil {
		return err
	}
	err = json.NewEncoder(e.file).Encode(tx)
	if err != nil {
		return err
	}
	return nil
}

func (e *EventMaker) MakeTx(from userNumber, outputs []TxOutput, fee currency, link, note string) error {
	err := ValidateTx(from, outputs, fee)
	if err != nil {
		return err
	}

	tx := Transaction{from, outputs, fee, uint64(time.Now().UnixMilli()), link, note, randId()}

	err = e.Append(tx, "Transaction")
	if err != nil {
		return err
	}

	// successfully written
	for _, out := range outputs {
		balances[tx.From] -= out.Amount
		if out.To != 0 {
			balances[out.To] += out.Amount
		}
	}
	return nil
}

func (e *EventMaker) Mint(to userNumber, amount currency, note string) error {
	err := ValidateMint(to, amount)
	if err != nil {
		return err
	}

	tx := Mint{to, amount, uint64(time.Now().UnixMilli()), note, randId()}

	err = e.Append(tx, "Mint")
	if err != nil {
		return err
	}

	// successfully written
	balances[to] += amount
	return nil
}

func CalculateBalances() {
	// read transactions
	bytes, err := os.ReadFile(filepath)
	Assert(err, "Failed to read ledger")

	lines := strings.Split(string(bytes), "\n")
	lines = lines[:len(lines)-1] // remove last empty line

	var txs []Transaction

	// decode transactions
	for _, line := range lines {
		// split line at first space
		parts := strings.Split(line, " ")
		first, remaining := parts[0], strings.Join(parts[1:], " ")

		switch first {
		case "Transaction":
			var tx Transaction
			err := json.Unmarshal([]byte(remaining), &tx)
			Assert(err, "Failed to decode transaction from ledger")
			txs = append(txs, tx)

			balances[tx.From] -= tx.Fee
			for _, out := range tx.Outputs {
				balances[out.To] += out.Amount
				if out.Amount > balances[tx.From] {
					fmt.Println("Invalid transaction in ledger")
					os.Exit(1)
				}
				balances[tx.From] -= out.Amount
			}
		case "Mint":
			var mint Mint
			err := json.Unmarshal([]byte(remaining), &mint)
			Assert(err, "Failed to decode mint from ledger")
			balances[mint.To] += mint.Amount
		default:
			Log(c.InRed("Unknown transaction type in ledger"))
		}
	}

	// print transactions and update balances
	println(len(txs), "transactions")
}

func main() {
	Log(c.InYellow("Loading ledger..."))
	// create the file if it dont exist
	file, err := os.OpenFile(filepath, os.O_CREATE|os.O_APPEND, 0o644)
	Assert(err, "Failed to open ledger")
	Log(c.InGreen("Loaded!"))
	CalculateBalances()

	// create event maker
	em := EventMaker{file}

	err = em.Mint(1, 1*Unit, "initial mint")
	Assert(err, "Failed to mint")

	outputs := []TxOutput{
		MakeOutput(2, 50*Milli),
	}
	err = em.MakeTx(
		1,
		outputs,
		CalcFee(outputs),
		"https://mercury2.com", "test tx")
	Assert(err, "Failed to make transaction")

	PrintRichest()
}
