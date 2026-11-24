import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { ownsOne } from "economy/api"
import {
	Package as EconPackage,
	UnlimitedAsset as EconUnlimitedAsset,
	User as EconUser,
} from "economy/types"
import { brickColours } from "#lib/brickColours.ts"
import {
	allowedTypes,
	isBodyPart,
	oneEquippable,
	packageConflicting,
	packageWearable,
} from "#lib/character.ts"
import { assetRegex } from "#lib/paramTests.ts"
import { authorise } from "#lib/server/auth.ts"
import { bodyColoursOf, setBodyColours } from "#lib/server/db/appearance.ts"
import {
	equipAsset,
	equipDataOf,
	equipPackage,
	hatsWorn,
	unequipAsset,
	unequipPackage,
} from "#lib/server/db/character.ts"
import { economyConnFailed } from "#lib/server/economy.ts"
import { packageItems } from "#lib/server/packageItems.ts"
import { ratelimited, tooManyRequests } from "#lib/server/ratelimit.ts"
import requestRender from "#lib/server/requestRender.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

// Asset ids are numbers, so `.for()` instances send a number
const assetIdSchema = type("string | number").pipe(String)

const equipSchema = type({
	id: assetIdSchema,
})

const paintSchema = type({
	c: "string",
	p: "string",
})

async function getEquipData(id: string, requireVisible = true) {
	const { fetch: f, locals } = getRequestEvent()
	const { user } = await authorise(locals)

	if (!assetRegex.test(id)) error(400, `Invalid asset ID: ${id}`)
	const assetId = Number(id)

	const asset = await equipDataOf(assetId)
	if (!asset) error(404, "Item not found")

	// packages are their own item type in the ledger, so ownership has to be checked against Package rather than UnlimitedAsset
	const o = new EconUser(user.id)
	const i =
		asset.type === 32
			? new EconPackage(assetId)
			: new EconUnlimitedAsset(assetId)
	const owns = await ownsOne(f, o, i)
	if (!owns.ok) {
		console.error("ownsOne failed")
		error(500, economyConnFailed)
	}
	if (!owns.value) error(400, "You don't own this item")

	if (!allowedTypes.includes(asset.type))
		error(400, "Can't equip this type of item")
	if (requireVisible && asset.visibility !== "Visible")
		error(400, "This item hasn't been approved yet")

	return { asset, id: assetId, user }
}

async function rerender(user: SessionUser) {
	const { fetch: f } = getRequestEvent()
	try {
		await requestRender(f, "Avatar", user.id, user.username, true)
	} catch (e) {
		console.error(e)
		error(500, "Failed to request render")
	}
}

export const equipForm = form(equipSchema, async ({ id }, issues) => {
	const { user, asset, id: assetId } = await getEquipData(id)

	// Packages simply equip the user with every item inside them
	if (asset.type === 32) {
		const { fetch: f } = getRequestEvent()
		const items = await packageItems(f, assetId, user.id)
		const children = items.filter(
			item =>
				item.owned &&
				item.visibility === "Visible" &&
				packageWearable.includes(item.type)
		)
		if (children.length === 0)
			return issues("This package has no items to equip")

		await equipPackage({
			children: children.map(item => Record("asset", item.id)),
			conflicting: [
				...new Set(
					// slots that package items occupy are replaced wholesale
					children
						.map(item => item.type)
						.filter(itemType =>
							packageConflicting.includes(itemType)
						)
				),
			],
			user: Record("user", user.id),
		})

		return rerender(user)
	}

	// Find if there's more than 3 hats equipped, throw an error if there is
	if (asset.type === 8) {
		const hatsEquipped = await hatsWorn(Record("user", user.id))
		if (hatsEquipped >= 3) return issues("You can only wear 3 hats")
	}

	await equipAsset(
		Record("asset", assetId),
		Record("user", user.id),
		oneEquippable.includes(asset.type) ? asset.type : undefined
	)

	return rerender(user)
})

export const unequipForm = form(equipSchema, async ({ id }) => {
	// a worn item can always be removed, even if it was re-uploaded and is awaiting approval again
	const { user, asset, id: assetId } = await getEquipData(id, false)

	// Unequipping a package unequips everything inside it
	if (asset.type === 32) {
		const { fetch: f } = getRequestEvent()
		const items = await packageItems(f, assetId, user.id)
		const children = items
			.filter(
				item =>
					item.owned &&
					item.visibility === "Visible" &&
					packageWearable.includes(item.type)
			)
			.map(item => Record("asset", item.id))

		await unequipPackage({
			children,
			user: Record("user", user.id),
		})

		return rerender(user)
	}

	await unequipAsset(Record("asset", assetId), Record("user", user.id))

	return rerender(user)
})

export const paintForm = form(paintSchema, async ({ c, p }, issues) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const bodyColour = Number(c)
	if (
		!(brickColours as readonly number[]).includes(bodyColour) ||
		!isBodyPart(p)
	)
		return issues("Invalid body colour")

	const currentColours = await bodyColoursOf(user.username)
	if (!currentColours) error(404, "User not found")
	currentColours[p] = bodyColour

	await setBodyColours(user.id, currentColours)

	return rerender(user)
})

export const regenForm = form(async () => {
	const { locals, getClientAddress } = getRequestEvent()
	const { user } = await authorise(locals)

	if (ratelimited("regen", getClientAddress, 2)) error(429, tooManyRequests)

	return rerender(user)
})
