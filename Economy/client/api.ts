import { OwnersMany, OwnersOne } from "./economy"
import { BufReader, Items, SerialiseItem } from "./items"
import type { CanOwnMany, CanOwnOne, Owner } from "./types"

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

const url = "http://localhost:2009"

export type ReturnValue<T> = Promise<{ ok: true; value: T } | { ok: false }>
export type ReturnErr = { ok: true } | { ok: false; msg: string }

export const request = (route: Route, body: Buffer): Promise<Response> =>
	fetch(`${url}/${route}`, {
		method: "POST",
		body: Uint8Array.from(body),
	})

export async function ownsOne(o: Owner, i: CanOwnOne): ReturnValue<boolean> {
	const body = Buffer.concat([SerialiseItem(o), SerialiseItem(i)])
	const res = await request("ownsOne", body)
	if (res.status !== 200) return { ok: false } // it won't be another 2xx status code

	const buf = await res.arrayBuffer()
	const view = new DataView(buf)
	return { ok: true, value: view.getUint8(0) === 1 }
}

export async function ownsMany(o: Owner, i: CanOwnMany): ReturnValue<number> {
	const body = Buffer.concat([SerialiseItem(o), SerialiseItem(i)])
	const res = await request("ownsMany", body)
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

export async function ownersOne(i: CanOwnOne): ReturnValue<OwnersOne> {
	const body = SerialiseItem(i)
	const res = await request("ownersOne", body)
	if (res.status !== 200) return { ok: false }

	const buf = Buffer.from(await res.arrayBuffer())
	const r = new BufReader(buf)

	return { ok: true, value: OwnersOne.Deserialise(r) }
}

export async function ownersMany(i: CanOwnMany): ReturnValue<OwnersMany> {
	const body = SerialiseItem(i)
	const res = await request("ownersMany", body)
	if (res.status !== 200) return { ok: false }

	const buf = Buffer.from(await res.arrayBuffer())
	const r = new BufReader(buf)

	return { ok: true, value: OwnersMany.Deserialise(r) }
}

export async function inventory(o: Owner): ReturnValue<Items> {
	const body = SerialiseItem(o)
	const res = await request("inventory", body)
	if (res.status !== 200) return { ok: false }

	const buf = Buffer.from(await res.arrayBuffer())
	const r = new BufReader(buf)

	return { ok: true, value: Items.Deserialise(r) }
}

export async function balance(o: Owner): ReturnValue<number> {
	const body = SerialiseItem(o)
	const res = await request("inventory", body)
	if (res.status !== 200) return { ok: false }

	const text = await res.text()
	return { ok: true, value: +text }
}

export async function stipend(o: Owner): Promise<boolean> {
	const body = SerialiseItem(o)
	const res = await request("inventory", body)

	return res.status === 200 || res.status === 429
}
