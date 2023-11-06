import { authorise } from "$lib/server/lucia"
import surreal, { query, squery, transaction, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import formError from "$lib/server/formError"
import { error, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import { like, likeSwitch } from "$lib/server/like"
import { recurse, type Replies } from "./select"
import requestRender from "$lib/server/requestRender"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTCOMMENTS = recurse(
	from => surql`
		(${from} <-replyToAsset<-assetComment
		WHERE !->replyToComment) AS replies`,
	// Make sure it's not a reply to another reply
)

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)

	const { user } = await authorise(locals),
		id = parseInt(params.id)

	const asset = await squery<{
		creator: {
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}
		description: {
			id: string
			text: any
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
	}>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT
					number,
					status,
					username
				FROM <-created<-user)[0] AS creator,
				count(<-owns<-user) AS sold,
				$user ∈ <-owns<-user.id AS owned,

				(SELECT text, updated FROM $parent.description
				ORDER BY updated DESC)[0] AS description,

				${SELECTCOMMENTS}
			FROM $asset`,
		{
			asset: `asset:${id}`,
			user: `user:${user.id}`,
		},
	)

	if (!asset || !asset.creator) throw error(404, "Not found")

	const noTexts = [
			"Cancel",
			"No thanks",
			"I've reconsidered",
			"Not really",
			"Nevermind",
		],
		failTexts = ["Bruh", "Okay", "Aight", "Rip", "Aw man..."]

	return {
		noText: noTexts[Math.floor(Math.random() * noTexts.length)],
		failText: failTexts[Math.floor(Math.random() * failTexts.length)],
		form: superValidate(schema),
		...asset,
	}
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals),
			form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "assetComment", getClientAddress, 5)
		if (limit) return limit

		const { content } = form.data,
			replyId = url.searchParams.get("rid")
		// If there is a replyId, it is a reply to another comment

		if (replyId && !/^[0-9a-z]+$/.test(replyId))
			throw error(400, "Invalid reply id")

		let receiverId
		const commentAuthor = await squery<{ id: string }>(
			surql`SELECT meta::id(id) AS id FROM ` + replyId
				? surql`$comment<-posted<-user`
				: surql`$asset<-created<-user`,
			{
				comment: `assetComment:${replyId}`,
				asset: `asset:${params.id}`,
			},
		)

		console.log(commentAuthor)

		if (replyId && !commentAuthor) throw error(404)
		receiverId = commentAuthor?.id || ""

		const newReplyId = await squery<string>(surql`fn::id()`)

		await query(
			surql`
				LET $reply = CREATE $assetComment CONTENT {
					posted: time::now(),
					visibility: "Visible",
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
			},
		)

		await Promise.all([
			(user.id != receiverId || !replyId) &&
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
					},
				),

			like(user.id, `assetComment:${newReplyId}`),
		])
	},
	like: async ({ request, locals, url }) => {
		const { user } = await authorise(locals),
			data = await formData(request),
			{ action } = data,
			id = url.searchParams.get("id"),
			replyId = url.searchParams.get("rid")

		if (replyId && !/^[0-9a-z]+$/.test(replyId))
			throw error(400, "Invalid reply id")

		if (
			(id && !(await surreal.select(`asset:${id}`))[0]) ||
			(replyId && !(await surreal.select(`assetComment:${replyId}`))[0])
		)
			throw error(404)

		await likeSwitch(
			action,
			user.id,
			`asset${replyId ? "Comment" : ""}:${id || replyId}`,
		)
	},
	buy: async ({ url, locals, params }) => {
		const { user } = await authorise(locals),
			action = url.searchParams.get("a"),
			id = parseInt(params.id)

		console.log(action)

		if (
			!(await squery(surql`SELECT * FROM $asset`, {
				asset: `asset:${id}`,
			}))
		)
			throw error(404)

		console.log("Action:", action)

		switch (action) {
			case "buy": {
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
							(SELECT
								meta::id(id) AS id,
								username
							FROM <-created<-user)[0] AS creator,
							$user ∈ <-owns<-user.id AS owned
						FROM $asset`,
					{
						asset: `asset:${id}`,
						user: `user:${user.id}`,
					},
				)
				if (!asset) throw error(404, "Not found")
				if (asset.owned) throw error(400, "You already own this item")
				if (asset.visibility != "Visible")
					throw error(400, "This item hasn't been approved yet")

				try {
					await transaction(
						{ id: user.id },
						{ id: asset.creator.id },
						asset.price,
						{
							note: `Purchased asset ${asset.name}`,
							link: `/avatarshop/${params.id}/${asset.name}`,
						},
					)
				} catch (e: any) {
					console.log(e.message)
					throw error(400, e.message)
				}

				await Promise.all([
					query(surql`RELATE $user->owns->$asset`, {
						user: `user:${user.id}`,
						asset: `asset:${id}`,
					}),
					user.id == asset.creator.id
						? null
						: query(
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
									relativeId: params.id,
								},
						  ),
				])

				break
			}
			case "delete": {
				const asset = await squery<{ owned: boolean }>(
					surql`
						SELECT
							$user ∈ <-owns<-user.id AS owned
						FROM $asset`,
					{
						asset: `asset:${id}`,
						user: `user:${user.id}`,
					},
				)
				if (!asset) throw error(404, "Not found")
				if (asset.owned) throw error(400, "You don't own this item")

				await query(surql`DELETE $user->owns WHERE out = $asset`, {
					user: `user:${user.id}`,
					asset: `asset:${id}`,
				})

				break
			}
		}
	},
	delete: async ({ url, locals }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("id")
		if (!id) throw error(400, "Missing comment id")
		if (!/^[0-9a-z]+$/.test(id)) throw error(400, "Invalid reply id")
		// Prevents incorrect ids erroring the Surreal query as well

		const comment = await squery<{
			authorId: string
			visibility: string
		}>(
			surql`
				SELECT
					meta::id((<-posted<-user.id)[0]) AS authorId,
					visibility
				FROM $assetComment`,
			{ assetComment: `assetComment:${id}` },
		)

		if (!comment) throw error(404, "Comment not found")

		if (comment.authorId != user.id)
			throw error(403, "You cannot delete someone else's comment")

		if (comment.visibility != "Visible")
			throw error(400, "Comment already deleted")

		await query(
			surql`
				LET $poster = (SELECT
					<-posted<-user AS poster
				FROM $assetComment)[0].poster;

				UPDATE $assetComment SET content += {
					text: "[deleted]",
					updated: time::now(),
				};
				UPDATE $assetComment SET visibility = "Deleted"`,
			{ assetComment: `assetComment:${id}` },
		)
	},
	moderate: async ({ url, locals }) => {
		await authorise(locals, 4)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "Missing comment id")
		if (!/^[0-9a-z]+$/.test(id)) throw error(400, "Invalid reply id")

		const findComment = (await surreal.select(`assetComment:${id}`))[0]

		if (!findComment) throw error(404, "Comment not found")

		await query(
			surql`
				LET $reply = SELECT (<-posted<-user)[0] AS poster
					FROM $assetComment;
				LET $poster = $reply.poster;

				UPDATE $assetComment SET content += {
					text: "[removed]",
					updated: time::now(),
				};
				UPDATE $assetComment SET visibility = "Moderated"`,
			{ assetComment: `assetComment:${id}` },
		)
	},
	rerender: async ({ locals, params, getClientAddress }) => {
		await authorise(locals, 3)

		// const limit = ratelimit({}, "rerender", getClientAddress, 60)
		// if (limit) return fail(429, { msg: "Too many requests" })

		const asset = await squery<{
			type: number
			visibility: string
		}>(surql`SELECT type, visibility FROM $asset`, {
			asset: `asset:${params.id}`,
		})

		if (!asset) throw error(404, "Not found")

		if (![11, 12].includes(asset.type))
			throw error(400, "Can't rerender this type of asset")

		if (asset.visibility == "Moderated")
			throw error(400, "Can't rerender a moderated asset")

		try {
			await requestRender("Clothing", parseInt(params.id))
		} catch (e) {
			console.error(e)
			return fail(500, { msg: "Failed to request render" })
		}
	},
}
