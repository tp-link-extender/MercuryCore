import { SerialiseItem } from "./items"
import type { Owner } from "./types"

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

const request = (route: Route, body: Bun.BodyInit): Promise<Response> =>
	fetch(`${url}/${route}`, {
		method: "POST",
		body,
	})

export async function ownsOne(o: Owner): Promise<ReturnValue<boolean>> {
	const os = SerialiseItem(o)
	const res = await request("ownsOne", os)
	if (res.status !== 200)
		// it won't be another 2xx status code
		return { ok: false }

	const buf = await res.arrayBuffer()
	const view = new DataView(buf)
	return { ok: true, value: view.getUint8(0) === 1 }
}
