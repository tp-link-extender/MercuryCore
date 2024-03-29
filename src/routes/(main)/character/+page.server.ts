import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import { fail, error } from "@sveltejs/kit"
import requestRender from "$lib/server/requestRender"
import type { RequestEvent } from "./$types"

// Heads, Faces, T-Shirts, Shirts, Pants, Gear, Hats
const allowedTypes = [17, 18, 2, 11, 12, 19, 8]
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
		($user INSIDE <-wearing<-user) AS wearing
	FROM asset WHERE $user INSIDE <-owns<-user
		AND type INSIDE [${allowedTypes.join(", ")}]
		AND visibility = "Visible"`

export const load = async ({ locals, url }) => {
	const searchQ = url.searchParams.get("q")?.trim()

	return {
		query: searchQ,
		assets: await query<{
			name: string
			price: number
			id: number
			type: number
			wearing: boolean
		}>(
			surql`${select} ${
				searchQ
					? surql`AND string::lowercase($query) INSIDE string::lowercase(name)`
					: ""
			}`,
			{
				user: `user:${(await authorise(locals)).user.id}`,
				query: searchQ,
			}
		),
	}
}

async function getEquipData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const id = e.url.searchParams.get("id")

	if (!id) error(400, "Missing asset id")
	if (!/^\d+$/.test(id)) error(400, `Invalid asset id: ${id}`)

	const limit = ratelimit(null, "equip", e.getClientAddress, 2)
	if (limit) return { error: limit }

	const asset = await squery<{
		id: number
		type: number
		visibility: string
	}>(
		surql`
			SELECT meta::id(id) AS id, type, visibility
			FROM $asset WHERE $user INSIDE <-owns<-user`,
		{
			asset: `asset:${id}`,
			user: `user:${user.id}`,
		}
	)

	if (!asset) error(404, "Item not found or not owned")

	if (!allowedTypes.includes(asset.type))
		error(400, "Can't equip this type of item")

	if (asset.visibility !== "Visible")
		error(400, "This item hasn't been approved yet")

	return { user, id, asset }
}

async function rerender(user: import("lucia").User) {
	try {
		await requestRender("Avatar", user.number, true)
		return {
			avatar: `/api/avatar/${user.username}-body?r=${Math.random()}`,
		}
	} catch (e) {
		console.error(e)
		fail(500, { msg: "Failed to request render" })
	}
}

export const actions = {
	search: async ({ request, locals }) => ({
		assets: await query(
			surql`${select}
				AND string::lowercase($query) INSIDE string::lowercase(name)`,
			{
				query: ((await request.formData()).get("q") as string).trim(),
				user: `user:${(await authorise(locals)).user.id}`,
			}
		),
	}),
	paint: async ({ locals, url }) => {
		const { user } = await authorise(locals)
		const bodyPartQuery = url.searchParams.get("p")
		const bodyColour = url.searchParams.get("c") as string

		if (
			!bodyPartQuery ||
			!bodyColour ||
			!brickColours.includes(+bodyColour) ||
			![
				"Head",
				"Torso",
				"LeftArm",
				"RightArm",
				"LeftLeg",
				"RightLeg",
			].includes(bodyPartQuery)
		)
			fail(400)

		const bodyPart = bodyPartQuery as keyof typeof user.bodyColours
		const currentColours = user.bodyColours

		currentColours[bodyPart] = +bodyColour

		await query(surql`UPDATE $user SET bodyColours = $currentColours`, {
			user: `user:${user.id}`,
			currentColours,
		})

		return await rerender(user)
	},
	regen: async ({ locals, getClientAddress }) => {
		const { user } = await authorise(locals)

		const limit = ratelimit(null, "regen", getClientAddress, 2)
		if (limit) return limit

		return await rerender(user)
	},
	equip: async e => {
		const { user, id, asset, error } = await getEquipData(e)
		if (error) return error

		// Find if there's more than 3 hats equipped, throw an error if there is
		if (
			asset.type === 8 &&
			(await squery<number>(
				surql`[count(SELECT 1 FROM $user->wearing WHERE out.type = 8)]`,
				{ user: `user:${user.id}` }
			)) >= 3
		)
			fail(400, { msg: "You can only wear 3 hats" })

		await query(
			surql`
				# Unequip if there's already a T-Shirt/Shirt/Pants/Face equipped
				IF $type = 2 {
					DELETE $user->wearing WHERE out.type = 2;
				} ELSE IF $type = 11 {
					DELETE $user->wearing WHERE out.type = 11;
				} ELSE IF $type = 12 {
					DELETE $user->wearing WHERE out.type = 12;
				} ELSE IF $type = 18 {
					DELETE $user->wearing WHERE out.type = 18;
				};
				RELATE $user->wearing->$asset SET time = time::now();
				RELATE $user->recentlyWorn->$asset SET time = time::now()`,
			{
				user: `user:${user.id}`,
				asset: `asset:${id}`,
				type: asset.type,
			}
		)

		return await rerender(user)
	},
	unequip: async e => {
		const { user, id, error } = await getEquipData(e)
		if (error) return error

		await query(surql`DELETE $user->wearing WHERE out = $asset`, {
			user: `user:${user.id}`,
			asset: `asset:${id}`,
		})

		return await rerender(user)
	},
}
