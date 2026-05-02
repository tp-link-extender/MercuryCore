import {
	BufBuilder,
	BufReader,
	DeserialiseItem,
	Items,
	ItemsMany,
	ItemsOne,
	type Quantity,
	SerialiseItem,
} from "./items"
import {
	Currency,
	IsMintable,
	LimitedSource,
	Owner,
	UnlimitedSource,
	User,
} from "./types"

export const RandNumericId = (): number => Math.floor(Math.random() * 9e8) + 1e8

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

export const RandStringId = (): string => {
	let result = ""
	for (let i = 0; i < 20; i++)
		result += idchars[Math.floor(Math.random() * idchars.length)]
	return result
}

export const ErrInvalidTransferID = new Error("invalid TransferID")

export class TransferID {
	constructor(
		private timestamp: bigint,
		private id: string
	) {}

	String(): string {
		return `${this.timestamp}-${this.id}`
	}

	Serialise(): Buffer {
		const bs = Buffer.alloc(8 + Buffer.byteLength(this.id))
		bs.writeBigUInt64BE(this.timestamp, 0)
		bs.write(this.id, 8)
		return bs
	}

	static Deserialise(data: Buffer): TransferID {
		if (data.length < 8) throw ErrInvalidTransferID
		const ts = data.readBigUInt64BE(0)
		const id = data.slice(8).toString()
		return new TransferID(ts, id)
	}
}
// Send and Transfer types ported from ledger/economy.go
export class Send {
	constructor(
		public Owner: Owner | null,
		public Items: Items
	) {}

	String(): string {
		if (this.Owner === null) return `[] -> ${this.Items}`
		return `${this.Owner.String()} -> ${this.Items}`
	}

	Valid(): Error | null {
		for (const i of this.Items.One.set)
			if (this.Owner === null && !IsMintable(i))
				return new Error(`CanOwnOne ${i.String()} cannot be minted`)

		for (const [i, qty] of this.Items.Many.map) {
			if (qty === BigInt(0))
				return new Error(`CanOwnMany ${i.String()} has zero quantity`)
			if (this.Owner === null && !IsMintable(i))
				return new Error(`CanOwnMany ${i.String()} cannot be minted`)
		}
		return null
	}

	Equal(other: Send): boolean {
		if (this.Owner !== other.Owner) return false
		return this.Items.Equal(other.Items)
	}

	UnlimitedSourceAssetMint(): boolean {
		if (!(this.Owner instanceof UnlimitedSource)) return false
		const ous = this.Owner
		const expected = new Items(
			new ItemsOne([ous.Create()]),
			new ItemsMany()
		)
		return this.Items.Equal(expected)
	}

	Serialise(): Buffer {
		const b = new BufBuilder()
		// encode Owner
		b.push(SerialiseItem(this.Owner))
		// encode Items
		b.push(this.Items.Serialise())
		return b.result()
	}

	static Deserialise(reader: BufReader): Send {
		const oi = DeserialiseItem(reader)
		let owner: Owner | null = null
		if (oi !== null)
			// runtime check
			owner = oi

		const items = Items.Deserialise(reader)
		return new Send(owner, items)
	}
}

export type Transfer = [Send, Send]

export class TransferWithID {
	constructor(
		public ID: TransferID,
		public Transfer: Transfer
	) {}

	String(): string {
		return `${this.ID.String()}: ${this.Transfer[0].String()}, ${this.Transfer[1].String()}`
	}
}

export const ErrNoSourceOrDestination = new Error(
	"transfer has no source or destination"
)
export const ErrNoItems = new Error("transfer has no items")

export function TransferValid(t: Transfer): Error | null {
	if (t[0].Owner === null && t[1].Owner === null)
		return ErrNoSourceOrDestination
	if (t[0].Items.IsEmpty() && t[1].Items.IsEmpty()) return ErrNoItems
	for (let i = 0; i < 2; i++) {
		const err = t[i]?.Valid()
		if (err) return new Error(`invalid Send[${i}]: ${err.message}`)
	}
	return null
}

