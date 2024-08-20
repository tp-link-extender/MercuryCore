import { brickColours } from "$lib/brickColours.ts"
import { intRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types.d.ts"

// Heads, Faces, T-Shirts, Shirts, Pants, Gear, Hats
const oneEquippable = Object.freeze([2, 11, 12, 18])
const allowedTypes = Object.freeze(oneEquippable.concat([8, 17, 19]))
const bodyParts = Object.freeze([
	"Head",
	"LeftArm",
	"LeftLeg",
	"RightArm",
	"RightLeg",
	"Torso",
])

// boo kit
export const _select = `
	SELECT
		meta::id(id) AS id,
		name,
		price,
		type,
		($user IN <-wearing<-user) AS wearing
	FROM asset WHERE $user IN <-owns<-user
		AND type IN [${allowedTypes.join(", ")}]
		AND visibility = "Visible"`

export type Asset = {
	name: string
	price: number
	id: number
	type: number
	wearing: boolean
}

type AssetData = {
	id: number
	type: number
	visibility: string
}

export const load = async ({ locals, url }) => {
	const { user } = await authorise(locals)

	const query = url.searchParams.get("q")?.trim()
	const [assets] = await equery<Asset[][]>(
		query
			? `${_select} AND string::lowercase($query) IN string::lowercase(name)`
			: _select,
		{ query, user: Record("user", user.id) }
	)
	return { query, assets }
}

async function getEquipData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const strId = e.url.searchParams.get("id")
	if (!strId) error(400, "Missing asset id")
	if (!intRegex.test(strId)) error(400, `Invalid asset id: ${strId}`)

	const id = +strId

	const limit = ratelimit(null, "equip", e.getClientAddress, 2)
	if (limit) return { error: limit }

	const [[asset]] = await equery<AssetData[][]>(
		surql`
			SELECT meta::id(id) AS id, type, visibility
			FROM $asset WHERE $user IN <-owns<-user`,
		{
			asset: Record("asset", id),
			user: Record("user", user.id),
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
		await requestRender("Avatar", user.id, true)
		return {
			avatar: `/api/avatar/${user.username}-body?r=${Math.random()}`,
		}
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}

async function paint({ locals, url }: RequestEvent) {
	const { user } = await authorise(locals)
	const bodyPartQuery = url.searchParams.get("p")
	const bodyColour = url.searchParams.get("c") as string

	if (
		!bodyPartQuery ||
		!bodyColour ||
		!brickColours.includes(+bodyColour) ||
		!bodyParts.includes(bodyPartQuery)
	)
		return fail(400)

	const bodyPart = bodyPartQuery as keyof typeof user.bodyColours
	const currentColours = user.bodyColours

	currentColours[bodyPart] = +bodyColour

	await equery(surql`UPDATE $user SET bodyColours = ${currentColours}`, {
		user: Record("user", user.id),
	})

	return await rerender(user)
}
async function regen({ locals, getClientAddress }: RequestEvent) {
	const { user } = await authorise(locals)

	const limit = ratelimit(null, "regen", getClientAddress, 2)
	if (limit) return limit

	return await rerender(user)
}
async function equip(e: RequestEvent) {
	const { user, id, asset, error } = await getEquipData(e)
	if (error) return error

	// Find if there's more than 3 hats equipped, throw an error if there is
	const [hatsEquipped] = await equery<number[]>(
		surql`count(SELECT 1 FROM $user->wearing WHERE out.type = 8)`,
		{ user: Record("user", user.id) }
	)
	if (asset.type === 8 && hatsEquipped >= 3)
		return fail(400, { msg: "You can only wear 3 hats" })

	await equery(
		surql`
			# Unequip if there's already a T-Shirt/Shirt/Pants/Face equipped
			IF $type {
				DELETE $user->wearing WHERE out.type = $type;
			}
			RELATE $user->wearing->$asset SET time = time::now();
			RELATE $user->recentlyWorn->$asset SET time = time::now()`,
		{
			user: Record("user", user.id),
			asset: Record("asset", id),
			...(oneEquippable.includes(asset.type) ? asset : {}),
		}
	)

	return await rerender(user)
}
async function unequip(e: RequestEvent) {
	const { user, id, error } = await getEquipData(e)
	if (error) return error

	await equery(surql`DELETE $user->wearing WHERE out = $asset`, {
		user: Record("user", user.id),
		asset: Record("asset", id),
	})

	return await rerender(user)
}
export const actions: import("./$types").Actions = {
	paint,
	regen,
	equip,
	unequip,
}
actions.search = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const formData = await request.formData()

	const [assets] = await equery<Asset[][]>(
		`${_select} AND string::lowercase($query) IN string::lowercase(name)`,
		{
			query: (formData.get("q") as string).trim(),
			user: Record("user", user.id),
		}
	)
	return { assets }
}
