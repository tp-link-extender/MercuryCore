import { error, fail, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import type { Comment } from "$lib/comment"
import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import {
	economyConnFailed,
	getBalance,
	getCurrentFee,
	transact,
} from "$lib/server/economy"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, find, Record } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import type { RequestEvent } from "./$types"
import assetQuery from "./asset.surql"
import buyQuery from "./buy.surql"
import findAssetQuery from "./findAsset.surql"

const schema = type({
	content: "1 <= string <= 1000",
	replyId: "string | undefined",
})

type Asset = {
	id: string
	comments: Comment[]
	created: Date
	creator: BasicUser
	description: {
		text: string
		updated: Date
	}
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

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const { id } = params
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset || !asset.creator) error(404, "Not Found")

	const slug = encode(asset.name)
	if (!couldMatch(asset.name, params.name))
		redirect(302, `/catalog/${id}/${slug}`)

	const balance = await getBalance(user.id)
	if (!balance.ok) error(500, economyConnFailed)
	const currentFee = await getCurrentFee()
	if (!currentFee.ok) error(500, economyConnFailed)

	return {
		noText: noTexts[Math.floor(Math.random() * noTexts.length)],
		failText: failTexts[Math.floor(Math.random() * failTexts.length)],
		form: await superValidate(arktype(schema)),
		slug,
		asset,
		balance: balance.value,
		currentFee: currentFee.value,
	}
}

async function getBuyData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const { id } = e.params
	const assetExists = await find("asset", id)
	if (!assetExists) error(404)

	return { user, id }
}

// actions that return things are here because of sveltekit typescript limitations
async function rerender({ locals, params }: RequestEvent) {
	await authorise(locals, 5)

	const { id } = params
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

	if ([8, 11, 12].includes(asset.type))
		try {
			await requestRender(asset.type === 8 ? "Model" : "Clothing", id)
			const icon = `/catalog/${id}/${asset.name}/icon?r=${Math.random()}`
			return { icon }
		} catch (e) {
			console.error(e)
			return fail(500, { msg: "Failed to request render" })
		}

	error(400, "Can't rerender this type of asset")
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

	const { id } = params
	const [getAsset] = await db.query<{ creatorId: string }[]>(
		`
			SELECT
				record::id(<-created[0]<-user[0].id) AS creatorId
			FROM ONLY $asset WHERE visibility = "Visible"`,
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
		creator: {
			id: string
			username: string
		}
		name: string
		owned: boolean
		price: number
		visibility: string
	}
	const [[asset]] = await db.query<FoundAsset[][]>(buyQuery, {
		user: Record("user", user.id),
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")
	if (asset.owned) error(400, "You already own this item")
	if (asset.visibility !== "Visible")
		error(400, "This item hasn't been approved yet")

	if (asset.price > 0) {
		// todo work out how free assets are supposed to work
		const tx = await transact(
			user.id,
			asset.creator.id,
			asset.price,
			`Purchased asset ${asset.name}`,
			`/catalog/${id}/${asset.name}`,
			[]
		)
		if (!tx.ok) error(400, tx.msg)
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
