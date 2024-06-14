// Mercury Economy service

package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"slices"
	"strings"
	"time"

	c "github.com/TwiN/go-color"
	gonanoid "github.com/matoous/go-nanoid/v2"
)

func randId() string {
	id, _ := gonanoid.Generate("0123456789abcdefghijklmnopqrstuvwxyz", 15)
	return id
}

func Log(txt string) {
	// I HATE GO DATE FORMATTING!!! I HATE GO DATE FORMATTING!!!
	fmt.Println(time.Now().Format("2006/01/02, 15:04:05 "), txt)
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

const filepath = "../data/ledger" // jsonl file
const (
	Micro currency = 1
	Milli          = 1e3 * Micro
	Unit           = 1e6 * Micro // standard unit

	Kilo = 1e3 * Unit
	Mega = 1e6 * Unit
	Giga = 1e9 * Unit
	Tera = 1e12 * Unit // uint64 means ~18 tera is the economy limit

	minStipend = 500 * Unit
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
		fmt.Println(kv.Key, ToReadable(kv.Value))
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

type Burn struct {
	From     userNumber
	Amount   currency
	Time     uint64
	Note, Id string
}

// includes both burns and fees
type Exit struct {
	Amount currency
	Time   uint64
}

var (
	file     *os.File
	balances = map[userNumber]currency{}

	// Stipends are calculated based on the amount of currency exited from the economy in the last 24 hours
	exitsLast24h = []Exit{}
)

func appendExit(amount currency, t uint64) {
	if t > uint64(time.Now().UnixMilli())-24*60*60*1000 {
		exitsLast24h = append(exitsLast24h, Exit{amount, t})
	}
}

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
		} else if out.To == from {
			return fmt.Errorf("circular transaction: %d -> %d", from, out.To)
		}
		outs[out.To] = true
		total += out.Amount
	}

	if fee < currency(float64(total)*0.3) {
		return fmt.Errorf("fee too low, must be at least 30%% of total amount: expected %s, got %s", ToReadable(currency(float64(total)*0.3)), ToReadable(fee))
	} else if total+fee > balances[from] {
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", ToReadable(balances[from]), ToReadable(total+fee))
	}
	return nil
}

func calcFee(outputs []TxOutput) currency {
	var total currency
	for _, out := range outputs {
		total += out.Amount
	}
	return currency(float64(total) * 0.3)
}

func calcBalances() {
	bytes, err := io.ReadAll(file)
	Assert(err, "Failed to read from ledger")

	lines := strings.Split(string(bytes), "\n")
	lines = lines[:len(lines)-1] // remove last empty line

	// decode transactions, update balances
	for _, line := range lines {
		// split line at first space, with the transaction type being the first part
		parts := strings.Split(line, " ")
		switch first, remaining := parts[0], strings.Join(parts[1:], " "); first {
		case "Transaction":
			var tx Transaction
			err := json.Unmarshal([]byte(remaining), &tx)
			Assert(err, "Failed to decode transaction from ledger")

			balances[tx.From] -= tx.Fee
			appendExit(tx.Fee, tx.Time)

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
		case "Burn":
			var burn Burn
			err := json.Unmarshal([]byte(remaining), &burn)
			Assert(err, "Failed to decode burn from ledger")

			balances[burn.From] -= burn.Amount
			appendExit(burn.Amount, burn.Time)
		default:
			Log(c.InRed("Unknown transaction type in ledger"))
		}
	}
}

func calcStipend() currency {
	total := minStipend
	var toRemove int
	for _, exit := range exitsLast24h {
		// remove exits older than 24 hours
		if exit.Time > uint64(time.Now().UnixMilli())-24*60*60*1000 {
			toRemove++
		} else {
			total += exit.Amount
		}
	}
	exitsLast24h = exitsLast24h[toRemove:]
	return total
}

func appendEvent(e any, eType string) error {
	file.WriteString(eType + " ") // Lol good luck error handling this
	return json.NewEncoder(file).Encode(e)
}

func transact(from userNumber, outputs []TxOutput, fee currency, link, note string) error {
	if err := ValidateTx(from, outputs, fee); err != nil {
		return err
	} else if err := appendEvent(
		Transaction{from, outputs, fee, uint64(time.Now().UnixMilli()), link, note, randId()},
		"Transaction",
	); err != nil {
		return err
	}

	// successfully written
	for _, out := range outputs {
		balances[from] -= out.Amount
		if out.To != 0 {
			balances[out.To] += out.Amount
		}
	}
	return nil
}

func mint(to userNumber, amount currency, note string) error {
	if amount == 0 {
		return fmt.Errorf("mint amount must be positive")
	} else if err := appendEvent(
		Mint{to, amount, uint64(time.Now().UnixMilli()), note, randId()},
		"Mint",
	); err != nil {
		return err
	}

	// successfully written
	balances[to] += amount
	return nil
}

func stipend(to userNumber) error {
	return mint(
		to,
		calcStipend(),
		"Stipend",
	)
}

func burn(from userNumber, amount currency, note string) error {
	if amount == 0 {
		return fmt.Errorf("burn amount must be positive")
	} else if amount > balances[from] {
		return fmt.Errorf("insufficient balance: balance was %s, at least %s is required", ToReadable(balances[from]), ToReadable(amount))
	} else if err := appendEvent(
		Burn{from, amount, uint64(time.Now().UnixMilli()), note, randId()},
		"Burn",
	); err != nil {
		return err
	}

	// successfully written
	balances[from] -= amount
	return nil
}

func main() {
	Log(c.InYellow("Loading ledger..."))
	// create the file if it dont exist
	var err error
	file, err = os.OpenFile(filepath, os.O_CREATE|os.O_APPEND, 0o644)
	Assert(err, "Failed to open ledger")
	defer file.Close()
	calcBalances()

	PrintRichest()

	println("\nCurrent stipend ", ToReadable(calcStipend()))
}
