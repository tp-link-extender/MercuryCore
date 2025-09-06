import { error, fail } from "@sveltejs/kit"
import { brickColours } from "$lib/brickColours"
import { idRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/auth"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types.d"
import assetsQuery from "./assets.surql"
import equipQuery from "./equip.surql"
import equipDataQuery from "./equipData.surql"
import hatsEquippedQuery from "./hatsEquipped.surql"
import unequipQuery from "./unequip.surql"

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

export async function load({ locals }) {
	const { user } = await authorise(locals)

	const [assets] = await db.query<Asset[][]>(assetsQuery, {
		user: Record("user", user.id),
		allowedTypes,
	})
	return { assets }
}

async function getEquipData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const id = e.url.searchParams.get("id")
	if (!id) error(400, "Missing asset id")
	if (!idRegex.test(id)) error(400, `Invalid asset id: ${id}`)

	const limit = ratelimit(null, "equip", e.getClientAddress, 2)
	if (limit) return { error: limit }

	const [[asset]] = await db.query<AssetData[][]>(equipDataQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset) error(404, "Item not found or not owned")
	if (!allowedTypes.includes(asset.type))
		error(400, "Can't equip this type of item")
	if (asset.visibility !== "Visible")
		error(400, "This item hasn't been approved yet")

	return { user, id, asset }
}

async function rerender(user: User) {
	try {
		await requestRender("Avatar", user.id, user.username, true)
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
		!(brickColours as readonly number[]).includes(+bodyColour) ||
		!bodyParts.includes(bodyPartQuery)
	)
		return fail(400)

	const bodyPart = bodyPartQuery as keyof typeof user.bodyColours
	const currentColours = user.bodyColours

	currentColours[bodyPart] = +bodyColour

	db.merge(Record("user", user.id), { bodyColours: currentColours })

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
	if (asset.type === 8) {
		const [hatsEquipped] = await db.query<number[]>(hatsEquippedQuery, {
			user: Record("user", user.id),
		})
		if (hatsEquipped >= 3)
			return fail(400, { msg: "You can only wear 3 hats" })
	}

	await db.query(equipQuery, {
		user: Record("user", user.id),
		asset: Record("asset", id),
		...(oneEquippable.includes(asset.type) ? asset : {}),
	})

	return await rerender(user)
}
async function unequip(e: RequestEvent) {
	const { user, id, error } = await getEquipData(e)
	if (error) return error

	await db.query(unequipQuery, {
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
