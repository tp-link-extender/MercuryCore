import { OwnersMany, OwnersOne, TransferWithID } from "./economy"
import {
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
	Group,
	Item,
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

const request = (f: Fetch, route: Route, body: Buffer): Promise<Response> =>
	f(`${url}/${route}`, {
		method: "POST",
		body: Uint8Array.from(body),
	})

export async function ownsOne(
	f: Fetch,
	o: Owner,
	i: CanOwnOne // foi lol
): ReturnValue<boolean> {
	const res = await request(
		f,
		"ownsOne",
		Buffer.concat([SerialiseItem(o), SerialiseItem(i)])
	)
	if (res.status !== 200) return { ok: false } // it won't be another 2xx status code

	const buf = await res.arrayBuffer()
	return { ok: true, value: new DataView(buf).getUint8(0) === 1 }
}

export async function ownsMany(
	f: Fetch,
	o: Owner,
	i: CanOwnMany
): ReturnValue<number> {
	const res = await request(
		f,
		"ownsMany",
		Buffer.concat([SerialiseItem(o), SerialiseItem(i)])
	)
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

const resReader = async (res: Response): Promise<BufReader> =>
	new BufReader(Buffer.from(await res.arrayBuffer()))

export async function ownersOne(
	f: Fetch,
	i: CanOwnOne // endif
): ReturnValue<OwnersOne> {
	const res = await request(f, "ownersOne", SerialiseItem(i))
	if (res.status !== 200) return { ok: false }

	return { ok: true, value: OwnersOne.Deserialise(await resReader(res)) }
}

export async function ownersMany(
	f: Fetch,
	i: CanOwnMany
): ReturnValue<OwnersMany> {
	const res = await request(f, "ownersMany", SerialiseItem(i))
	if (res.status !== 200) return { ok: false }

	return { ok: true, value: OwnersMany.Deserialise(await resReader(res)) }
}

export async function inventory(f: Fetch, o: Owner): ReturnValue<Items> {
	const res = await request(f, "inventory", SerialiseItem(o))
	if (res.status !== 200) return { ok: false }

	return { ok: true, value: Items.Deserialise(await resReader(res)) }
}

export async function balance(f: Fetch, o: Owner): ReturnValue<number> {
	const res = await request(f, "balance", SerialiseItem(o))
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

export async function stipend(f: Fetch, o: Owner): Promise<boolean> {
	const res = await request(f, "stipend", SerialiseItem(o))

	return res.status === 204 || res.status === 429
}

const resToItem = async (res: Response): Promise<Item | null> =>
	Item.Deserialise(await resReader(res))

export async function createLimitedSource(
	f: Fetch,
	u: User
): ReturnValue<LimitedSource> {
	const res = await request(f, "createLimitedSource", SerialiseItem(u))
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof LimitedSource))
		throw new Error(`item is not LimitedSource: ${i}`)

	return { ok: true, value: i }
}

export async function createUnlimitedSource(
	f: Fetch,
	u: User
): ReturnValue<UnlimitedSource> {
	const res = await request(f, "createUnlimitedSource", SerialiseItem(u))
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof UnlimitedSource))
		throw new Error(`item is not UnlimitedSource: ${i}`)

	return { ok: true, value: i }
}

export async function createPlace(f: Fetch, u: User): ReturnValue<Place> {
	const res = await request(f, "createPlace", SerialiseItem(u))
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof Place)) throw new Error(`item is not Place: ${i}`)

	return { ok: true, value: i }
}

export async function createGroup(f: Fetch, u: User): ReturnValue<Group> {
	const res = await request(f, "createGroup", SerialiseItem(u))
	if (res.status !== 200) return { ok: false }

	const i = await resToItem(res)
	if (!(i instanceof Group)) throw new Error(`item is not Group: ${i}`)

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
		Buffer.concat([
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
		Buffer.concat([
			SerialiseItem(u),
			SerialiseItem(src),
			SerialiseUint64(priceEach),
			SerialiseUint64(qty),
		])
	).then(res => res.status === 204)

async function getHistory(
	f: Fetch,
	body: Buffer
): ReturnValue<TransferWithID[]> {
	const res = await request(f, "history", body)
	if (res.status !== 200) return { ok: false }

	const buf = Buffer.from(await res.arrayBuffer())
	const r = new BufReader(buf)

	const transfers: TransferWithID[] = []

	while (!r.end()) {
		const t = TransferWithID.Deserialise(r)
		if (t === null) break
		transfers.push(t)
	}

	return { ok: true, value: transfers }
}

export const history = (f: Fetch, n: number /* the only good thing about rust */): ReturnValue<TransferWithID[]> =>
	getHistory(f, SerialiseUint32(n))

export const historyOwner = (f: Fetch, n: number, o: Owner) =>
	getHistory(f, Buffer.concat([SerialiseUint32(n), SerialiseItem(o)]))
