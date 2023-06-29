import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import { error } from "@sveltejs/kit"
import { NotificationType } from "@prisma/client"
import formData from "$lib/server/formData"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(5).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)
	const id = parseInt(params.id)

	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectComments: any = {
		// odd type errors in "replies: selectComments" if not any
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			content: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++)
		selectComments.select.replies = structuredClone(selectComments)

	const getAsset = await prisma.asset.findUnique({
		where: { id },
		select: {
			id: true,
			name: true,
			price: true,
			description: true,
			type: true,

			replies: {
				where: {
					parentReplyId: null,
				},
				...selectComments,
			},
			creatorUser: {
				select: {
					username: true,
					number: true,
				},
			},
			owners: {
				select: {
					username: true,
					number: true,
				},
			},
			_count: {
				select: {
					owners: true,
				},
			},
		},
	})

	if (!getAsset || !getAsset.creatorUser) throw error(404, "Not found")

	const { user } = await authorise(locals)

	const assetOwned = await prisma.asset.findUnique({
		where: { id },
		select: {
			owners: {
				where: {
					id: user.id,
				},
			},
		},
	})

	async function addLikes(asset: any) {
		const query = {
			user: user.username,
			id: asset.id,
		}
		asset["likeCount"] = await roQuery(
			"asset",
			"RETURN SIZE((:User) -[:likes]-> (:Comment { name: $id }))",
			query,
			true
		)
		asset["dislikeCount"] = await roQuery(
			"asset",
			"RETURN SIZE((:User) -[:dislikes]-> (:Comment { name: $id }))",
			query,
			true
		)
		asset["likes"] = !!(await roQuery(
			"asset",
			"MATCH (:User { name: $user }) -[r:likes]-> (:Comment { name: $id }) RETURN r",
			query
		))
		asset["dislikes"] = !!(await roQuery(
			"asset",
			"MATCH (:User { name: $user }) -[r:dislikes]-> (:Comment { name: $id }) RETURN r",
			query
		))

		if (asset.replies)
			asset.replies = await Promise.all(
				asset.replies.map(addLikes)
			)

		return asset
	}

	const asset: typeof getAsset & {
		likeCount: number
		dislikeCount: number
		likes: boolean
		dislikes: boolean
	} = await addLikes(getAsset)

	const x = {
		form: superValidate(schema),
		...asset,
		owned: (assetOwned?.owners || []).length > 0,
		sold: getAsset._count.owners,
	}

	console.log(x)
	return x
}

export const actions = {
	reply: async ({ request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "assetComment", getClientAddress, 5)
		// if (limit) return limit

		const { content, replyId } = form.data
		// If there is a replyId, it is a reply to another comment

		let receiverId
		if (replyId) {
			let assetcomment = await prisma.assetComment.findUnique({
				where: { id: replyId },
			})
			if (!assetcomment) throw error(404)
			receiverId = assetcomment?.authorId || ""
		} else {
			let assetcomment = await prisma.asset.findUnique({
				where: { id: parseInt(params.id) },
				select: {
					creatorUser: {
						select: {
							id: true,
						},
					},
				},
			})
			if (!assetcomment) throw error(404)
			receiverId = assetcomment?.creatorUser?.id || ""
		}

		const newReplyId = await id()

		await prisma.assetComment.create({
			data: {
				id: newReplyId,
				authorId: user.id,
				content: {
					create: {
						text: content,
					},
				},
				parentAssetId: parseInt(params.id),
				parentReplyId: replyId,
			},
		})

		if (user.id != receiverId)
			await prisma.notification.create({
				data: {
					type: replyId
						? NotificationType.AssetCommentReply
						: NotificationType.AssetComment,
					senderId: user.id,
					receiverId,
					note: `${user.username} ${
						replyId
							? "replied to your comment"
							: "commented on your asset"
					}: ${content}`,
					relativeId: newReplyId,
				},
			})
	},
	like: async ({ request, locals, url }) => {
		const { user } = await authorise(locals)
		const data = await formData(request)
		const { action } = data
		const id = url.searchParams.get("id")
		const {replyId } = data

		if (
			(id &&
				!(await prisma.asset.findUnique({
					where: {
						id: parseInt(id),
					},
				}))) ||
			!replyId
		) {
			throw error(404)
		}

		const query = {
			user: user.username,
			id: id || replyId,
		}

		try {
			switch (action) {
				case "like":
					await Query(
						"asset",
						`
							MATCH (:User { name: $user }) -[r:dislikes]-> (:Comment { name: $id })
							DELETE r
						`,
						query
					)
					await Query(
						"asset",
						`
							MERGE (u:User { name: $user })
							MERGE (p:Comment { name: $id })
							MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await Query(
						"asset",
						`
							MATCH (:User { name: $user }) -[r:likes]-> (:Comment { name: $id })
							DELETE r
						`,
						query
					)
					break
				case "dislike":
					await Query(
						"asset",
						`
							MATCH (:User { name: $user }) -[r:likes]-> (:Comment { name: $id })
							DELETE r
						`,
						query
					)
					await Query(
						"asset",
						`
							MERGE (u:User { name: $user })
							MERGE (p:Comment { name: $id })
							MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await Query(
						"asset",
						`
							MATCH (:User { name: $user }) -[r:dislikes]-> (:Comment { name: $id })
							DELETE r
						`,
						query
					)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
}
