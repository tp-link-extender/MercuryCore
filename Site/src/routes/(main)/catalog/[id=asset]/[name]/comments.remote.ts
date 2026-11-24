import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { buyPackage, buyUnlimitedAsset } from "economy/api"
import { PackageSource, UnlimitedSource, User } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { assetType } from "#lib/server/db/assets.ts"
import { createComment } from "#lib/server/db/comments.ts"
import { notify } from "#lib/server/db/notifications.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { find } from "#lib/server/db/records.ts"
import { assetOwner, economyConnFailed } from "#lib/server/economy.ts"
import filter from "#lib/server/filter.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import requestRender, { type RenderType } from "#lib/server/requestRender.ts"
import { Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import buyQuery from "./buy.surql"
import findAssetQuery from "./findAsset.surql"

const commentSchema = type({
	content: "string",
	id: "string",
})

export const commentForm: ClientForm<typeof commentSchema.infer> = form(
	commentSchema,
	async ({ content: unfiltered, id: assetId }, issues) => {
		const { fetch: f, locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		const content = unfiltered.trim()
		if (!content) return issues.content("Comment must have content")

		const limit = ratelimitRemote(issues, "comment", getClientAddress, 5)
		if (limit) return limit

		const id = Number(assetId)
		const assetKind = await assetType(id)
		if (assetKind === undefined) error(404)

		let ownerId: string | null = null
		const owner = await assetOwner(f, id, assetKind)
		if (!owner.ok) console.error("asset owner lookup failed")
		else ownerId = owner.value?.id ?? null

		const filtered = filter(content)

		const newCommentId = await createComment({
			content: filtered,
			type: ["asset", id],
			user: Record("user", user.id),
		})

		if (ownerId && user.id !== ownerId)
			await notify(
				Record("user", user.id),
				Record("user", ownerId),
				"AssetComment",
				`${user.username} commented on your asset: ${filtered}`,
				newCommentId
			)
	}
)

const buySchema = type({
	id: "string",
	price: "string",
})

export const buyForm: ClientForm<typeof buySchema.infer> = form(
	buySchema,
	async ({ id: assetId, price: shownPrice }, issues) => {
		const { fetch: f, locals } = getRequestEvent()
		const { user } = await authorise(locals)

		const id = Number(assetId)
		const assetExists = await find("asset", id)
		if (!assetExists) error(404)

		interface FoundAsset {
			forSale: boolean
			name: string
			price: number
			type: number
			visibility: string
		}
		const [[asset]] = await dbQuery<FoundAsset[][]>(buyQuery, {
			asset: Record("asset", id),
		})
		if (!asset) error(404, "Not Found")
		if (asset.visibility !== "Visible")
			error(400, "This item hasn't been approved yet")
		// Images are the textures of other items, and older ones were created as for sale
		if (!asset.forSale || asset.type === 1)
			error(400, "This item is not for sale")

		// The buyer confirms the price they were shown, so a price change after they opened the dialog can't charge them more
		if (shownPrice !== String(asset.price))
			return issues(
				"This item's price has changed. Reload the page to see the new price."
			)

		// resolve the owner before charging, so a notification lookup can't fail after a successful purchase
		const owner = await assetOwner(f, id, asset.type)
		if (!owner.ok) error(500, economyConnFailed)

		const u = new User(user.id)
		// packages are sold through the Economy service as a bundle: the buyer pays once and receives the package plus everything inside it, so there's nothing to write here
		const price = BigInt(asset.price)
		const ok =
			asset.type === 32
				? await buyPackage(f, u, new PackageSource(id), price)
				: await buyUnlimitedAsset(f, u, new UnlimitedSource(id), price)
		if (!ok) return issues("Purchase failed")

		if (owner.value && user.id !== owner.value.id)
			await dbQuery(
				'fn::notify($user, $owner, "ItemPurchase", $note, $relativeId)',
				{
					note: `${user.username} just purchased your item ${asset.name}`,
					owner: Record("user", owner.value.id),
					relativeId: String(id),
					user: Record("user", user.id),
				}
			)
	}
)

const rerenderSchema = type({
	id: "string",
})

export const rerenderForm = form(rerenderSchema, async ({ id: assetId }) => {
	const { fetch: f, locals } = getRequestEvent()
	await authorise(locals, 5)

	const id = Number(assetId)
	interface FoundAsset {
		name: string
		type: number
		visibility: string
	}
	const [[asset]] = await dbQuery<FoundAsset[][]>(findAssetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")
	if (asset.visibility === "Moderated")
		error(400, "Can't rerender a moderated asset")

	// body parts are rendered as close-ups of the part itself, with its
	// matching clothing (from api/render/bodypart), using one script per limb
	const renderTypeFromType: { [_: number]: RenderType } = Object.freeze({
		27: "Torso",
		28: "RightArm",
		29: "LeftArm",
		30: "LeftLeg",
		31: "RightLeg",
	})

	const renderType =
		renderTypeFromType[asset.type] ??
		(asset.type === 8
			? "Model"
			: asset.type === 32
				? "Package"
				: [11, 12].includes(asset.type)
					? "Clothing"
					: null)

	if (!renderType) error(400, "Can't rerender this type of asset")

	try {
		await requestRender(f, renderType, id)
		return { icon: `/catalog/${id}/${asset.name}/icon?r=${Math.random()}` }
	} catch (e) {
		console.error(e)
		error(500, "Failed to request render")
	}
})