export function TransferSwap(t: Transfer): Transfer {
	return [t[1], t[0]]
}

function isSale(t: Transfer): boolean {
	const from = t[0].Owner
	if (!(from instanceof LimitedSource) && !(from instanceof UnlimitedSource))
		return false
	return t[1].Owner instanceof User
}

export function TransferSale(t: Transfer): boolean {
	if (t[0].Items.IsEmpty() && t[1].Items.IsEmpty()) return false
	return isSale(t) || isSale(TransferSwap(t))
}

function isStipend(t: Transfer): boolean {
	// A stipend has a nil owner and only currency in one direction, and a user on the other
	if (
		t[0].Owner !== null ||
		t[1].Owner === null ||
		t[0].Items.IsEmpty() ||
		!t[1].Items.IsEmpty()
	)
		return false
	if (t[0].Items.One.set.size > 0) return false
	if (t[0].Items.Many.map.size !== 1) return false
	if (!(t[1].Owner instanceof User)) return false
	for (const i of t[0].Items.Many.map.keys()) {
		return i instanceof Currency
	}
	return false
}

export function TransferStipend(t: Transfer): boolean {
	return isStipend(t) || isStipend(TransferSwap(t))
}

export function TransferEqual(a: Transfer, b: Transfer): boolean {
	return a[0].Equal(b[0]) && a[1].Equal(b[1])
}

export function TransferSerialise(t: Transfer): Buffer {
	const b = new BufBuilder()
	b.push(t[0].Serialise())
	b.push(t[1].Serialise())
	return b.result()
}

export function DeserialiseTransfer(buf: Buffer): Transfer {
	const r = new BufReader(buf)
	const s0 = Send.Deserialise(r)
	const s1 = Send.Deserialise(r)
	return [s0, s1]
}

export class OwnersOne {
	set = new Set<Owner>()

	Add(o: Owner) {
		this.set.add(o)
	}

	Serialise(): Buffer {
		const b = new BufBuilder()
		const lbuf = Buffer.alloc(4)
		lbuf.writeUInt32BE(this.set.size, 0)
		b.push(lbuf)
		for (const o of this.set) {
			b.push(SerialiseItem(o))
		}
		return b.result()
	}

	static Deserialise(reader: BufReader): OwnersOne {
		const l = reader.readUint32()
		const oo = new OwnersOne()
		for (let idx = 0; idx < l; idx++) {
			const i = DeserialiseItem(reader)
			if (!(i instanceof Owner))
				throw new Error(`item is not Owner: ${i}`)
			oo.set.add(i)
		}
		return oo
	}
}

export class OwnersMany {
	map: Map<Owner, Quantity>

	constructor(initial?: Iterable<[Owner, Quantity]>) {
		this.map = new Map(initial)
	}

	Add(o: Owner, qty: Quantity) {
		const prev = this.map.get(o) ?? BigInt(0)
		this.map.set(o, prev + qty)
	}

	Serialise(): Buffer {
		const b = new BufBuilder()
		const lbuf = Buffer.alloc(4)
		lbuf.writeUInt32BE(this.map.size, 0)
		b.push(lbuf)
		for (const [o, qty] of this.map) {
			b.push(SerialiseItem(o))
			const qtybuf = Buffer.alloc(8)
			qtybuf.writeBigUInt64BE(qty, 0)
			b.push(qtybuf)
		}
		return b.result()
	}

	static Deserialise(reader: BufReader): OwnersMany {
		const l = reader.readUint32()
		const om = new OwnersMany()
		for (let idx = 0; idx < l; idx++) {
			const i = DeserialiseItem(reader)
			if (!(i instanceof Owner))
				throw new Error(`item is not Owner: ${i}`)
			const qty = reader.readUint64()
			om.map.set(i, qty)
		}
		return om
	}
}
