import { authorise } from "$lib/server/lucia"
import { superValidate } from "sveltekit-superforms/server"
import { query, squery, surql } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import { error } from "@sveltejs/kit"

const schemaManual = z.object({
	type: z.enum(["8", "18"]),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})
const schemaAuto = z.object({
	type: z.enum(["8"]),
	id: z.number(),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
})

type Asset = {
	id: [number, number]
	data: string
	// Watch out for inconsistencies in date formatting between API and DB
	// This should be safe, for now...
	assetModified: string
}

// Ghoofy ass function names
const transformVersions = (vs: Asset[], cached = false, getData = false) => ({
	cached,
	...(getData && { data: vs.map(v => v.data) }),
	list: vs.map(v => [
		v.id[1].toString(),
		`${v.id[1]} - ${v.assetModified.substring(0, 10)}`, // docsocial type beat
	]),
})

async function fetchAssetVersion(id: number, version: number) {
	console.log("Fetching asset version", version, "of", id)
	const data = await fetch(
		`https://assetdelivery.roblox.com/v1/asset/?id=${id}&version=${version}`,
		{ headers: { "user-agent": "Roblox/WinInet" } }
	)

	if (data.status === 500) return "skip" // atoms would be nice right about now
	if (data.status !== 200) return "done"

	// no need for a goofy ahh php loop
	const date = data.headers.get("last-modified")
	if (!date) return "done"

	// Welp
	// this is because newer asset versions (rbxl) are binary, and contain data that causes the query to hang
	// After all, they give the data in the response anyway. Why shouldn't I cache it?
	const b64 = Buffer.from(await data.text()).toString("base64")

	return {
		id: [id, version] as [number, number], // typescript moment
		data: b64,
		assetModified: new Date(date).toISOString(),
	}
}

async function getVersions(id: number, version?: number) {
	const versions: Asset[] = []

	// Badass caching system
	// todo make it invalidatable cuz if you want a version of the asset later than when cached, good luck lmao
	const cache = await query<Asset>(
		surql`
			SELECT meta::id(id) AS id, assetModified
			FROM assetCache:${
				version ? "[$id, $version]" : "[$id, 0]..[$id, 99]"
			}`, // idk if it's worth getting more versions
		{ id, version }
	)

	if (cache.length > 0) {
		console.log("Got cached asset versions of", id)
		return transformVersions(cache, true)
	}

	console.log("No cached asset versions of", id, "fetching...")

	// Get asset versions
	// ported directly from polygon (real polygon, not polygon-foss lmao)
	if (version) {
		const fetched = await fetchAssetVersion(id, version)
		if (typeof fetched === "string")
			return {
				cached: false,
				list: [],
			}
		versions.push(fetched)
	} else
		for (let v = 1; ; v++) {
			const fetched = await fetchAssetVersion(id, v)

			if (fetched === "skip") continue
			if (fetched === "done") break

			versions.push(fetched)
		}

	await query(
		surql`
			FOR $version IN $versions {
				# can't do assetCache:$version.id or :($version.id) for some reason
				# array record ids still hella useful though
				UPDATE assetCache:[$version.id[0], $version.id[1]] CONTENT {
					created: time::now(),
					data: $version.data,
					# what on earth do I name this field?
					# cache invalidation AND naming things in the same query?
					assetModified: $version.assetModified,
				}
			}`,
		{ versions }
	)

	console.log("RETURNING", versions.length, "versions of", id)
	return transformVersions(versions)
}

// Watch out nerds: if there's a lot of shared assets, this will be SLOOOOW
async function getXmlDependencies(data: string, version: number) {
	const dependencies: number[] = []

	const xml = Buffer.from(data, "base64").toString()
	for (const [, url] of xml.matchAll(/<url>(.+)<\/url>/g)) {
		const id = url.match(/\d+/)?.[0]
		if (!id) continue // shouldn't happen, let's just ignore it
		console.log("Fetching shared asset", id)
		dependencies.push(+id)

		const data = (await getVersions(+id, version)).data?.[0]
		if (!data) continue

		console.log("Getting nested dependencies of", id)

		const nested = await getXmlDependencies(data, version)
		console.log(nested)
		dependencies.push(...nested)
	}

	console.log("Dependencies of", version, "are", dependencies)

	return dependencies
}

async function getSharedAssets(id: number, version: number) {
	const cache = await squery<Asset>(
		surql`
			SELECT meta::id(id) AS id, assetModified, data
			FROM assetCache:[$id, $version]`,
		{ id, version }
	)

	return cache ? await getXmlDependencies(cache.data, version) : []
}

export async function load({ locals, url }) {
	await authorise(locals, 5)
	const assetId = url.searchParams.get("assetId")
	if (assetId && !assetId.match(/\d+/)) error(400, "Invalid assetId")
	const version = url.searchParams.get("version")
	if (version && !version.match(/\d+/)) error(400, "Invalid version")

	const stage = assetId ? (version ? 3 : 2) : 1

	return {
		formManual: await superValidate(zod(schemaManual)),
		formAuto: await superValidate(zod(schemaAuto)),
		stage,
		...(stage === 2 &&
			assetId && { assetId, getVersions: getVersions(+assetId) }),
		...(stage === 3 &&
			assetId &&
			version && {
				assetId,
				version,
				getSharedAssets: getSharedAssets(+assetId, +version),
			}),
	}
}
