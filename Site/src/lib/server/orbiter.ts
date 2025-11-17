import config from "$lib/server/config"
import type { ReturnErr, ReturnValue } from "./economy"

type Gameserver = {
	pid: number
	startTime: number
}

type GameserverId = [number, Gameserver]

export async function listGameservers(): ReturnValue<GameserverId[]> {
	try {
		const res = await fetch(config.OrbiterPrivateURL)
		if (!res.ok) return { ok: false }
		return { ok: true, value: await res.json() }
	} catch {
		return { ok: false }
	}
}

async function fetchGameserver(
	path: string | number,
	method: string
): Promise<ReturnErr> {
	try {
		const res = await fetch(`${config.OrbiterPrivateURL}/${path}`, { method })
		if (!res.ok) return { ok: false, msg: await res.text() }
	} catch (err) {
		const e = err as Error
		return { ok: false, msg: e.message }
	}
	return { ok: true }
}

export const startGameserver = async (placeId: number) =>
	fetchGameserver(placeId, "put")

export const closeGameserver = async (placeId: number) =>
	fetchGameserver(placeId, "delete")
