import { authorise } from "$lib/server/lucia"
import {
	transaction,
	surql,
	find,
	RecordId,
	equery,
	surrealql,
} from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import formError from "$lib/server/formError"
import { error, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import { like, likeScoreActions, type LikeActions } from "$lib/server/like"
import { recurse, type Replies } from "$lib/server/nestedReplies"
import { publish } from "$lib/server/realtime"
import requestRender, { RenderType } from "$lib/server/requestRender"
import type { Actions, RequestEvent } from "./$types"
import assetQuery from "./asset.surql"
import updateVisibilityQuery from "./updateVisibility.surql"
import createCommentQuery from "./createComment.surql"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTCOMMENTS = recurse(
	from => surql`
		(${from} <-replyToAsset<-assetComment
		WHERE !->replyToComment
		ORDER BY pinned DESC, score DESC) AS replies`,
	// Make sure it's not a reply to a comment
	"replyToComment",
	"assetComment"
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

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id)) error(400, `Invalid asset id: ${params.id}`)

	const { user } = await authorise(locals)
	const id = +params.id

	const [[asset]] = await equery<Asset[][]>(
		assetQuery.replace("_SELECTCOMMENTS", SELECTCOMMENTS),
		{
			asset: new RecordId("asset", id),
			user: new RecordId("user", user.id),
		}
	)

	if (!asset || !asset.creator) error(404, "Not found")

	const noTexts = [
		"Cancel",
		"No thanks",
		"I've reconsidered",
		"Not really",
		"Nevermind",
	]
	const failTexts = ["Bruh", "Okay", "Aight", "Rip", "Aw man..."]

	return {
		noText: noTexts[Math.floor(Math.random() * noTexts.length)],
		failText: failTexts[Math.floor(Math.random() * failTexts.length)],
		form: await superValidate(zod(schema)),
		asset,
	}
}

async function getBuyData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const id = +e.params.id

	const [[assetExists]] = await equery<boolean[][]>(
		surrealql`SELECT 1 FROM ${new RecordId("asset", id)}`
	)
	if (!assetExists) error(404)

	return { user, id }
}

async function findComment<T>(
	e: RequestEvent,
	permissionLevel?: number,
	input = surql`SELECT 1 FROM $assetComment`
) {
	const { locals, url } = e
	const { user } = await authorise(locals, permissionLevel)

	const id = url.searchParams.get("id")
	if (!id) error(400, "Missing comment id")
	// Prevents incorrect ids erroring the Surreal query as well
	if (!/^[0-9a-z]+$/.test(id)) error(400, "Invalid comment id")

	const [[comment]] = await equery<T[][]>(input, {
		assetComment: new RecordId("assetComment", id),
	})
	if (!comment) error(404, "Comment not found")

	return { user, comment, id }
}

const updateVisibility = (visibility: string, text: string, id: string) =>
	equery(updateVisibilityQuery, {
		assetComment: new RecordId("assetComment", id),
		text,
		visibility,
	})

const pinComment = (pinned: boolean) => async (e: RequestEvent) => {
	await equery(
		surrealql`UPDATE ${new RecordId(
			"assetComment",
			(await findComment(e, 4)).id
		)} SET pinned = ${pinned}`
	)
}

type Thing = {
	id: string
	score: number
	assetId: string
}

async function select(thing: string) {
	const [[got]] = await equery<Thing[][]>(
		surrealql`
			SELECT
				meta::id(id) AS id,
				count(<-likes) - count(<-dislikes) AS score,
				meta::id((->replyToAsset->asset.id)[0]) AS assetId # remove if asset likes are implemented
			FROM ${thing}`
	)

	return got
}

