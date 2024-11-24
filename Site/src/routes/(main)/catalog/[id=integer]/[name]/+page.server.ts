import { idRegex } from "$lib/paramTests"
import {
	economyConnFailed,
	getBalance,
	getCurrentFee,
	transact,
} from "$lib/server/economy"
import filter from "$lib/server/filter"
import formData from "$lib/server/formData"
import formError from "$lib/server/formError"
import { type LikeActions, like, likeScoreActions } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import { type Replies, recurse } from "$lib/server/nestedReplies"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { Record, db, find } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import { error, fail, redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types.d.ts"
import assetQuery from "./asset.surql"
import buyQuery from "./buy.surql"
import createCommentQuery from "./createComment.surql"
import findAssetQuery from "./findAsset.surql"
import updateVisibilityQuery from "./updateVisibility.surql"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTCOMMENTS = recurse(
	// Make sure it's not a reply to a comment
	`<-replyToAsset<-assetComment
		WHERE !->replyToComment
		ORDER BY pinned DESC, score DESC`,
	"<-replyToComment<-assetComment"
)

type Asset = {
	creator: BasicUser
	description: {
		text: string
		updated: string
	}
	id: string
	name: string
	owned: boolean
	posted: string
	price: number
	replies: Replies
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
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(
		assetQuery.replace("_SELECTCOMMENTS", SELECTCOMMENTS),
		{ asset: Record("asset", id), user: Record("user", user.id) }
	)
	if (!asset || !asset.creator) error(404, "Not found")

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
		form: await superValidate(zod(schema)),
		slug,
		asset,
		balance: balance.value,
		currentFee: currentFee.value,
	}
}

async function getBuyData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const id = +e.params.id
	const assetExists = await find("asset", id)
	if (!assetExists) error(404)

	return { user, id }
}

async function findComment<T>(
	e: RequestEvent,
	permissionLevel?: number,
	input = "SELECT 1 FROM $assetComment"
) {
	const { locals, url } = e
	const { user } = await authorise(locals, permissionLevel)

	const id = url.searchParams.get("id")
	if (!id) error(400, "Missing comment id")
	// Prevents incorrect ids erroring the Surreal query as well
	if (!idRegex.test(id)) error(400, "Invalid comment id")

	const [[comment]] = await db.query<T[][]>(input, {
		assetComment: Record("assetComment", id),
	})
	if (!comment) error(404, "Comment not found")

	return { user, comment, id }
}

const updateVisibility = (visibility: string, text: string, id: string) =>
	db.query(updateVisibilityQuery, {
		assetComment: Record("assetComment", id),
		text,
		visibility,
	})

const pinComment = (pinned: boolean) => async (e: RequestEvent) => {
	const { id } = await findComment(e, 4)
	db.merge(Record("assetComment", id), { pinned })
}

// actions that return things are here because of sveltekit typescript limitations
async function rerender({ locals, params }: RequestEvent) {
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
	if (!asset) error(404, "Not found")
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
actions.reply = async ({ url, request, locals, params, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	// If there is a commentId, it is a reply to another comment
	const commentId = url.searchParams.get("rid")
	if (commentId && !idRegex.test(commentId)) error(400, "Invalid comment id")

	const unfiltered = form.data.content.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Comment cannot be empty"])

	const limit = ratelimit(form, "assetComment", getClientAddress, 5)
	if (limit) return limit

	const id = +params.id
	const assetOrComment = commentId
		? Record("assetComment", commentId)
		: Record("asset", id)
	const [[commentAuthor]] = await db.query<{ id: string }[][]>(
		"SELECT meta::id(id) AS id FROM $assetOrComment<-created<-user",
		{ assetOrComment }
	)
	if (commentId && !commentAuthor) error(404)

	const receiverId = commentAuthor?.id || ""
	const [newReplyId] = await db.query<string[]>("fn::id()")

	await db.query(createCommentQuery, {
		content: filter(unfiltered),
		user: Record("user", user.id),
		assetComment: Record("assetComment", newReplyId),
		asset: Record("asset", id),
		commentId: commentId ? Record("assetComment", commentId) : undefined,
	})

	await Promise.all([
		user.id !== receiverId &&
			db.query(
				"fn::notify($sender, $receiver, $type, $note, $relativeId)",
				{
					sender: Record("user", user.id),
					receiver: Record("user", receiverId),
					type: commentId ? "AssetCommentReply" : "AssetComment",
					note: commentId
						? `${user.username} replied to your comment: ${unfiltered}`
						: `${user.username} commented on your asset: ${unfiltered}`,
					relativeId: newReplyId,
				}
			),
		like(user.id, Record("assetComment", newReplyId)),
	])
}
actions.like = async ({ request, locals, params, url }) => {
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as LikeActions
	const commentId = url.searchParams.get("rid")
	if (!commentId) error(400, "Missing comment id") // Asset likes not yet implemented
	if (commentId && !idRegex.test(commentId)) error(400, "Invalid comment id")

	const id = +params.id
	if (!(await find("asset", id))) error(404, "Asset not found")
	if (!(await find("assetComment", commentId)))
		error(404, "Asset coment not found")

	// const type = commentId ? "assetComment" : "asset"
	await likeScoreActions[action](user.id, Record("assetComment", commentId))
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
	if (!asset) error(404, "Not found")
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
			[id]
		)
		if (!tx.ok) error(400, tx.msg)
	}

	await Promise.all([
		db.query("RELATE $user->owns->$asset SET time = time::now()", {
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
actions.delete = async e => {
	const { user, comment, id } = await findComment<{
		authorId: string
		visibility: string
	}>(
		e,
		undefined,
		`
			SELECT
				meta::id((<-created<-user.id)[0]) AS authorId,
				visibility
			FROM $assetComment`
	)
	if (comment.authorId !== user.id)
		error(403, "You cannot delete someone else's comment")
	if (comment.visibility !== "Visible") error(400, "Comment already deleted")

	await updateVisibility("Deleted", "[deleted]", id)
}
actions.moderate = async e => {
	const { id } = await findComment(e, 4)
	await updateVisibility("Moderated", "[removed]", id)
}
actions.pin = pinComment(true)
actions.unpin = pinComment(false)
