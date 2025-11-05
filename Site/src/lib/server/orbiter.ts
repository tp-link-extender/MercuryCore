import type { ReturnErr, ReturnValue } from "./economy"

const orbiterUrl = "http://localhost:64991"

type Gameserver = {
	pid: number
	startTime: number
}

type GameserverId = [number, Gameserver]

export async function listGameservers(): ReturnValue<GameserverId[]> {
	try {
		const res = await fetch(orbiterUrl)
		if (!res.ok) return { ok: false }
		return { ok: true, value: await res.json() }
	} catch {
		return { ok: false }
	}
}

export async function getGameserver(placeId: number): ReturnValue<Gameserver> {
	try {
		const res = await fetch(`${orbiterUrl}/${placeId}`)
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
		const res = await fetch(`${orbiterUrl}/${path}`, { method })
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
