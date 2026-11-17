import { createHash } from "node:crypto"
import { rename, statfs } from "node:fs/promises"
import { error } from "@sveltejs/kit"
import { OPEN_CLOUD_KEY } from "$env/static/private"
import { intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { FixedWindow } from "$lib/server/fixedWindow"
import { readLimited, TooLargeError } from "$lib/server/readLimited"
import { db, Record } from "$lib/server/surreal"
import { isXML } from "$lib/server/xml"
import { substituteRobloxAssetUrls } from "$lib/server/xmlTemplate"
import type { RequestEvent } from "./$types"
import assetQuery from "./asset.surql"

const headers = (file: string | Uint8Array) => ({
	"Content-Disposition": `attachment; filename="${createHash("md5")
		.update(file)
		.digest("hex")}"`,
	"Content-Type": "binary/octet-stream",
})

const response = (file: string | Uint8Array<ArrayBuffer>) =>
	new Response(file, { headers: headers(file) })

const isAssetDelivery = (value: unknown): value is { location: string } =>
	typeof value === "object" &&
	value !== null &&
	"location" in value &&
	typeof value.location === "string"

interface FoundAsset {
	id: number
	name: string
	visibility: string
}

// Only substitute if it's an XML file (re-encoding image files tends to corrupt them)
async function substituteURLs(file: Bun.BunFile | Response) {
	const buf = await file.arrayBuffer()
	if (!isXML(buf)) return new Uint8Array(buf)

	const rep = `${config.Domain}/asset`
	return substituteRobloxAssetUrls(new TextDecoder().decode(buf), rep)
}

async function loadPrivilegedAsset(id: number) {
	const file = Bun.file(`../data/server/assets/${id}`)
	if (!(await file.exists())) return

	// Privileged assets don't need their URLs substituted

	console.log("Serving privileged", id)
	return response(new Uint8Array(await file.arrayBuffer()))
}

async function loadUserAsset(id: number) {
	const file = Bun.file(`../data/assets/${id}`)
	if (!(await file.exists())) return

	const [[asset]] = await db.query<FoundAsset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset || asset.visibility === "Moderated") return

	// The asset is visible or pending
	// (allow pending assets to be shown through the api)
	const script = await substituteURLs(file)

	console.log("Serving user", id)
	return response(script)
}

// Limits for assets that aren't cached yet, as each one costs Open Cloud quota and disk space. Cached assets aren't limited.
const maxAssetSize = 50 * 1024 * 1024
// New assets aren't cached once free disk space drops below this, so the cache can't fill the disk
const minFreeSpace = 5 * 1024 * 1024 * 1024
// A gameserver loads every asset in a place from one address, so this is generous
const perAddress = Object.freeze({ max: 300, windowMs: 60_000 })
// Across every address, so the quota can't be spent by spreading requests over many addresses
const overall = Object.freeze({ max: 600, windowMs: 60_000 })
const fetchWindows = new FixedWindow()
// Fetches in progress, so many requests for the same new asset share one fetch
const inFlight = new Map<
	number,
	Promise<Uint8Array<ArrayBuffer> | string | undefined>
>()

// Place files are deliberately not served here, as this route is unauthenticated. Gameservers load places through /game/[id], which checks the server ticket, gameserver key, ownership, or private ticket.

async function hasFreeSpace(): Promise<boolean> {
	try {
		const { bavail, bsize } = await statfs("../data")
		return bavail * bsize >= minFreeSpace
	} catch {
		return false
	}
}

async function fetchOpenCloudAsset(
	f: typeof globalThis.fetch,
	id: number,
	cachepath: string
) {
	const req = await f(
		`https://apis.roblox.com/asset-delivery-api/v1/assetId/${id}`,
		{ headers: { "X-API-Key": OPEN_CLOUD_KEY } }
	)
	if (!req.ok) return

	const json: unknown = await req.json()
	if (!isAssetDelivery(json)) return
	const { location } = json
	if (!location) return

	const res = await f(location)
	if (!res.ok) return

	const body = await readLimited(res, maxAssetSize)
	const script = await substituteURLs(new Response(body))
	if (!(await hasFreeSpace())) {
		console.error(
			`Not caching Open Cloud asset ${id}: less than ${minFreeSpace} bytes of disk space free`
		)
		return script
	}
	// Written whole to a temporary file first, so a failed write never leaves a partial asset in the cache
	const temp = `${cachepath}.${crypto.randomUUID()}.tmp`
	await Bun.write(temp, script)
	await rename(temp, cachepath)
	return script
}

async function loadOpenCloudAsset(
	f: typeof globalThis.fetch,
	id: number,
	address: string
) {
	const cachepath = `../data/assetcache/${id}`
	const file = Bun.file(cachepath)
	if (await file.exists()) {
		console.log("Serving cached Open Cloud", id)
		return response(new Uint8Array(await file.arrayBuffer()))
	}

	let pending = inFlight.get(id)
	if (!pending) {
		const now = Date.now()
		if (
			!fetchWindows.hit(
				address,
				perAddress.windowMs,
				perAddress.max,
				now
			) ||
			!fetchWindows.hit("\0overall", overall.windowMs, overall.max, now)
		)
			error(429, "Too many requests")

		pending = fetchOpenCloudAsset(f, id, cachepath).finally(() =>
			inFlight.delete(id)
		)
		inFlight.set(id, pending)
	}

	try {
		const script = await pending
		if (!script) return

		console.log("Serving Open Cloud", id)
		return response(script)
	} catch (e) {
		if (e instanceof TooLargeError) {
			console.error(`Open Cloud asset ${id} is too large`)
			error(413, "Asset is too large")
		}
		console.error(e)
		error(500, "Failed to fetch Open Cloud asset")
	}
}

export async function GET({ fetch: f, getClientAddress, url }: RequestEvent) {
	const assetId = url.searchParams.get("id")
	if (!assetId || !intRegex.test(assetId)) error(400, "Invalid Request")

	// all asset ids are now numbered
	const id = Number(assetId)
	console.log("Requested asset", id)

	const result1 = await loadPrivilegedAsset(id)
	if (result1) return result1

	// Try loading as a user asset
	const result2 = await loadUserAsset(id)
	if (result2) return result2

	// Fails closed into one shared bucket when the address can't be determined, as ratelimit() does
	let address = "unknown"
	try {
		address = getClientAddress()
	} catch {}

	const result3 = await loadOpenCloudAsset(f, id, address)
	if (result3) return result3

	error(404, "Not Found")
}
