import { authorise } from "$lib/server/lucia"
import { superValidate } from "sveltekit-superforms/server"
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

export async function load({ locals, url }) {
	await authorise(locals, 5)
	const assetId = url.searchParams.get("assetId") || undefined
	if (assetId && !assetId.match(/\d+/)) error(400, "Invalid assetId")

	const stage = url.searchParams.get("assetId")?.match(/\d+/)
		? url.searchParams.has("version")
			? 3
			: 2
		: 1

	async function getVersions() {
		const versions: [string, string][] = []

		// Get asset versions
		// ported directly from polygon
		for (let i = 1; ; i++) {
			console.log("Fetching asset version", i, "of", assetId)
			const data = await fetch(
				`https://assetdelivery.roblox.com/v1/asset/?id=${assetId}&version=${i}`,
				{
					headers: {
						"User-Agent": "Roblox/WinInet",
					},
				}
			)
			console.log("Got", data.status)

			if (data.status === 500) continue
			if (data.status !== 200) break

			// no need for a goofy ahh php loop
			const date = data.headers.get("last-modified")
			if (!date) break

			versions.push([
				i.toString(),
				new Date(date).toLocaleString("en-GB", {
					year: "numeric",
					month: "short",
					day: "numeric",
					hour: "numeric",
					minute: "numeric",
				}),
			])
		}

		console.log("Versions", versions)

		return versions
	}

	return {
		formManual: await superValidate(zod(schemaManual)),
		formAuto: await superValidate(zod(schemaAuto)),
		stage,
		...(stage === 2 ? { assetId, getVersions: getVersions() } : {}),
	}
}
