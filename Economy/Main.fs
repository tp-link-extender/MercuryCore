// Mercury Economy service implementation in F#

open System
open System.IO

let alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"

let randId () =
    let rand = Random()

    [ for _ in 1..15 -> alphabet[rand.Next(0, 36)] |> string ]
    |> String.concat ""

let Log (txt) =
    let now = DateTime.Now.ToString "yyyy/MM/dd hh:mm:ss" // ..sure, whatever
    Console.WriteLine $"{now} {txt}"

// uint64 is overkill? idgaf
type userNumber = uint64
type currency = uint64
type asset = uint64

let filepath = "../data/ledger"

let Micro: currency = uint64 1
let Milli = uint64 1e3 * Micro
let Unit = uint64 1e6 * Micro //standard unit
let Kilo = uint64 1e3 * Unit
let Mega = uint64 1e6 * Unit
let Giga = uint64 1e9 * Unit
let Tera = uint64 1e12 * Unit // uint64 means ~18 tera is the economy limit

// Target Currency per User, the economy size will try to be this * userCount()
// By "user", I mean every user who has ever transacted with the economy
let TCU = 100. * float Unit
let baseStipend = 10. * float Unit
let baseFee = 0.1
let stipendTime = 12 * 60 * 60 * 1000

let ToReadable (c: currency) =
    let f = float c
    $"%d{uint64 (f / 1e6)}.%06d{uint64 (f % 1e6)}  unit"

// For now, transaction outputs are overkill
// Since fees are stored as a separate value and are burned, I can't see a reason for them to exist for now
// UTXOs lmao
type SentTx =
    { From: userNumber
      To: userNumber
      Amount: currency
      Link: string
      Note: string
      Returns: asset list }

type Tx =
    SentTx * {| Fee: currency
                Time: uint64
                Id: string |}

type SentMint =
    { To: userNumber
      Amount: currency
      Note: string }

type Mint = SentMint * {| Time: uint64; Id: string |}

type SentBurn =
    { From: userNumber
      Amount: currency
      Note: string
      Link: string
      Returns: asset list }

type Burn = SentBurn * {| Time: uint64; Id: string |}

let balances = Map.empty<userNumber, currency>
let prevStipends = Map.empty<userNumber, uint64>

let ValidateTx (sent: SentTx) (fee: currency) =
    let total = sent.Amount + fee

    if sent.Amount = 0UL then
        Error "transaction must have an amount"
    else if sent.From = 0UL then
        Error "transaction must have a sender"
    else if sent.To = 0UL then
        Error "transaction must have a recipient"
    else if sent.From = sent.To then
        Error $"circular transaction: %d{sent.From} -> %d{sent.To}"
    else if sent.Note = "" then
        Error "transaction must have a note"
    else if sent.Link = "" then
        Error "transaction must have a link"
    else if total > balances[sent.From] then
        Error
            $"insufficient balance: balance was %s{ToReadable balances[sent.From]}, at least %s{ToReadable total} is required"
    else
        Ok()

let ValidateMint (sent: SentMint) =
    if sent.Amount = 0UL then
        Error "mint must have an amount"
    else if sent.To = 0UL then
        Error "mint must have a recipient"
    else if sent.Note = "" then
        Error "mint must have a note"
    else
        Ok()

let ValidateBurn (sent: SentBurn) =
    if sent.Amount = 0UL then
        Error "mint must have an amount"
    else if sent.From = 0UL then
        Error "mint must have a sender"
    else if sent.Amount > balances[sent.From] then
        Error
            $"insufficient balance: balance was %s{ToReadable balances[sent.From]}, at least %s{ToReadable sent.Amount} is required"
    else if sent.Note = "" then
        Error "mint must have a note"
    else if sent.Link = "" then
        Error "mint must have a link"
    else
        Ok()

let userCount () = balances |> Map.count
let economySize () = balances |> Map.values |> Seq.sum

// Current Currency per User
let calcCCU () =
    float (economySize ()) / float (userCount ())

// If the economy is too small, stipends will increase
// If the economy is near or above desired size, stipends will be baseStipend
let calcStipend () =
    max ((TCU - calcCCU () + baseStipend) / 2., baseStipend)

// If the economy is too large, fees will increase
// If the economy is near or below desired size, fees will be baseFee
let calcFee () =
    max (
        (1. + (calcCCU () * 0.9 - TCU) / TCU * 4.)
        * baseFee,
        baseFee
    )

let updateBalances () =
    let lines =
        File.ReadLines(filepath)
        |> Seq.toList
        |> (fun l -> l[.. l.Length - 1])

    lines

Log(updateBalances ())
