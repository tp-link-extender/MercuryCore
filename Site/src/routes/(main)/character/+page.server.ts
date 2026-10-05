import { error, fail } from "@sveltejs/kit"
import { brickColours } from "$lib/brickColours"
import { assetRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/auth"
import { packageItems } from "$lib/server/packageItems"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types.d"
import assetsQuery from "./assets.surql"
import equipQuery from "./equip.surql"
import equipDataQuery from "./equipData.surql"
import equipPackageQuery from "./equipPackage.surql"
import hatsEquippedQuery from "./hatsEquipped.surql"
import unequipQuery from "./unequip.surql"
import unequipPackageQuery from "./unequipPackage.surql"
import wornQuery from "./worn.surql"

// Faces, T-Shirts, Shirts, Pants + body parts; only one of each of these types can be worn
const oneEquippable = Object.freeze([2, 11, 12, 18, 25, 26, 27, 28, 29, 30, 31])
// everything that can appear in the character tabs (Hats, Heads and Gear accumulate)
const allowedTypes = Object.freeze(
	oneEquippable.concat([8, 17, 19, 32]) // + Hat, Head, Gear, Package
)
// items inside a package that can be worn (which is everything except packages themselves)
const packageWearable = Object.freeze(allowedTypes.filter(type => type !== 32))
// slots replaced wholesale when a package is equipped (hats included)
const packageConflicting = Object.freeze(oneEquippable.concat([8]))
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

type WornAsset = {
	id: number
	worn: boolean
}

export async function load({ locals }) {
	const { user } = await authorise(locals)

	const [assets] = await db.query<Asset[][]>(assetsQuery, {
		user: Record("user", user.id),
		allowedTypes,
	})

	// A package counts as worn when every item inside it is worn, so that
	// unequipping anything from it removes its wearing state
	const contents = new Map<number, number[]>()
	const wearables: number[] = []
	for (const asset of assets.filter(a => a.type === 32)) {
		const items = (await packageItems(asset.id, user.id)).filter(
			i =>
				i.owned &&
				i.visibility === "Visible" &&
				packageWearable.includes(i.type)
		)
		if (items.length) {
			contents.set(
				asset.id,
				items.map(i => i.id)
			)
			wearables.push(...items.map(i => i.id))
		}
	}

	if (wearables.length) {
		const [worn] = await db.query<WornAsset[][]>(wornQuery, {
			ids: wearables,
			user: Record("user", user.id),
		})
		const wornIds = new Set(worn.filter(w => w.worn).map(w => w.id))
		for (const [pkgId, items] of contents) {
			const pkg = assets.find(a => a.id === pkgId)
			if (pkg && items.every(id => wornIds.has(id))) pkg.wearing = true
		}
	}

	return { assets }
}

async function getEquipData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const assetId = e.url.searchParams.get("id")

	if (!assetId) error(400, "Missing asset ID")
	if (!assetRegex.test(assetId)) error(400, `Invalid asset ID: ${assetId}`)
	const id = +assetId

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

async function rerender(f: typeof globalThis.fetch, user: User) {
	try {
		await requestRender(f, "Avatar", user.id, user.username, true)
		return {
			avatar: `/api/avatar/${user.username}-body?r=${Math.random()}`,
		}
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}

async function paint({ fetch: f, locals, url }: RequestEvent) {
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

	await db
		.update(Record("user", user.id))
		.merge({ bodyColours: currentColours })

	return await rerender(f, user)
}
async function regen({ fetch: f, locals, getClientAddress }: RequestEvent) {
	const { user } = await authorise(locals)

	const limit = ratelimit(null, "regen", getClientAddress, 2)
	if (limit) return limit

	return await rerender(f, user)
}
async function equip(e: RequestEvent) {
	const { user, id, asset, error } = await getEquipData(e)
	if (error) return error

	// Packages simply equip the user with every item inside them
	if (asset.type === 32) {
		const items = await packageItems(id, user.id)
		const children = items.filter(
			i =>
				i.owned &&
				i.visibility === "Visible" &&
				packageWearable.includes(i.type)
		)
		if (children.length < 1)
			return fail(400, { msg: "This package has no items to equip" })

		await db.query(equipPackageQuery, {
			children: children.map(i => Record("asset", i.id)),
			conflicting: [
				...new Set(
					// slots that package items occupy are replaced wholesale
					children
						.map(i => i.type)
						.filter(type => packageConflicting.includes(type))
				),
			],
			user: Record("user", user.id),
		})

		return await rerender(e.fetch, user)
	}

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

	return await rerender(e.fetch, user)
}
async function unequip(e: RequestEvent) {
	const { user, id, asset, error } = await getEquipData(e)
	if (error) return error

	// Unequipping a package unequips everything inside it
	if (asset.type === 32) {
		const items = await packageItems(id, user.id)
		const children = items
			.filter(
				i =>
					i.owned &&
					i.visibility === "Visible" &&
					packageWearable.includes(i.type)
			)
			.map(i => Record("asset", i.id))

		await db.query(unequipPackageQuery, {
			children,
			user: Record("user", user.id),
		})

		return await rerender(e.fetch, user)
	}

	await db.query(unequipQuery, {
		user: Record("user", user.id),
		asset: Record("asset", id),
	})

	return await rerender(e.fetch, user)
}
export const actions: import("./$types").Actions = {
	paint,
	regen,
	equip,
	unequip,
}
