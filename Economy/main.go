// Mercury Economy service

package main

import (
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
	"time"

	c "github.com/TwiN/go-color"
)

const filepath = "../data/ledger" // jsonl file

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
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].Value > sorted[j].Value
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
	// Transactions with From = 0 are minted coins
	From       userNumber
	Outputs    []TxOutput
	Timestamp  uint64
	Link, Note string
}

var balances = map[userNumber]currency{}

func MakeOutput(to userNumber, amount currency) TxOutput {
	return TxOutput{To: to, Amount: amount}
}

const minFee = 50 * Milli

var fee = TxOutput{To: 0, Amount: minFee}

func ValidateTx(from userNumber, outputs []TxOutput) error {
	if len(outputs) == 0 {
		return fmt.Errorf("transaction must have at least one output")
	}

	var total currency
	outs := map[userNumber]bool{}
	for _, out := range outputs {
		if out.Amount == 0 {
			return fmt.Errorf("output amount must be positive")
		}
		total += out.Amount

		if outs[out.To] {
			return fmt.Errorf("duplicate output")
		}
		outs[out.To] = true

		if out.To == from {
			return fmt.Errorf("circular transaction: %d -> %d", from, out.To)
		}

		if out.To == 0 && out.Amount < minFee {
			return fmt.Errorf("fee too low")
		}
	}
	if from != 0 && !outs[0] {
		return fmt.Errorf("no fee")
	}
	if total > balances[from] && from != 0 {
		return fmt.Errorf("insufficient balance")
	}

	return nil
}

func MakeTx(from userNumber, outputs []TxOutput, link, note string) (Transaction, error) {
	err := ValidateTx(from, outputs)
	if err != nil {
		return Transaction{}, err
	}

	return Transaction{
		From:      from,
		Outputs:   outputs,
		Timestamp: uint64(time.Now().UnixMilli()),
		Link:      link,
		Note:      note,
	}, nil
}

func AppendTx(file *os.File, tx Transaction) error {
	if tx.Timestamp == 0 { // field overloading a bit
		return fmt.Errorf("invalid transaction")
	}

	for _, out := range tx.Outputs {
		if out.To != 0 {
			balances[out.To] += out.Amount
		}
		if tx.From != 0 {
			balances[tx.From] -= out.Amount
		}
	}

	stringWriter := &strings.Builder{}
	json.NewEncoder(stringWriter).Encode(tx)
	str := stringWriter.String()

	// write to file
	_, err := file.WriteString(str)
	return err
}

func main() {
	Log(c.InYellow("Loading ledger..."))
	// create the file if it dont exist
	file, err := os.OpenFile(filepath, os.O_CREATE|os.O_APPEND, 0o644)
	Assert(err, "Failed to open ledger")
	Log(c.InGreen("Loaded!"))

	// read transactions
	bytes, err := os.ReadFile(filepath)
	Assert(err, "Failed to read ledger")

	lines := strings.Split(string(bytes), "\n")
	lines = lines[:len(lines)-1] // remove last empty line

	var txs []Transaction

	// decode transactions
	for _, line := range lines {
		var tx Transaction
		err := json.Unmarshal([]byte(line), &tx)
		Assert(err, "Failed to decode transaction")
		txs = append(txs, tx)
	}

	// print transactions and update balances
	println(len(txs), "transactions")
	for _, tx := range txs {
		for _, out := range tx.Outputs {
			if out.To != 0 {
				balances[out.To] += out.Amount
			}
			if tx.From != 0 {
				if out.Amount > balances[tx.From] {
					fmt.Println("Invalid transaction in ledger")
					os.Exit(1)
				}
				balances[tx.From] -= out.Amount
			}
		}
	}

	fmt.Println(file)
    PrintRichest()
}
