import {
	Currency,
	Group,
	type Item,
	LimitedAsset,
	LimitedSource,
	NumericItem,
	Place,
	StringItem,
	TypeCurrency,
	TypeGroup,
	TypeLimitedAsset,
	TypeLimitedSource,
	TypeNil,
	TypePlace,
	TypeUnlimitedAsset,
	TypeUnlimitedSource,
	TypeUser,
	UnlimitedAsset,
	UnlimitedSource,
	User,
} from "./types"

// Serialisation helpers for Item (mirrors ledger/items.go)
function SerialiseNumeric(i: NumericItem): Buffer {
	const idbuf = Buffer.alloc(5)
	idbuf.writeUInt8(i.Type, 0)
	idbuf.writeUInt32BE(i.ID, 1)
	return idbuf
}

function SerialiseString(i: StringItem): Buffer {
	const idstr = i.ID
	const id = Buffer.alloc(2 + Buffer.byteLength(idstr))
	id.writeUInt8(i.Type, 0)
	id.writeUInt8(Buffer.byteLength(idstr), 1)
	id.write(idstr, 2)
	return id
}

export function SerialiseItem(i: Item | null): Buffer {
	if (i === null) return Buffer.from([0])
	if (i instanceof NumericItem) return SerialiseNumeric(i)
	if (i instanceof StringItem) return SerialiseString(i)
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
}

export class BufBuilder {
	parts: Buffer[] = []
	push(b: Buffer) {
		this.parts.push(b)
	}
	result(): Buffer {
		return Buffer.concat(this.parts)
	}
}

export function DeserialiseItem(reader: BufReader): Item | null {
	const typeByte = reader.readUint8()
	if (typeByte === TypeNil) return null

	// string IDs
	if (typeByte === TypeUser || typeByte === TypeGroup) {
		const len = reader.readUint8()
		const idbuf = reader.read(len)
		const id = idbuf.toString()
		if (typeByte === TypeUser) return new User(id)
		return new Group(id)
	}

	// numeric IDs
	const id = reader.readUint32()
	switch (typeByte) {
		case TypeCurrency:
			return new Currency(id)
		case TypeLimitedAsset:
			return new LimitedAsset(id)
		case TypeUnlimitedAsset:
			return new UnlimitedAsset(id)
		case TypeLimitedSource:
			return new LimitedSource(id)
		case TypeUnlimitedSource:
			return new UnlimitedSource(id)
		case TypePlace:
			return new Place(id)
	}

	throw new Error(`unknown Type: ${typeByte}`)
}

// Items-related types (ported from ledger/items.go)
export type Quantity = bigint

export class ItemsOne {
	set: Set<Item>
	constructor(initial?: Iterable<Item>) {
		this.set = new Set(initial)
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

	Has(i: Item): boolean {
		return this.set.has(i)
	}

	Add(i: Item) {
		this.set.add(i)
	}

	Serialise(): Buffer {
		const b = new BufBuilder()
		const lbuf = Buffer.alloc(4)
		lbuf.writeUInt32BE(this.set.size, 0)
		b.push(lbuf)
		for (const i of this.set) {
			b.push(SerialiseItem(i))
		}
		return b.result()
	}

	static Deserialise(reader: BufReader): ItemsOne {
		const l = reader.readUint32()
		const io = new ItemsOne()
		for (let idx = 0; idx < l; idx++) {
			const i = DeserialiseItem(reader)
			if (i === null) throw new Error("item is not CanOwnOne: nil")
			// runtime check that it satisfies CanOwnOne is not doable at runtime in TS; assume correct
			io.Add(i)
		}
		return io
	}
}

export class ItemsMany {
	map: Map<Item, Quantity>
	constructor(initial?: Iterable<[Item, Quantity]>) {
		this.map = new Map(initial)
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

	Add(i: Item, qty: Quantity) {
		const prev = this.map.get(i) ?? BigInt(0)
		this.map.set(i, prev + qty)
	}

	Serialise(): Buffer {
		const b = new BufBuilder()
		const lbuf = Buffer.alloc(4)
		lbuf.writeUInt32BE(this.map.size, 0)
		b.push(lbuf)
		for (const [i, qty] of this.map) {
			b.push(SerialiseItem(i))
			const qtybuf = Buffer.alloc(8)
			qtybuf.writeBigUInt64BE(qty, 0)
			b.push(qtybuf)
		}
		return b.result()
	}

	static Deserialise(reader: BufReader): ItemsMany {
		const l = reader.readUint32()
		const im = new ItemsMany()
		for (let idx = 0; idx < l; idx++) {
			const i = DeserialiseItem(reader)
			if (i === null) throw new Error("item is not CanOwnMany: nil")
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
		const b = new BufBuilder()
		b.push(this.One.Serialise())
		b.push(this.Many.Serialise())
		return b.result()
	}

	static Deserialise(reader: BufReader): Items {
		const one = ItemsOne.Deserialise(reader)
		const many = ItemsMany.Deserialise(reader)
		return new Items(one, many)
	}
}
