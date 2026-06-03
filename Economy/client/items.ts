import {
	type CanOwnMany,
	type CanOwnOne,
	DeserialiseItem,
	IsCanOwnMany,
	IsCanOwnOne,
	IsNumericItem,
	IsStringItem,
	type Item,
	type NumericItem,
	type StringItem,
	TypeNil,
} from "./types"

export function SerialiseUint32(n: number): Buffer {
	const buf = Buffer.alloc(4)
	buf.writeUInt32BE(n, 0)
	return buf
}

export function SerialiseUint64(n: bigint): Buffer {
	const buf = Buffer.alloc(8)
	buf.writeBigInt64BE(n, 0)
	return buf
}

// Serialisation helpers for Item (mirrors ledger/items.go)
function SerialiseNumeric(i: NumericItem): Buffer {
	const idbuf = Buffer.alloc(5)
	idbuf.writeUInt8(i.Type, 0)
	idbuf.writeUInt32BE(i.ID, 1)
	return idbuf
}

function SerialiseString(i: StringItem): Buffer {
	const idstr = i.ID
	const idl = Buffer.byteLength(idstr)
	const id = Buffer.alloc(2 + idl)
	id.writeUInt8(i.Type, 0)
	id.writeUInt8(idl, 1)
	id.write(idstr, 2)
	return id
}

export function SerialiseItem(i: Item | null): Buffer {
	if (i === null) return Buffer.from([TypeNil])
	if (IsNumericItem(i)) return SerialiseNumeric(i)
	if (IsStringItem(i)) return SerialiseString(i)
	throw new Error(`unknown Item type: ${i.constructor.name}`)
}

// Simple buffer reader/writer helpers used for serialisation/deserialisation
export class BufReader {
	off = 0
	constructor(private buf: Buffer) {}
	read(n: number): Buffer {
		if (this.off + n > this.buf.length) throw new Error("read out of range")
		const slice = this.buf.subarray(this.off, this.off + n)
		this.off += n
		return slice
	}
	readUint8(): number {
		const v = this.buf.readUInt8(this.off)
		this.off += 1
		return v
	}
	readUint32(): number {
		const v = this.buf.readUInt32BE(this.off)
		this.off += 4
		return v
	}
	readUint64(): bigint {
		const v = this.buf.readBigUInt64BE(this.off)
		this.off += 8
		return v
	}
	end(): boolean {
		return this.off >= this.buf.length
	}
}

// Items-related types (ported from ledger/items.go)
export type Quantity = bigint

export class ItemsOne {
	set: Set<CanOwnOne>
	constructor(initial?: Iterable<CanOwnOne>) {
		this.set = new Set(initial)
	}

	Empty(): boolean {
		return this.set.size === 0
	}

	[Symbol.iterator]() {
		return this.set[Symbol.iterator]()
	}

	String(): string {
		const parts: string[] = []
		for (const coo of this.set) parts.push(coo.String())
		return `{${parts.join(", ")}}`
	}

	Equal(other: ItemsOne): boolean {
		if (this.set.size !== other.set.size) return false
		for (const coo of this.set) if (!other.set.has(coo)) return false
		return true
	}

	Has(i: CanOwnOne): boolean {
		return this.set.has(i)
	}

	Add(i: CanOwnOne) {
		this.set.add(i)
	}

	Serialise(): Buffer {
		const b = []
		const lbuf = Buffer.alloc(4)
		lbuf.writeUInt32BE(this.set.size, 0)
		b.push(lbuf)
		for (const i of this.set) {
			b.push(SerialiseItem(i))
		}
		return Buffer.concat(b)
	}

	static Deserialise(reader: BufReader): ItemsOne {
		const l = reader.readUint32()
		const io = new ItemsOne()
		for (let idx = 0; idx < l; idx++) {
			const i = DeserialiseItem(reader)
			if (i === null) throw new Error("item is not CanOwnOne: null")
			if (!IsCanOwnOne(i)) throw new Error(`item is not CanOwnOne: ${JSON.stringify(i)}`)
			io.Add(i)
		}
		return io
	}
}

export class ItemsMany {
	map: Map<CanOwnMany, Quantity>
	constructor(initial?: Iterable<[CanOwnMany, Quantity]>) {
		this.map = new Map(initial)
	}

	Empty(): boolean {
		return this.map.size === 0
	}

	[Symbol.iterator]() {
		return this.map[Symbol.iterator]()
	}

	String(): string {
		const parts: string[] = []
		for (const [com, qty] of this.map) parts.push(`${com.String()}: ${qty}`)
		return `{${parts.join(", ")}}`
	}

	Equal(other: ItemsMany): boolean {
		if (this.map.size !== other.map.size) return false
		for (const [com, qty] of this.map) {
			const otherQty = other.map.get(com)
			if (otherQty === undefined || otherQty !== qty) return false
		}
		return true
	}

	Add(i: CanOwnMany, qty: Quantity) {
		// ok maybe I should consider using ?? more. I usually just use || regardless since I don't care about the type conversion, however if one's doing something like `x || ""` it evaluates the rhs even if the lhs is already ""
		const prev = this.map.get(i) ?? 0n
		this.map.set(i, prev + qty)
	}

	Serialise(): Buffer {
		const b = []
		const lbuf = Buffer.alloc(4)
		lbuf.writeUInt32BE(this.map.size, 0)
		b.push(lbuf)
		for (const [i, qty] of this.map) {
			b.push(SerialiseItem(i))
			const qtybuf = Buffer.alloc(8)
			qtybuf.writeBigUInt64BE(qty, 0)
			b.push(qtybuf)
		}
		return Buffer.concat(b)
	}

	static Deserialise(reader: BufReader): ItemsMany {
		const l = reader.readUint32()
		const im = new ItemsMany()
		for (let idx = 0; idx < l; idx++) {
			const i = DeserialiseItem(reader)
			if (i === null) throw new Error("item is not CanOwnMany: null")
			if (!IsCanOwnMany(i)) throw new Error(`item is not CanOwnMany: ${JSON.stringify(i)}`)
			const qty = reader.readUint64()
			im.map.set(i, qty)
		}
		return im
	}
}

export class Items {
	One: ItemsOne
	Many: ItemsMany
	constructor(one?: ItemsOne, many?: ItemsMany) {
		this.One = one ?? new ItemsOne()
		this.Many = many ?? new ItemsMany()
	}

	String(): string {
		if (this.One.set.size === 0 && this.Many.map.size === 0)
			return "Items {}"
		let out = "Items {"
		if (this.One.set.size > 0) out += `\n\tOne ${this.One.String()}`
		if (this.Many.map.size > 0) out += `\n\tMany ${this.Many.String()}`
		out += "\n}"
		return out
	}

	Equal(other: Items): boolean {
		return this.One.Equal(other.One) && this.Many.Equal(other.Many)
	}

	IsEmpty(): boolean {
		return this.One.set.size === 0 && this.Many.map.size === 0
	}

	Serialise(): Buffer {
		return Buffer.concat([this.One.Serialise(), this.Many.Serialise()])
	}

	static Deserialise(reader: BufReader): Items {
		const one = ItemsOne.Deserialise(reader)
		const many = ItemsMany.Deserialise(reader)
		return new Items(one, many)
	}
}
