import { OwnersMany, OwnersOne, TransferWithID } from "./economy"
import {
	Buf,
	BufReader,
	Items,
	type Quantity,
	SerialiseItem,
	SerialiseUint32,
	SerialiseUint64,
} from "./items"
import {
	type CanOwnMany,
	type CanOwnOne,
	DeserialiseItem,
	Group,
	type Item,
	LimitedSource,
	type Owner,
	Place,
	UnlimitedSource,
	type User,
} from "./types"

type Route =
	| "ownsOne"
	| "ownsMany"
	| "ownersOne"
	| "ownersMany"
	| "countOwnersOne"
	| "countOwnersMany"
	| "inventory"
	| "balance"
	| "stipend"
	| "createLimitedSource"
	| "createUnlimitedSource"
	| "createPlace"
	| "createGroup"
	| "buyUnlimitedAsset"
	| "buyLimitedAsset"
	| "history"
	| "historyOwner"

const url = "http://localhost:2009"

// Just use Promise<boolean> if no value is returned
export type ReturnValue<T> = Promise<{ ok: true; value: T } | { ok: false }>

type Fetch = typeof fetch

const request = (f: Fetch, route: Route, body: Buf): Promise<Response> =>
	f(`${url}/${route}`, {
		method: "POST",
		body: body.buf,
	})

export async function ownsOne(
	f: Fetch,
	o: Owner,
	i: CanOwnOne // foi lol
): ReturnValue<boolean> {
	let res: Response
	try {
		res = await request(
			f,
			"ownsOne",
			Buf.concat([SerialiseItem(o), SerialiseItem(i)])
		)
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false } // it won't be another 2xx status code

	const buf = await res.arrayBuffer()
	return { ok: true, value: new DataView(buf).getUint8(0) === 1 }
}

export async function ownsMany(
	f: Fetch,
	o: Owner,
	i: CanOwnMany
): ReturnValue<number> {
	let res: Response
	try {
		res = await request(
			f,
			"ownsMany",
			Buf.concat([SerialiseItem(o), SerialiseItem(i)])
		)
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

const resReader = async (res: Response): Promise<BufReader> =>
	new BufReader(Buf.from(await res.arrayBuffer()))

export async function ownersOne(
	f: Fetch,
	i: CanOwnOne // endif
): ReturnValue<OwnersOne> {
	let res: Response
	try {
		res = await request(f, "ownersOne", SerialiseItem(i))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	return { ok: true, value: OwnersOne.Deserialise(await resReader(res)) }
}

export async function ownersMany(
	f: Fetch,
	i: CanOwnMany
): ReturnValue<OwnersMany> {
	let res: Response
	try {
		res = await request(f, "ownersMany", SerialiseItem(i))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	return { ok: true, value: OwnersMany.Deserialise(await resReader(res)) }
}

export async function countOwnersOne(
	f: Fetch,
	i: CanOwnOne
): ReturnValue<number> {
	let res: Response
	try {
		res = await request(f, "countOwnersOne", SerialiseItem(i))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

export async function countOwnersMany(
	f: Fetch,
	i: CanOwnMany
): ReturnValue<number> {
	let res: Response
	try {
		res = await request(f, "countOwnersMany", SerialiseItem(i))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

export async function inventory(f: Fetch, o: Owner): ReturnValue<Items> {
	let res: Response
	try {
		res = await request(f, "inventory", SerialiseItem(o))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	return { ok: true, value: Items.Deserialise(await resReader(res)) }
}

export async function balance(f: Fetch, o: Owner): ReturnValue<bigint> {
	let res: Response
	try {
		res = await request(f, "balance", SerialiseItem(o))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: BigInt(text) }
}

export async function stipend(f: Fetch, o: Owner): Promise<boolean> {
	let res: Response
	try {
		res = await request(f, "stipend", SerialiseItem(o))
	} catch {
		return false
	}

	return res.status === 204 || res.status === 429
}

const resToItem = async (res: Response): Promise<Item | null> =>
	DeserialiseItem(await resReader(res))

export async function createLimitedSource(
	f: Fetch,
	u: User
): ReturnValue<LimitedSource> {
	let res: Response
	try {
		res = await request(f, "createLimitedSource", SerialiseItem(u))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof LimitedSource))
		throw new Error(`item is not LimitedSource: ${JSON.stringify(i)}`)

	return { ok: true, value: i }
}

export async function createUnlimitedSource(
	f: Fetch,
	u: User
): ReturnValue<UnlimitedSource> {
	let res: Response
	try {
		res = await request(f, "createUnlimitedSource", SerialiseItem(u))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof UnlimitedSource))
		throw new Error(`item is not UnlimitedSource: ${JSON.stringify(i)}`)

	return { ok: true, value: i }
}

export async function createPlace(f: Fetch, u: User): ReturnValue<Place> {
	let res: Response
	try {
		res = await request(f, "createPlace", SerialiseItem(u))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof Place))
		throw new Error(`item is not Place: ${JSON.stringify(i)}`)

	return { ok: true, value: i }
}

export async function createGroup(f: Fetch, u: User): ReturnValue<Group> {
	let res: Response
	try {
		res = await request(f, "createGroup", SerialiseItem(u))
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof Group))
		throw new Error(`item is not Group: ${JSON.stringify(i)}`)

	return { ok: true, value: i }
}

export const buyUnlimitedAsset = (
	f: Fetch,
	u: User,
	src: UnlimitedSource,
	price: Quantity
): Promise<boolean> =>
	request(
		f,
		"buyUnlimitedAsset",
		Buf.concat([
			SerialiseItem(u),
			SerialiseItem(src),
			SerialiseUint64(price),
		])
	).then(res => res.status === 204)

export const buyLimitedAsset = (
	f: Fetch,
	u: User,
	src: UnlimitedSource,
	priceEach: Quantity,
	qty: Quantity
): Promise<boolean> =>
	request(
		f,
		"buyLimitedAsset",
		Buf.concat([
			SerialiseItem(u),
			SerialiseItem(src),
			SerialiseUint64(priceEach),
			SerialiseUint64(qty),
		])
	).then(res => res.status === 204)

async function getHistory(f: Fetch, body: Buf): ReturnValue<TransferWithID[]> {
	let res: Response
	try {
		res = await request(f, "history", body)
	} catch {
		return { ok: false }
	}
	if (res.status !== 200) return { ok: false }

	const buf = Buf.from(await res.arrayBuffer())
	const r = new BufReader(buf)

	const transfers: TransferWithID[] = []

	while (!r.end()) {
		const t = TransferWithID.Deserialise(r)
		if (t === null) break
		transfers.push(t)
	}

	return { ok: true, value: transfers }
}

export const history = (
	f: Fetch,
	n: number /* the only good thing about rust */
): ReturnValue<TransferWithID[]> => getHistory(f, SerialiseUint32(n))

export const historyOwner = (f: Fetch, n: number, o: Owner) =>
	getHistory(f, Buf.concat([SerialiseUint32(n), SerialiseItem(o)]))
