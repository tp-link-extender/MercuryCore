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
export abstract class Item {
	abstract String(): string
	// only used for serialisation atm
	abstract readonly Type: Type
}

export abstract class NumericItem extends Item {
	abstract readonly ID: number
	// only used for serialisation atm
	// uses number (uint32 in Go)
}

export abstract class StringItem extends Item {
	// only used for serialisation atm
	abstract readonly ID: string
}

// Marker interfaces remain for compile-time typing of behaviours
export abstract class CanOwnOne extends Item {}
export abstract class CanOwnMany extends Item {}
export abstract class Mintable extends Item {}
export abstract class Owner extends Item {}

export function IsMintable(i: Item): boolean {
	return i instanceof Mintable
}

// Concrete classes extend the abstract bases so you can use `instanceof`.
export class Currency extends NumericItem implements Mintable, CanOwnMany {
	override Type = TypeCurrency

	constructor(public ID: number) {
		super()
	}

	String(): string {
		return `currency(${this.ID})`
	}
}

export class LimitedAsset extends NumericItem implements CanOwnMany {
	override Type = TypeLimitedAsset

	constructor(public ID: number) {
		super()
	}

	String(): string {
		return `limited-asset(${this.ID})`
	}
}

export class UnlimitedAsset extends NumericItem implements CanOwnOne {
	override Type = TypeLimitedAsset

	constructor(public ID: number) {
		super()
	}

	String(): string {
		return `unlimited-asset(${this.ID})`
	}
}

export class LimitedSource
	extends NumericItem
	implements CanOwnOne, Mintable, Owner
{
	override Type = TypeLimitedSource

	constructor(public ID: number) {
		super()
	}

	String(): string {
		return `limited-source(${this.ID})`
	}

	Create(): LimitedAsset {
		return new LimitedAsset(this.ID)
	}
}

export class UnlimitedSource
	extends NumericItem
	implements CanOwnOne, Mintable, Owner
{
	override Type = TypeUnlimitedSource

	constructor(public ID: number) {
		super()
	}

	String(): string {
		return `unlimited-source(${this.ID})`
	}

	Create(): UnlimitedAsset {
		return new UnlimitedAsset(this.ID)
	}
}

export class Place extends NumericItem implements CanOwnOne, Mintable {
	override Type = TypePlace

	constructor(public ID: number) {
		super()
	}

	String(): string {
		return `place(${this.ID})`
	}
}

export class User extends StringItem implements Owner {
    override Type = TypeUser

    constructor(public ID: string) {
		super()
	}

	String(): string {
		return `user(${this.ID})`
	}
}

export class Group extends StringItem implements CanOwnOne, Mintable, Owner {
	override Type = TypeGroup
	
	constructor(public ID: string) {
		super()
	}

	String(): string {
		return `group(${this.ID})`
	}
}
