import { authorise } from "$lib/server/lucia"
import { query, squery, transaction, surql, find } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import formError from "$lib/server/formError"
import { error, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import { like, likeActions } from "$lib/server/like"
import { recurse, type Replies } from "$lib/server/nestedReplies"
import requestRender, { RenderType } from "$lib/server/requestRender"
import type { RequestEvent } from "./$types"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTCOMMENTS = recurse(
	from => surql`
		(${from} <-replyToAsset<-assetComment
		WHERE !->replyToComment
		ORDER BY pinned DESC, score DESC) AS replies`,
	// Make sure it's not a reply to another reply
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

	const asset = await squery<Asset>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, status, username
				FROM <-created<-user)[0] AS creator,
				count(<-owns<-user) AS sold,
				$user INSIDE <-owns<-user.id AS owned,

				(SELECT text, updated FROM $parent.description
				ORDER BY updated DESC)[0] AS description,

				${SELECTCOMMENTS}
			FROM $asset`,
		{
			asset: `asset:${id}`,
			user: `user:${user.id}`,
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
		...asset,
	}
}

async function getBuyData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const id = +e.params.id

	if (
		!(await squery(surql`SELECT * FROM $asset`, {
			asset: `asset:${id}`,
		}))
	)
		error(404)

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

	const comment = await squery<T>(input, {
		assetComment: `assetComment:${id}`,
	})
	if (!comment) error(404, "Comment not found")

	return { user, comment, id }
}

const updateVisibility = (visibility: string, text: string, id: string) =>
	query(
		surql`
			BEGIN TRANSACTION;
			LET $poster = (SELECT <-posted<-user AS poster FROM $forumReply)[0].poster;

			UPDATE $assetComment SET content += {
				text: $text,
				updated: time::now(),
			};
			UPDATE $assetComment SET visibility = $visibility;
			COMMIT TRANSACTION`,
		{ assetComment: `assetComment:${id}`, text, visibility }
	)

const pinComment = (pinned: boolean) => async (e: RequestEvent) => {
	await query(surql`UPDATE $assetComment SET pinned = $pinned`, {
		assetComment: `assetComment:${(await findComment(e, 4)).id}`,
		pinned,
	})
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)
		const form = await superValidate(request, zod(schema))
		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "assetComment", getClientAddress, 5)
		if (limit) return limit

		const replyId = url.searchParams.get("rid")
		// If there is a replyId, it is a reply to another comment

		const content = form.data.content.trim()
		if (!content)
			return formError(form, ["content"], ["Comment cannot be empty"])

		if (replyId && !/^[0-9a-z]+$/.test(replyId))
			error(400, "Invalid reply id")

		const commentAuthor = await squery<{ id: string }>(
			surql`SELECT meta::id(id) AS id FROM ` +
				(replyId
					? surql`$comment<-posted<-user`
					: surql`$asset<-created<-user`),
			{
				comment: `assetComment:${replyId}`,
				asset: `asset:${params.id}`,
			}
		)

		if (replyId && !commentAuthor) error(404)

		const receiverId = commentAuthor?.id || ""
		const newReplyId = await query<string>(surql`[fn::id()]`)

		await query(
			surql`
				LET $reply = CREATE $assetComment CONTENT {
					posted: time::now(),
					visibility: "Visible",
					pinned: false,
					content: [{
						text: $content,
						updated: time::now(),
					}],
				};
				RELATE $reply->replyToAsset->$asset;
				IF $replyId {
					RELATE $reply->replyToComment->$replyId;
				};
				RELATE $user->posted->$reply`,
			{
				content,
				user: `user:${user.id}`,
				assetComment: `assetComment:${newReplyId}`,
				asset: `asset:${params.id}`,
				replyId: replyId ? `assetComment:${replyId}` : undefined,
			}
		)

		await Promise.all([
			user.id !== receiverId &&
				query(
					surql`
						RELATE $sender->notification->$receiver CONTENT {
							type: $type,
							time: time::now(),
							note: $note,
							relativeId: $relativeId,
							read: false,
						}`,
					{
						type: replyId ? "AssetCommentReply" : "AssetComment",
						sender: `user:${user.id}`,
						receiver: `user:${receiverId}`,
						note: `${user.username} ${
							replyId
								? "replied to your comment"
								: "commented on your asset"
						}: ${content}`,
						relativeId: newReplyId,
					}
				),

			like(user.id, `assetComment:${newReplyId}`),
		])
	},
	like: async ({ request, locals, url }) => {
		const { user } = await authorise(locals)
		const data = await formData(request)
		const action = data.action as keyof typeof likeActions
		const id = url.searchParams.get("id")
		const replyId = url.searchParams.get("rid")

		if (replyId && !/^[0-9a-z]+$/.test(replyId))
			error(400, "Invalid reply id")

		if (
			(id && !(await find(`asset:${id}`))) ||
			(replyId && !(await find(`assetComment:${replyId}`)))
		)
			error(404)

		await likeActions[action](
			user.id,
			`asset${replyId ? "Comment" : ""}:${id || replyId}`
		)
	},
	buy: async e => {
		const { user, id } = await getBuyData(e)

		const asset = await squery<{
			creator: {
				id: string
				username: string
			}
			name: string
			owned: boolean
			price: number
			visibility: string
		}>(
			surql`
				SELECT
					*,
					(SELECT meta::id(id) AS id, username
					FROM <-created<-user)[0] AS creator,
					$user INSIDE <-owns<-user.id AS owned
				FROM $asset`,
			{
				asset: `asset:${id}`,
				user: `user:${user.id}`,
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
			query(surql`RELATE $user->owns->$asset`, {
				user: `user:${user.id}`,
				asset: `asset:${id}`,
			}),
			user.id === asset.creator.id ||
				query(
					surql`
						RELATE $sender->notification->$receiver CONTENT {
							type: $type,
							time: time::now(),
							note: $note,
							relativeId: $relativeId,
							read: false,
						}`,
					{
						type: "ItemPurchase",
						sender: `user:${user.id}`,
						receiver: `user:${asset.creator.id}`,
						note: `${user.username} just purchased your item: ${asset.name}`,
						relativeId: e.params.id,
					}
				),
		])
	},
	delete: async e => {
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

		if (comment.visibility !== "Visible")
			error(400, "Comment already deleted")

		await updateVisibility("Deleted", "[deleted]", id)
	},
	moderate: async e => {
		await updateVisibility(
			"Moderated",
			"[removed]",
			(await findComment(e, 4)).id
		)
	},
	pin: pinComment(true),
	unpin: pinComment(false),
	rerender: async ({ locals, params }) => {
		await authorise(locals, 5)

		const asset = await squery<{
			name: string
			id: string
			type: number
			visibility: string
		}>(
			surql`
				SELECT
					name,
					meta::id(id) AS id, 
					type,
					visibility
				FROM $asset`,
			{ asset: `asset:${params.id}` }
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
			fail(500, { msg: "Failed to request render" })
		}
	},
}
