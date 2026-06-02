import type { BufReader } from "./items"

export type Type = number

// number ID types

export const TypeNil: Type = 0
export const TypeCurrency: Type = 1
export const TypeLimitedAsset: Type = 2
export const TypeUnlimitedAsset: Type = 3
export const TypeLimitedSource: Type = 4
export const TypeUnlimitedSource: Type = 5
export const TypePlace: Type = 6

// string ID types

export const TypeUser: Type = 7
export const TypeGroup: Type = 8

// Abstract base classes to allow `instanceof` checks
export interface Item {
	String(): string
	// only used for serialisation atm
	Type: Type
}

export function DeserialiseItem(r: BufReader): Item | null {
	const typeByte = r.readUint8()
	if (typeByte === TypeNil) return null

	if (typeByte === TypeUser || typeByte === TypeGroup) {
		// string IDs
		const len = r.readUint8()
		const idbuf = r.read(len)
		const id = idbuf.toString()
		if (typeByte === TypeUser) return new User(id)
		return new Group(id)
	}

	// numeric IDs
	const id = r.readUint32()
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

export interface NumericItem extends Item {
	ID: number
	// only used for serialisation atm
	// uses number (uint32 in Go)
}
export const IsNumericItem = (i: Item): i is NumericItem =>
	typeof (i as NumericItem).ID === "number"

export interface StringItem extends Item {
	// only used for serialisation atm
	ID: string
}
export const IsStringItem = (i: Item): i is StringItem =>
	typeof (i as StringItem).ID === "string"

// Marker interfaces remain for compile-time typing of behaviours
export interface CanOwnOne extends Item {
	CanOwnOne(): void
}
export const IsCanOwnOne = (i: Item): i is CanOwnOne =>
	(i as CanOwnOne).CanOwnOne !== undefined

export interface CanOwnMany extends Item {
	CanOwnMany(): void
}
export const IsCanOwnMany = (i: Item): i is CanOwnMany =>
	(i as CanOwnMany).CanOwnMany !== undefined

export interface Mintable extends Item {
	Mintable(): void
}
export const IsMintable = (i: Item): i is Mintable =>
	(i as Mintable).Mintable !== undefined

export interface Owner extends Item {
	Owner(): void
}
export const IsOwner = (i: Item): i is Owner => (i as Owner).Owner !== undefined

export function DeserialiseOwner(r: BufReader): Owner {
	const i = DeserialiseItem(r)
	if (!i) throw new Error("item is not Owner: null")
	if (!IsOwner(i)) throw new Error(`item is not Owner: ${JSON.stringify(i)}`)

	return i as Owner
}

export interface Source extends NumericItem, Owner {
	Source(): void
}
export const IsSource = (i: Item): i is Source =>
	IsOwner(i) && (i as Source).Source !== undefined

// Concrete classes extend the abstract bases so we can use `instanceof`
export class Currency implements NumericItem, CanOwnMany, Mintable {
	Type = TypeCurrency

	CanOwnMany() {}
	Mintable() {}

	constructor(public ID: number) {}

	String(): string {
		return `currency(${this.ID})`
	}
}

export class LimitedAsset implements NumericItem, CanOwnMany {
	Type = TypeLimitedAsset

	CanOwnMany() {}

	constructor(public ID: number) {}

	String(): string {
		return `limited-asset(${this.ID})`
	}
}

export class UnlimitedAsset implements NumericItem, CanOwnOne {
	Type = TypeLimitedAsset

	CanOwnOne() {}

	constructor(public ID: number) {}

	String(): string {
		return `unlimited-asset(${this.ID})`
	}
}

export class LimitedSource
	implements NumericItem, CanOwnOne, Mintable, Owner, Source
{
	Type = TypeLimitedSource

	CanOwnOne() {}
	Mintable() {}
	Owner() {}
	Source() {}

	constructor(public ID: number) {}

	String(): string {
		return `limited-source(${this.ID})`
	}

	Create(): LimitedAsset {
		return new LimitedAsset(this.ID)
	}
}

export class UnlimitedSource
	implements NumericItem, CanOwnOne, Mintable, Owner, Source
{
	Type = TypeUnlimitedSource

	CanOwnOne() {}
	Mintable() {}
	Owner() {}
	Source() {}

	constructor(public ID: number) {}

	String(): string {
		return `unlimited-source(${this.ID})`
	}

	Create(): UnlimitedAsset {
		return new UnlimitedAsset(this.ID)
	}
}

export class Place implements NumericItem, CanOwnOne, Mintable {
	Type = TypePlace

	CanOwnOne() {}
	Mintable() {}

	constructor(public ID: number) {}

	String(): string {
		return `place(${this.ID})`
	}
}

export class User implements StringItem, Owner {
	Type = TypeUser

	Owner() {}

	constructor(public ID: string) {}

	String(): string {
		return `user(${this.ID})`
	}
}

export class Group implements StringItem, CanOwnOne, Mintable, Owner {
	Type = TypeGroup

	CanOwnOne() {}
	Mintable() {}
	Owner() {}

	constructor(public ID: string) {}

	String(): string {
		return `group(${this.ID})`
	}
}
