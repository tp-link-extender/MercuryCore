import { authorise } from "$lib/server/lucia"
import { superValidate } from "sveltekit-superforms/server"
import { query, squery, mquery, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import requestRender from "$lib/server/requestRender"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import { error, redirect } from "@sveltejs/kit"
import fs from "node:fs"
import "dotenv/config"

const schemaManual = z.object({
	type: z.enum(["8", "18"]),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})
const schemaAuto = z.object({
	assetId: z.number().int(),
	version: z.number().int(),
	name: z.string().min(3).max(50),
	description: z.string().max(1000).optional(),
	price: z.number().int().min(0).max(999),
	shared: z.string(),
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
		`${v.id[1]} - ${v.assetModified.substring(0, 10)}`, // docsocial type beat
	]),
})

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

	console.log("api getting")

	const meta: {
		Name: string
		Description: string
		AssetTypeId: number
	} = await (
		await fetch(`https://economy.roblox.com/v2/assets/${id}/details`)
	).json()

	if (!fs.existsSync("data/assetCache")) fs.mkdirSync("data/assetCache")

	// write the data to a file
	// After all, they give the data in the response anyway. Why shouldn't I cache it?
	fs.writeFileSync(
		`data/assetCache/${id}_${version}`,
		Buffer.from(await data.arrayBuffer())
	)

	const type = meta.AssetTypeId

	return {
		id: [id, version] as [number, number], // typescript moment
		assetModified: new Date(date).toISOString(),
		name: meta.Name,
		description: meta.Description,
		type: 41 < type && type < 47 ? 8 : type,
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

	if (cache.length > 0) return transformVersions(cache, true)

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
					# what on earth do I name this field?
					# cache invalidation AND naming things in the same query?
					assetModified: $version.assetModified,
					name: $version.name,
					description: $version.description,
					type: $version.type,
				}
			}`,
		{ versions }
	)

	return transformVersions(versions)
}

async function getSharedAssets(id: number, version: number) {
	const cache = await squery<{
		id: [number, number]
		assetModified: string
	}>(
		surql`
			SELECT meta::id(id) AS id, assetModified
			FROM assetCache:[$id, $version]`,
		{ id, version }
	)

	if (!cache) return []

	const dependencies: string[] = []

	let cachedData: string
	try {
		cachedData = fs.readFileSync(
			`data/assetCache/${id}_${version}`,
			"utf-8"
		)
		console.log("cached data", cachedData.startsWith("<roblox "))
		if (!cachedData.startsWith("<roblox ")) return []
	} catch {
		return []
	}

	for (const [, url] of cachedData.matchAll(/<url>(.+)<\/url>/g)) {
		const id = url.match(/\d+/)?.[0]
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

export async function load({ locals, url }) {
	await authorise(locals, 3)
	const assetId = url.searchParams.get("assetId")
	const version = url.searchParams.get("version")
	if (assetId && !assetId.match(/\d+/)) error(400, "Invalid assetId")
	if (version && !version.match(/\d+/)) error(400, "Invalid version")

	const stage = assetId ? (version ? 3 : 2) : 1

	return {
		formManual: await superValidate(zod(schemaManual)),
		formAuto: await superValidate(zod(schemaAuto)),
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
		...(stage >= 2 &&
			assetId && {
				type: (
					await squery<{ type: number }>(
						surql`SELECT type FROM assetCache:[$id, 0]..[$id, 99]`, // gud enogh
						{ id: +assetId }
					)
				)?.type,
			}),
	}
}

export const actions = {
	autopilot: async ({ request, locals }) => {
		await authorise(locals, 3)
		const form = await superValidate(request, zod(schemaAuto))
		if (!form.valid) return formError(form)
		const { data } = form

		if (!fs.existsSync("data/assets")) fs.mkdirSync("data/assets")
		if (!fs.existsSync("data/thumbnails")) fs.mkdirSync("data/thumbnails")

		const res = await mquery<unknown[]>(
			surql`
				BEGIN TRANSACTION;
				LET $user = (SELECT id FROM user WHERE number = 1)[0].id;
				FOR $assetId IN $assets {
					# All the assets are cached already
					LET $id = (UPDATE ONLY stuff:increment SET asset += 1).asset;
					LET $cached = (SELECT * FROM assetCache:[$assetId, 1])[0]; # version 1 is usually the only version
					LET $asset = CREATE asset CONTENT {
						id: $id,
						name: $cached.name,
						type: $cached.type,
						price: 0,
						description: [{
							text: $cached.description,
							updated: time::now(),
						}],
						created: time::now(),
						updated: time::now(),
						visibility: "Visible",
					};
					RELATE $user->owns->$asset;
					RELATE $user->created->$asset;
					RELATE $cached->createdAsset->$asset;
				};
				# Now time for the big one
				LET $id = (UPDATE ONLY stuff:increment SET asset += 1).asset;
				LET $cached = (SELECT data, type
				FROM assetCache:[$assetId, $version])[0];
				LET $asset = CREATE asset CONTENT {
					id: $id,
					name: $name,
					type: $cached.type,
					price: $price,
					description: [{
						text: $description,
						updated: time::now(),
					}],
					created: time::now(),
					updated: time::now(),
					visibility: "Visible",
				};
				RELATE $user->owns->$asset;
				RELATE $user->created->$asset;
				{
					id: $id,
					type: $cached.type,
				};
				(SELECT
					(SELECT meta::id(id) AS id
					FROM ->createdAsset->asset)[0].id AS id,
					type,
					meta::id(id)[0] AS sharedId
				FROM assetCache WHERE ->createdAsset->asset);
				COMMIT TRANSACTION`,
			{ assets: form.data.shared.split(",").map(s => +s), ...data }
		)

		const { id, type } = res[7] as {
			id: number
			type: number
		}
		const shared = res[8] as {
			id: number
			type: number
			sharedId: number
		}[]

		let cachedXml = fs.readFileSync(
			`data/assetCache/${data.assetId}_${data.version}`,
			"utf-8"
		)

		// Replace the shared asset URLs with the new asset IDs
		for (const exec of cachedXml.matchAll(/(<url>.+<\/url>)/g)) {
			const url = exec[1]
			const id = url.match(/\d+/)?.[0]
			if (!id) continue // shouldn't happen, let's just ignore it

			const newId = shared.find(s => s.sharedId === +id)?.id
			if (!newId) continue // same as above
			cachedXml = cachedXml.replace(
				url,
				`<url>${process.env.RCC_ORIGIN}/asset?id=${newId}</url>`
			)
		}

		await Promise.all([
			fs.promises.writeFile(`data/assets/${id}`, cachedXml),
			...shared.map(s =>
				fs.promises.copyFile(
					`data/assetCache/${s.sharedId}_1`,
					`data/assets/${s.id}`
				)
			),
		])

		const renders: Promise<void>[] = []

		if (type === 18) {
			const imageAsset = shared.find(s => s.type === 1)?.id
			if (imageAsset)
				// we want to move the imageasset from assets to thumbnails (don't render it)
				renders.push(
					fs.promises.copyFile(
						`data/assets/${imageAsset}`,
						`data/thumbnails/${id}`
					)
				)
		} else {
			renders.push(requestRender("Model", id))
			const renderMesh = shared.find(s => s.type === 4)?.id
			if (renderMesh) renders.push(requestRender("Mesh", renderMesh))
		}

		await Promise.all(renders)

		redirect(302, `/avatarshop/${id}`)
	},
}
