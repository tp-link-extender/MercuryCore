import config from "$lib/server/config"
import type { ReturnErr, ReturnValue } from "./economy"

interface Gameserver {
	pid: number
	startTime: number
}

type GameserverId = [number, Gameserver]

export async function listGameservers(
	f: typeof globalThis.fetch
): ReturnValue<GameserverId[]> {
	try {
		const res = await f(config.Orbiter.PrivateURL)
		if (!res.ok) return { ok: false }
		// the gameserver API is trusted and its shape is verified on the other side
		// oxlint-disable-next-line typescript/no-unsafe-assignment
		return { ok: true, value: await res.json() }
	} catch {
		return { ok: false }
	}
}

async function fetchGameserver(
	f: typeof globalThis.fetch,
	path: string | number,
	method: string
): Promise<ReturnErr> {
	try {
		const res = await f(`${config.Orbiter.PrivateURL}/${path}`, { method })
		if (!res.ok) return { msg: await res.text(), ok: false }
	} catch (err) {
		return {
			msg: err instanceof Error ? err.message : String(err),
			ok: false,
		}
	}
	return { ok: true }
}

export const startGameserver = (
	f: typeof globalThis.fetch,
	placeId: number,
	clientVersion: number
) =>
	fetchGameserver(
		f,
		`${placeId}?engine=${clientVersion >= 2016 ? "rcc" : "studio"}`,
		"put"
	)

export const closeGameserver = (f: typeof globalThis.fetch, placeId: number) =>
	fetchGameserver(f, placeId, "delete")
