import type { ReturnValue } from "./economy"

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
