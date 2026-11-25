import config from "#lib/server/config.ts"
import { ORBITER_KEY } from "$app/env/private"
import type { ReturnErr, ReturnValue } from "./economy"

interface Gameserver {
	pid: number
	startTime: number
}

type GameserverId = [number, Gameserver]

const bearer = (): HeadersInit => ({ Authorization: `Bearer ${ORBITER_KEY}` })

/**
 * The message in an Orbiter error response: its JSON `error` field, or the raw body if it isn't JSON.
 * @param res The failed response.
 */
export async function errorMessage(res: Response): Promise<string> {
	const body = await res.text()
	try {
		const parsed: unknown = JSON.parse(body)
		if (
			parsed &&
			typeof parsed === "object" &&
			"error" in parsed &&
			typeof parsed.error === "string"
		)
			return parsed.error
	} catch {
		return body
	}
	return body
}

export async function listGameservers(
	f: typeof globalThis.fetch
): ReturnValue<GameserverId[]> {
	try {
		const res = await f(`${config.Orbiter.PrivateURL}/gameservers`, {
			headers: bearer(),
		})
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
	path: string,
	method: string
): Promise<ReturnErr> {
	try {
		const res = await f(`${config.Orbiter.PrivateURL}/${path}`, {
			headers: bearer(),
			method,
		})
		if (!res.ok) return { msg: await errorMessage(res), ok: false }
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
		`gameserver/${placeId}?engine=${clientVersion >= 2016 ? "rcc" : "studio"}`,
		"PUT"
	)

export const closeGameserver = (f: typeof globalThis.fetch, placeId: number) =>
	fetchGameserver(f, `gameserver/${placeId}`, "DELETE")

/**
 * Sends a render loadscript to the Orbiter. Resolves once the Orbiter has accepted it.
 * @param f The fetch to use.
 * @param renderId The id of the render record, which the Orbiter reports back with.
 * @param script The render loadscript, with its ping URL filled in.
 */
export async function submitRender(
	f: typeof globalThis.fetch,
	renderId: string,
	script: string
): Promise<void> {
	const res = await f(`${config.Orbiter.PrivateURL}/render/${renderId}`, {
		body: script,
		headers: bearer(),
		method: "POST",
	})
	if (!res.ok)
		throw new Error(
			`Orbiter refused render ${renderId}: ${await errorMessage(res)}`
		)
}
