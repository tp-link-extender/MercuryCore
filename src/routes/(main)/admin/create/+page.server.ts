import { authorise } from "$lib/server/lucia"
import { superValidate } from "sveltekit-superforms/server"
import { query, surql } from "$lib/server/surreal"
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

async function getVersions(id: number) {
	const versions: Asset[] = []

	const transformVersions = (vs: Asset[], cached = false) => ({
		cached,
		list: vs.map(v => [
			v.id[1].toString(),
			`${v.id[1]} - ${v.assetModified.substring(0, 10)}`, // docsocial type beat
		]),
	})

	// Badass caching system
	// todo make it invalidatable cuz if you want a version of the asset later than when cached, good luck lmao
	const cache = await query<Asset>(
		surql`
			SELECT
				meta::id(id) AS id,
				assetModified
			FROM assetCache:[$id, 0]..[$id, 99]`, // idk if it's worth getting more versions
		{ id }
	)

	if (cache.length > 0) {
		console.log("Got cached asset versions of", id)
		return transformVersions(cache, true)
	}

	console.log("No cached asset versions of", id, "fetching...")

	// Get asset versions
	// ported directly from polygon (real polygon, not polygon-foss lmao)
	for (let v = 1; ; v++) {
		console.log("Fetching asset version", v, "of", id)
		const data = await fetch(
			`https://assetdelivery.roblox.com/v1/asset/?id=${id}&version=${v}`,
			{ headers: { "User-Agent": "Roblox/WinInet" } }
		)

		if (data.status === 500) continue
		if (data.status !== 200) break

		// no need for a goofy ahh php loop
		const date = data.headers.get("last-modified")
		if (!date) break

		// Welp
		// this is because newer asset versions (rbxl) are binary, and contain data that causes the query to hang
		const b64 = Buffer.from(await data.text()).toString("base64")

		versions.push({
			id: [id, v],
			data: b64,
			assetModified: new Date(date).toISOString(),
		})
	}

	await query(
		surql`
			FOR $version IN $versions {
				# can't do assetCache:$version.id or :($version.id) for some reason
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

export async function load({ locals, url }) {
	await authorise(locals, 5)
	const assetId = url.searchParams.get("assetId") || undefined
	if (assetId && !assetId.match(/\d+/)) error(400, "Invalid assetId")

	const stage = url.searchParams.get("assetId")?.match(/\d+/)
		? url.searchParams.has("version")
			? 3
			: 2
		: 1

	return {
		formManual: await superValidate(zod(schemaManual)),
		formAuto: await superValidate(zod(schemaAuto)),
		stage,
		...(stage === 2 && assetId
			? { assetId, getVersions: getVersions(parseInt(assetId)) }
			: {}),
	}
}
