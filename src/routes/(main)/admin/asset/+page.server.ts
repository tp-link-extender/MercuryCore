import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { squery, query, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import fs from "fs/promises"

export const load = async ({ locals }) => ({
	assets: query<{
		name: string
		price: number
		id: number
		type: string
		creator: {
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}
		imageAsset?: {
			id: number
			name: string
		}
	}>(
		surql`
			SELECT
				meta::id(id) AS id,
				name,
				price,
				type,
				(SELECT number, status, username
				FROM <-created<-user)[0] AS creator,
				(SELECT meta::id(id) AS id, name
				FROM ->imageAsset->asset)[0] AS imageAsset
			FROM asset WHERE visibility = "Pending"
				AND type ∈ [17, 18, 2, 11, 12, 19]`,
		{ user: `user:${(await authorise(locals)).user.id}` },
	),
})

type ActionFunction = (
	params: {
		user: string
		asset: string
	},
	asset: {
		name: string
	},
	id: string,
	getClientAddress: () => string,
) => Promise<any>

const approve: ActionFunction = async (params, asset, id) => {
	await squery(
		surql`
			UPDATE $asset SET visibility = "Visible";
			UPDATE $asset->imageAsset->asset
				SET visibility = "Visible";
			CREATE auditLog CONTENT {
				action: "Moderation",
				note: $note,
				user: $user,
				time: time::now()
			}`,
		{
			...params,
			note: `Approve asset ${asset.name} (id ${id})`,
		},
	)
}
const deny: ActionFunction = async (params, asset, id) => {
	await squery(
		surql`
			UPDATE $asset SET visibility = "Moderated";
			UPDATE $asset->imageAsset->asset
				SET visibility = "Moderated";
			CREATE auditLog CONTENT {
				action: "Moderation",
				note: $note,
				user: $user,
				time: time::now()
			}`,
		{
			...params,
			note: `Moderate asset ${asset.name} (id ${id})`,
		},
	)
}
const rerender: ActionFunction = async (_, _2, id, getClientAddress) => {
	const limit = ratelimit({}, "rerender", getClientAddress, 60)
	if (limit) return fail(429, { msg: "Too many requests" })

	try {
		await requestRender("Clothing", parseInt(id))
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}
const purge: ActionFunction = async (params, asset, id) => {
	const { iaid } = await squery<{ iaid: number }>(
		surql`
			SELECT meta::id((->imageAsset->asset.id)[0]) AS iaid
			FROM $asset`,
		{ asset: `asset:${id}` },
	)

	await Promise.all([
		query(
			surql`
				DELETE $asset;
				DELETE $imageAsset;
				CREATE auditLog CONTENT {
					action: "Moderation",
					note: $note,
					user: $user,
					time: time::now()
				}`,
			{
				...params,
				imageAsset: `asset:${iaid}`,
				note: `Purge asset ${asset.name} (id ${id})`,
			},
		),
		fs.rm(`data/assets/${id}`),
		fs.rm(`data/assets/${iaid}`),
		fs.rm(`data/thumbnails/${id}`),
	])
}

const actionFunctions = { approve, deny, rerender, purge }

// it goes like this, the bug, the fix
// the pull request, the git commit
// the coder's late-night screams
// of hallelujah
export const actions = {
	default: async ({ locals, url, getClientAddress }) => {
		const { user } = await authorise(locals, 3),
			id = url.searchParams.get("id"),
			action = url.searchParams.get("a") as keyof typeof actionFunctions

		if (!id) throw error(400, "Missing asset id")
		if (!/^\d+$/.test(id)) throw error(400, `Invalid asset id: ${id}`)

		const qParams = {
			user: `user:${user.id}`,
			asset: `asset:${id}`,
		}
		const asset = await squery<{
			name: string
		}>(surql`SELECT * FROM $asset`, qParams)

		if (!asset) throw error(404, "Asset not found")

		return actionFunctions?.[action](qParams, asset, id, getClientAddress)
	},
}
