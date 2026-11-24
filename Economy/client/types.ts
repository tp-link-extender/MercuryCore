import type { BufReader } from "./items"
import {
	Currency,
	Group,
	LimitedAsset,
	LimitedSource,
	Package,
	PackageSource,
	Place,
	type Type,
	TypeCurrency,
	TypeGroup,
	TypeLimitedAsset,
	TypeLimitedSource,
	TypeNil,
	TypePackage,
	TypePackageSource,
	TypePlace,
	TypeUnlimitedAsset,
	TypeUnlimitedSource,
	TypeUser,
	UnlimitedAsset,
	UnlimitedSource,
	User,
} from "./types.gen"

// The concrete item classes and their Type values are generated from ledger/types.go. Only the interfaces and helpers that work across them are written here.
export * from "./types.gen"

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
		case TypePackage:
			return new Package(id)
		case TypePackageSource:
			return new PackageSource(id)
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

export function DeserialiseOwner(r: BufReader): Owner | null {
	const i = DeserialiseItem(r)
	if (!i) return null
	if (!IsOwner(i)) throw new Error(`item is not Owner: ${JSON.stringify(i)}`)

	return i as Owner
}

export interface Source extends NumericItem, Owner {
	Source(): void
}
export const IsSource = (i: Item): i is Source =>
	IsOwner(i) && (i as Source).Source !== undefined