// actions that return things are here because of sveltekit typescript limitations
async function rerender({ locals, params }: RequestEvent) {
	await authorise(locals, 5)

	const [[asset]] = await equery<
		{
			name: string
			id: string
			type: number
			visibility: string
		}[][]
	>(
		surrealql`
			SELECT
				name,
				meta::id(id) AS id, 
				type,
				visibility
			FROM ${new RecordId("asset", params.id)}`
	)
	if (!asset) error(404, "Not found")

	if (![11, 12, 8].includes(asset.type))
		error(400, "Can't rerender this type of asset")

	if (asset.visibility === "Moderated")
		error(400, "Can't rerender a moderated asset")

	try {
		await requestRender(
			asset.type === 8 ? RenderType.Model : RenderType.Clothing,
			+params.id
		)
		return {
			icon: `/avatarshop/${asset.id}/${
				asset.name
			}/icon?r=${Math.random()}`,
		}
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}
export const actions: Actions = { rerender }
actions.reply = async ({ url, request, locals, params, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const limit = ratelimit(form, "assetComment", getClientAddress, 5)
	if (limit) return limit

	const commentId = url.searchParams.get("rid")
	// If there is a replyId, it is a reply to another comment

	const content = form.data.content.trim()
	if (!content)
		return formError(form, ["content"], ["Comment cannot be empty"])

	if (commentId && !/^[0-9a-z]+$/.test(commentId))
		error(400, "Invalid comment id")

	const [[commentAuthor]] = await equery<{ id: string }[][]>(
		commentId
			? surrealql`SELECT meta::id(id) AS id FROM ${new RecordId(
					"assetComment",
					commentId
				)}<-posted<-user`
			: surrealql`SELECT meta::id(id) AS id FROM ${new RecordId(
					"asset",
					params.id
				)}<-created<-user`
	)
	if (commentId && !commentAuthor) error(404)

	const receiverId = commentAuthor?.id || ""
	const [newReplyId] = await equery<string[]>(surrealql`fn::id()`)

	await equery(createCommentQuery, {
		content,
		user: new RecordId("user", user.id),
		assetComment: new RecordId("assetComment", newReplyId),
		asset: new RecordId("asset", params.id),
		commentId: commentId
			? new RecordId("assetComment", commentId)
			: undefined,
	})

	await Promise.all([
		user.id !== receiverId &&
			equery(
				surrealql`
					RELATE $sender->notification->$receiver CONTENT {
						type: $type,
						time: time::now(),
						note: $note,
						relativeId: $relativeId,
						read: false,
					}`,
				{
					type: commentId ? "AssetCommentReply" : "AssetComment",
					sender: new RecordId("user", user.id),
					receiver: new RecordId("user", receiverId),
					note: `${user.username} ${
						commentId
							? "replied to your comment"
							: "commented on your asset"
					}: ${content}`,
					relativeId: newReplyId,
				}
			),

		like(user.id, new RecordId("assetComment", newReplyId)),
	])
}
actions.like = async ({ request, locals, url }) => {
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as LikeActions
	const id = url.searchParams.get("id")
	const commentId = url.searchParams.get("rid")

	if (commentId && !/^[0-9a-z]+$/.test(commentId))
		error(400, "Invalid comment id")

	const foundAsset = id ? await find("asset", id) : null
	const foundComment = commentId
		? await select(`assetComment:${commentId}`)
		: null

	if (!foundAsset === !foundComment) error(404)
	if (foundAsset) error(400, "Asset likes not yet implemented")

	const type = "assetComment" // commentId ? "assetComment" : "asset"
	const likes = await likeScoreActions[action](
		user.id,
		new RecordId(type, (id || commentId) as string)
	)

	const thing = foundComment as Thing

	thing.score = likes
	// ok, better than publishing likes on all assets to all users but whatever
	await publish(`avatarshop:${thing.assetId}`, {
		...thing,
		action,
		// type,
		hash: user.realtimeHash,
	})
}
actions.buy = async e => {
	const { user, id } = await getBuyData(e)

	const [[asset]] = await equery<
		{
			creator: {
				id: string
				username: string
			}
			name: string
			owned: boolean
			price: number
			visibility: string
		}[][]
	>(
		surrealql`
			SELECT
				*,
				(SELECT meta::id(id) AS id, username
				FROM <-created<-user)[0] AS creator,
				$user IN <-owns<-user.id AS owned
			FROM $asset`,
		{
			asset: new RecordId("asset", id),
			user: new RecordId("user", user.id),
		}
	)
	if (!asset) error(404, "Not found")
	if (asset.owned) error(400, "You already own this item")
	if (asset.visibility !== "Visible")
		error(400, "This item hasn't been approved yet")

	try {
		await transaction(user, asset.creator, asset.price, {
			note: `Purchased asset ${asset.name}`,
			link: `/avatarshop/${e.params.id}/${asset.name}`,
		})
	} catch (err) {
		const e = err as Error
		console.log(e.message)
		error(400, e.message)
	}

	await Promise.all([
		equery(surrealql`RELATE $user->owns->$asset`, {
			user: new RecordId("user", user.id),
			asset: new RecordId("asset", id),
		}),
		user.id === asset.creator.id ||
			equery(
				surrealql`
					RELATE $sender->notification->$receiver CONTENT {
						type: $type,
						time: time::now(),
						note: $note,
						relativeId: $relativeId,
						read: false,
					}`,
				{
					type: "ItemPurchase",
					sender: new RecordId("user", user.id),
					receiver: new RecordId("user", asset.creator.id),
					note: `${user.username} just purchased your item: ${asset.name}`,
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
		surql`
			SELECT
				meta::id((<-posted<-user.id)[0]) AS authorId,
				visibility
			FROM $assetComment`
	)

	if (comment.authorId !== user.id)
		error(403, "You cannot delete someone else's comment")

	if (comment.visibility !== "Visible") error(400, "Comment already deleted")

	await updateVisibility("Deleted", "[deleted]", id)
}
actions.moderate = async e => {
	await updateVisibility(
		"Moderated",
		"[removed]",
		(await findComment(e, 4)).id
	)
}
actions.pin = pinComment(true)
actions.unpin = pinComment(false)
