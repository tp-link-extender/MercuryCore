import render from "$lib/server/render"
import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import { fail, error } from "@sveltejs/kit"
import requestRender from "$lib/server/requestRender"

// Heads, Faces, T-Shirts, Shirts, Pants, Gear
const allowedTypes = [17, 18, 2, 11, 12, 19]
const brickColours = [
	1, 5, 9, 11, 18, 21, 23, 24, 26, 28, 29, 37, 38, 101, 102, 104, 105, 106,
	107, 119, 125, 135, 141, 151, 153, 192, 194, 199, 208, 217, 226, 1001, 1002,
	1003, 1004, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015,
	1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027,
	1028, 1029, 1030, 1031, 1032,
]
const select = surql`
	SELECT
		meta::id(id) AS id,
		name,
		price,
		type,
		($user ∈ <-wearing<-user) AS wearing
	FROM asset WHERE $user ∈ <-owns<-user
		AND type ∈ [${allowedTypes.join(", ")}]`

export const load = async ({ locals, url }) => {
	const searchQ = url.searchParams.get("q")?.trim()

	return {
		query: searchQ,
		assets: query<{
			name: string
			price: number
			id: number
			type: number
			wearing: boolean
		}>(
			surql`${select} ${
				searchQ
					? surql`AND string::lowercase($query) ∈ string::lowercase(name)`
					: ""
			}`,
			{
				user: `user:${(await authorise(locals)).user.id}`,
				query: searchQ,
			},
		),
	}
}

export const actions = {
	search: async ({ request, locals }) => ({
		assets: await query(
			surql`${select}
				AND string::lowercase($query) ∈ string::lowercase(name)`,
			{
				query: ((await request.formData()).get("q") as string).trim(),
				user: `user:${(await authorise(locals)).user.id}`,
			},
		),
	}),
	paint: async ({ locals, url }) => {
		const { user } = await authorise(locals),
			bodyPartQuery = url.searchParams.get("p"),
			bodyColour = url.searchParams.get("c")

		if (
			!bodyPartQuery ||
			!bodyColour ||
			!brickColours.includes(parseInt(bodyColour)) ||
			![
				"Head",
				"Torso",
				"LeftArm",
				"RightArm",
				"LeftLeg",
				"RightLeg",
			].includes(bodyPartQuery)
		)
			return fail(400)

		const bodyPart = bodyPartQuery as keyof typeof user.bodyColours,
			currentColours = user.bodyColours

		currentColours[bodyPart] = parseInt(bodyColour)

		await query(surql`UPDATE $user SET bodyColours = $currentColours`, {
			user: `user:${user.id}`,
			currentColours,
		})

		await requestRender("Avatar", user.number, true)

		return {
			avatar: `/api/avatar/${user.username}-body?r=${Math.random()}`,
		}
	},
	regen: async ({ locals, getClientAddress }) => {
		const { user } = await authorise(locals)

		if (ratelimit({}, "regen", getClientAddress, 2))
			return fail(429, { msg: "Too many requests" })

		try {
			await requestRender("Avatar", user.number, true)
			return {
				avatar: `/api/avatar/${user.username}-body?r=${Math.random()}`,
			}
		} catch (e) {
			console.error(e)
			return fail(500, { msg: "Failed to request render" })
		}
	},
	equip: async ({ locals, url, getClientAddress }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("id"),
			action = url.searchParams.get("a")

		// if (ratelimit({}, "equip", getClientAddress, 45))
		// 	return fail(429, { msg: "Too many requests" })

		if (!id) throw error(400, "Missing asset id")
		if (!/^\d+$/.test(id)) throw error(400, `Invalid asset id: ${id}`)

		const asset = await squery<{
			id: number
			type: number
			visibility: string
		}>(
			surql`
				SELECT
					meta::id(id) AS id,
					type,
					visibility
				FROM $asset
				WHERE $user ∈ <-owns<-user`,
			{
				asset: `asset:${id}`,
				user: `user:${user.id}`,
			},
		)

		if (!asset) throw error(404, "Item not found or not owned")

		if (!allowedTypes.includes(asset.type))
			throw error(400, "Can't equip this type of item")

		if (asset.visibility != "Visible")
			throw error(400, "This item hasn't been approved yet")

		switch (action) {
			case "equip":
				await query(
					surql`
						IF $type = 2 {
							# Unequip if there's already a t-shirt equipped
							DELETE $user->wearing WHERE out.type = 2;
						};
						RELATE $user->wearing->$asset
							SET time = time::now();
						RELATE $user->recentlyWorn->$asset
							SET time = time::now()`,
					{
						user: `user:${user.id}`,
						asset: `asset:${id}`,
						type: asset.type,
					},
				)
				break
			case "unequip":
				await query(surql`DELETE $user->wearing WHERE out = $asset`, {
					user: `user:${user.id}`,
					asset: `asset:${id}`,
				})
		}

		try {
			await requestRender("Avatar", user.number, true)
			return {
				avatar: `/api/avatar/${user.username}-body?r=${Math.random()}`,
			}
		} catch (e) {
			console.error(e)
			return fail(500, { msg: "Failed to request render" })
		}
	},
}
