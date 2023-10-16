import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { squery, query } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

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
				(SELECT
					number,
					status,
					username
				FROM <-created<-user)[0] AS creator,
				(SELECT meta::id(id) AS id, name
				FROM ->imageAsset->asset)[0] AS imageAsset
			FROM asset WHERE visibility = "Pending"
				AND type ∈ [17, 18, 2, 11, 12, 19]`,
		{ user: `user:${(await authorise(locals)).user.id}` },
	),
})

export const actions = {
	default: async ({ locals, url }) => {
		const { user } = await authorise(locals, 3),
			id = url.searchParams.get("id"),
			action = url.searchParams.get("a")

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

		switch (action) {
			case "approve":
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
						...qParams,
						note: `Approve asset ${asset.name} (id ${id})`,
					},
				)
				break
			case "deny":
				await squery(
					surql`
						UPDATE $asset SET visibility = "Moderated";
						CREATE auditLog CONTENT {
							action: "Moderation",
							note: $note,
							user: $user,
							time: time::now()
						}`,
					{
						...qParams,
						note: `Moderate asset ${asset.name} (id ${id})`,
					},
				)
				break
			default:
				throw error(400, "Invalid action")
		}
	},
}
