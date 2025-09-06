import fs from "node:fs"
import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { intRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import requestRender from "$lib/server/requestRender"
import { db } from "$lib/server/surreal"
import createAutopilotQuery from "./createAutopilot.surql"
import getVersionsQuery from "./getVersions.surql"
import sharedAssetsCacheQuery from "./sharedAssetsCache.surql"
import typeQuery from "./type.surql"

// TODO: port ALL of this to Open Cloud (https://create.roblox.com/docs/cloud/features/assets#/default/Assets_GetAsset)

const schemaManual = type({
	type: "8 | 18",
	name: "3 <= string <= 50",
	description: "(string <= 1000) | undefined",
	price: "string.numeric <= 999",
	asset: "unknown",
})
const schemaAuto = type({
	assetId: "number.integer",
	version: "number.integer",
	name: "3 <= string <= 50",
	description: "(string <= 1000) | undefined",
	price: "number.integer <= 999",
	shared: "string",
})

type Asset = {
	id: [number, number]
	// Watch out for inconsistencies in date formatting between API and DB
	// This should be safe, for now...
	assetModified: string
	name: string
	description: string
	type: number
}

// Ghoofy ass function names
const transformVersions = (vs: Asset[], cached = false) => ({
	cached,
	list: vs.map(v => [
		v.id[1].toString(),
		`${v.id[1]} – ${v.assetModified.substring(0, 10)}`, // docsocial type beat
	]),
})

const hatType = (type: number) => type > 41 && type < 47

const metadataFields = (meta: any) => ({
	name: meta.Name,
	description: meta.Description,
	type: meta.AssetTypeId,
})

async function getMetadata(id: number) {
	const cachePath = `../data/assetCache/${id}_meta`
	const cachedMeta = await Bun.file(cachePath)
	if (await cachedMeta.exists()) {
		console.log("Using cached metadata for", id)
		return metadataFields(await cachedMeta.json())
	}

	const res = await fetch(
		`https://economy.roblox.com/v2/assets/${id}/details`
	)

	if (res.status !== 200) {
		console.log("Failed to fetch metadata for", id)

		if (res.status === 429) {
			console.log("Ratelimited, waiting...")
			await new Promise(r => setTimeout(r, 30e3)) // usually takes 2 or 3 goes
			return getMetadata(id)
		}

		return {
			name: null,
			description: null,
			type: null,
		}
	}

	// prevents fetching metadata multiple times, or saves in the event that the metadata fetching fails for some later version
	await Bun.write(cachePath, await res.clone().arrayBuffer())

	return metadataFields(await res.json())
}

async function fetchAssetVersion(id: number, version: number) {
	console.log("Fetching asset version", version, "of", id)

	let data: Response
	while (true)
		try {
			data = await fetch(
				`https://assetdelivery.roblox.com/v1/asset/?id=${id}&version=${version}`,
				{ headers: { "user-agent": "Roblox/WinInet" } }
			)
			break
		} catch {
			console.log("Ratelimited, waiting 30 seconds...") // polygon type beat
			await new Promise(r => setTimeout(r, 30e3))
		}

	if (data.status === 500) return "skip" // atoms (or enums..) would be nice right about now
	if (data.status !== 200) return "done"

	// no need for a goofy ahh php loop
	const date = data.headers.get("last-modified")
	if (!date) return "done"

	console.log("metadata getting")

	if (!fs.existsSync("../data/assetCache")) fs.mkdirSync("../data/assetCache")

	const { name, description, type } = await getMetadata(id)

	// write the data to a file
	// After all, they give the data in the response anyway. Why shouldn't I cache it?
	await Bun.write(
		`../data/assetCache/${id}_${version}`,
		Buffer.from(await data.arrayBuffer()).toString() // todo: needed?
	)

	return {
		id: [id, version], // typescript moment
		assetModified: new Date(date).toISOString(),
		name,
		description,
		type: hatType(type) ? 8 : type,
	} as Asset
}

async function getVersions(id: number, version?: number) {
	const versions: Asset[] = []

	// Badass caching system
	// todo make it invalidatable cuz if you want a version of the asset later than when cached, good luck lmao
	const [cache] = await db.query<Asset[][]>(
		`
			SELECT record::id(id) AS id, assetModified
			FROM assetCache:${version ? "[$id, $version]" : "[$id, 0]..[$id, 99]"}`, // idk if it's worth getting more versions
		{ id, version }
	)

	if (cache.length > 0) return transformVersions(cache, true)

	console.log("No cached asset versions of", id, "fetching...")

	// Get asset versions
	// ported directly from polygon (real polygon, not polygon-foss lmao)
	if (version) {
		const fetched = await fetchAssetVersion(id, version)
		if (typeof fetched === "string") return { cached: false, list: [] }
		versions.push(fetched)
	} else
		for (let v = 1; ; v++) {
			const fetched = await fetchAssetVersion(id, v)
			if (fetched === "skip") continue
			if (fetched === "done") break
			versions.push(fetched)
		}

	console.log("CACHE", versions)

	await db.query(getVersionsQuery, { versions })
	return transformVersions(versions)
}

const assetIdRegex = /(\d+)$/

async function getSharedAssets(id: number, version: number) {
	const [[cache]] = await db.query<
		{
			id: [number, number]
			assetModified: string
		}[][]
	>(sharedAssetsCacheQuery, { id, version })
	if (!cache) return []

	const dependencies: string[] = []

	let cachedData: string
	try {
		cachedData = await Bun.file(
			`../data/assetCache/${id}_${version}`
		).text()
		if (!cachedData.startsWith("<roblox ")) return []
	} catch {
		return []
	}

	console.log("getting dependencies")
	for (const [, url] of cachedData.matchAll(/<url>(.+)<\/url>/g)) {
		const id = url.match(assetIdRegex)?.[0]
		console.log("match id", id)
		if (!id) continue // shouldn't happen, let's just ignore it
		dependencies.push(id)

		// Cache dat sheeeit
		await getVersions(+id, 1) // Always cache version 1 as it's usually the only version for dependency assets

		// "why would a shared asset have dependencies
		// like a mesh doesn't have any dependencies
		// in what scenario would a shared asset have dependencies?"
		// - Taskmanager, 21 March 2024
		// ^^ Probably correct but I'm putting this here anyway (also it halves the number of database queries we have to do)
	}
	return dependencies
}

async function getType(id: number) {
	const [[type]] = await db.query<{ type: number }[][]>(typeQuery, { id })
	return type
}

export async function load({ locals, url }) {
	await authorise(locals, 3)
	const assetId = url.searchParams.get("assetId")
	const version = url.searchParams.get("version")
	if (assetId && !intRegex.test(assetId)) error(400, "Invalid assetId")
	if (version && !intRegex.test(version)) error(400, "Invalid version")

	const stage = assetId ? (version ? 3 : 2) : 1
	return {
		formManual: await superValidate(arktype(schemaManual)),
		formAuto: await superValidate(arktype(schemaAuto)),
		stage,
		...(stage === 2 &&
			assetId && {
				assetId,
				getVersions: getVersions(+assetId),
			}),
		...(stage === 3 &&
			assetId &&
			version && {
				assetId,
				version,
				getSharedAssets: getSharedAssets(+assetId, +version),
			}),
		...(stage >= 2 && assetId && { type: await getType(+assetId) }),
	}
}

export const actions: import("./$types").Actions = {}
const intRegex2 = /\d+/
actions.autopilot = async ({ locals, request }) => {
	await authorise(locals, 3)
	const form = await superValidate(request, arktype(schemaAuto))
	if (!form.valid) return formError(form)

	const { data } = form

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	const res = await db.query(createAutopilotQuery, {
		assets: data.shared.split(",").map(s => +s),
		...data,
	})

	const { id, type } = res[6] as {
		id: string
		type: number
	}
	const shared = res[7] as {
		id: string // todo: check
		type: number
		sharedId: number
	}[]

	const path = `../data/assetCache/${data.assetId}_${data.version}`
	let cachedXml = await Bun.file(path).text()

	// Replace the shared asset URLs with the new asset IDs
	for (const exec of cachedXml.matchAll(/(<url>.+<\/url>)/g)) {
		const url = exec[1]
		const id = url.match(intRegex2)?.[0]
		if (!id) continue // shouldn't happen, let's just ignore it

		const newId = shared.find(s => s.sharedId === +id)?.id
		if (!newId) continue // same as above

		const rep = `<url>${config.Domain}/asset?id=${newId}</url>`
		cachedXml = cachedXml.replace(url, rep)
	}

	await Promise.all([
		Bun.write(`../data/assets/${id}`, cachedXml),
		...shared.map(s =>
			// idiomatic much
			Bun.write(
				`../data/assets/${s.id}`,
				Bun.file(`../data/assetCache/${s.sharedId}_1`)
			)
		),
	])

	const renders: (Promise<void> | Promise<number>)[] = []

	if (type === 18) {
		const imageAsset = shared.find(s => s.type === 1)?.id
		if (imageAsset)
			// we want to move the imageasset from assets to thumbnails (don't render it)
			renders.push(
				Bun.write(
					`../data/thumbnails/${id}`,
					Bun.file(`../data/assets/${imageAsset}`)
				)
			)
	} else {
		renders.push(requestRender("Model", id))
		const renderMesh = shared.find(s => s.type === 4)?.id
		if (renderMesh) renders.push(requestRender("Mesh", renderMesh))
	}
	await Promise.all(renders)
	redirect(302, `/catalog/${id}`)
}
