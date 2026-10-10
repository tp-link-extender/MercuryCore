import { error, fail, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import {
	balance,
	buyUnlimitedAsset,
	countOwnersOne,
	ownersOne,
	ownsOne,
} from "economy/api"
import * as Econ from "economy/types"
import type { Comment } from "$lib/comment"
import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import { economyConnFailed } from "$lib/server/economy"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { packageItems } from "$lib/server/packageItems"
import ratelimit from "$lib/server/ratelimit"
import requestRender, { type RenderType } from "$lib/server/requestRender"

import { db, find, Record } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import { couldMatch, encode } from "$lib/urlName"
import type { RequestEvent } from "./$types"
import assetQuery from "./asset.surql"
import buyQuery from "./buy.surql"
import findAssetQuery from "./findAsset.surql"
import grantPackageQuery from "./grantPackage.surql"

const schema = type({
	content: "1 <= string <= 1000",
	replyId: "string | undefined",
})

type Asset = {
	id: string
	comments: Comment[]
	created: Date
	description: string
	forSale: boolean
	name: string
	owned: boolean
	price: number
	sold: number
	type: number
	visibility: string
}

const noTexts = Object.freeze([
	"Cancel",
	"No thanks",
	"I've reconsidered",
	"Not really",
	"Nevermind",
])
const failTexts = Object.freeze(["Bruh", "Okay", "Aight", "Rip", "Aw man..."])

export async function load({ fetch: f, locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset?.creator) error(404, "Not Found")

	const slug = encode(asset.name)
	if (!couldMatch(asset.name, params.name))
		redirect(302, `/catalog/${id}/${slug}`)

	const u = new Econ.User(user.id)
	const b = await balance(f, u)
	if (!b.ok) {
		console.error("balance failed")
		error(500, economyConnFailed)
	}

	const i = new Econ.UnlimitedAsset(id)
	const owned = await ownsOne(f, u, i)
	if (!owned.ok) {
		console.error("ownsOne failed")
		error(500, economyConnFailed)
	}

	const owners = await countOwnersOne(f, i)
	if (!owners.ok) {
		console.error("countOwnersOne for owners failed")
		error(500, economyConnFailed)
	}

	const src = new Econ.UnlimitedSource(id)
	const creators = await ownersOne(f, src)
	if (!creators.ok) {
		console.error("countOwnersOne for creators failed")
		error(500, economyConnFailed)
	}

	// there should only ever be 1 creator
	const creator = creators.value.set
	console.log(creator)

	return {
		noText: noTexts[Math.floor(Math.random() * noTexts.length)],
		failText: failTexts[Math.floor(Math.random() * failTexts.length)],
		form: await superValidate(arktype(schema)),
		slug,
		asset: {
			...asset,
			price: BigInt(asset.price),
		},
		sold: owners.value,
		owned: owned.value,
		creator,
		balance: b.value,
	}
}

async function getBuyData({ locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const id = +params.id
	const assetExists = await find("asset", id)
	if (!assetExists) error(404)

	return { user, id }
}

// actions that return things are here because of sveltekit typescript limitations
async function rerender({ fetch: f, locals, params }: RequestEvent) {
	await authorise(locals, 5)

	const id = +params.id
	type FoundAsset = {
		name: string
		type: number
		visibility: string
	}
	const [[asset]] = await db.query<FoundAsset[][]>(findAssetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")
	if (asset.visibility === "Moderated")
		error(400, "Can't rerender a moderated asset")

	// body parts are rendered as close-ups of the part itself, with its
	// matching clothing (from api/render/bodypart), using one script per limb
	const renderTypeFromType = Object.freeze({
		27: "Torso",
		28: "RightArm",
		29: "LeftArm",
		30: "LeftLeg",
		31: "RightLeg",
	})

	const renderType =
		renderTypeFromType[asset.type as keyof typeof renderTypeFromType] ??
		(asset.type === 8
			? "Model"
			: asset.type === 32
				? "Package"
				: [11, 12].includes(asset.type)
					? "Clothing"
					: null)

	if (!renderType) error(400, "Can't rerender this type of asset")

	try {
		await requestRender(f, renderType as RenderType, id)
		const icon = `/catalog/${id}/${asset.name}/icon?r=${Math.random()}`
		return { icon }
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}
export const actions: import("./$types").Actions = { rerender }
actions.comment = async ({ locals, params, request, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const unfiltered = form.data.content.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Comment must have content"])

	const limit = ratelimit(form, "comment", getClientAddress, 5)
	if (limit) return limit

	const id = +params.id
	const [getAsset] = await db.query<{ creatorId: string }[]>(
		`
			SELECT
				record::id(<-created[0]<-user[0].id) AS creatorId
			FROM ONLY $asset`,
		{ asset: Record("asset", id) }
	)
	if (!getAsset) error(404)

	const { creatorId } = getAsset
	const content = filter(unfiltered)

	const [, newCommentId] = await db.query<string[]>(createCommentQuery, {
		content,
		type: ["asset", id],
		user: Record("user", user.id),
	})

	if (user.id !== creatorId)
		await db.run("fn::notify", [
			Record("user", user.id),
			Record("user", creatorId),
			"AssetComment",
			`${user.username} commented on your asset: ${content}`,
			newCommentId,
		])
}
actions.buy = async e => {
	const { user, id } = await getBuyData(e)

	type FoundAsset = {
		creatorId: string
		forSale: boolean
		name: string
		price: number
		type: number
		visibility: string
	}
	const [[asset]] = await db.query<FoundAsset[][]>(buyQuery, {
		user: Record("user", user.id),
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")
	if (asset.visibility !== "Visible")
		error(400, "This item hasn't been approved yet")
	if (!asset.forSale) error(400, "This item is not for sale")

	const u = new Econ.User(user.id)
	const i = new Econ.UnlimitedSource(id)
	const ok = await buyUnlimitedAsset(e.fetch, u, i, BigInt(asset.price))
	if (!ok) error(400, "Purchase failed")

	if (user.id !== asset.creatorId)
		await db.query(
			'fn::notify($user, $creator, "ItemPurchase", $note, $relativeId)',
			{
				user: Record("user", user.id),
				creator: Record("user", asset.creatorId),
				note: `${user.username} just purchased your item ${asset.name}`,
				relativeId: e.params.id,
			}
		)
		if (!tx.ok) error(400, tx.msg)
	}

	// buying a package grants ownership of every item inside it too
	// (the package ownership itself is granted below for all asset types)
	if (asset.type === 32) {
		const items = await packageItems(id, user.id)
		await db.query(grantPackageQuery, {
			items: items.filter(i => !i.owned).map(i => Record("asset", i.id)),
			user: Record("user", user.id),
		})
	}

	await Promise.all([
		db.query("RELATE $user->ownsAsset->$asset", {
			asset: Record("asset", id),
			user: Record("user", user.id),
		}),
		user.id === asset.creator.id ||
			db.query(
				'fn::notify($user, $creator, "ItemPurchase", $note, $relativeId)',
				{
					user: Record("user", user.id),
					creator: Record("user", asset.creator.id),
					note: `${user.username} just purchased your item ${asset.name}`,
					relativeId: e.params.id,
				}
			),
	])
}
