import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query } from "$lib/server/redis"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import formError from "$lib/server/formError"
import addLikes from "$lib/server/addLikes"
import { error } from "@sveltejs/kit"
import { Prisma, NotificationType } from "@prisma/client"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(5).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)
	const id = parseInt(params.id)

	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectComments = {
		// where: {
		// 	OR: [{ visibility: Visibility.Visible }, { authorId: user.id }],
		// },
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			visibility: true,
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			content: {
				orderBy: {
					updated: Prisma.SortOrder.desc,
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

	// id not needed for querying likes, as assets can't be voted on
	getAsset.id = 0

	return {
		form: superValidate(schema),
		...(await addLikes<typeof getAsset>(
			"asset",
			"Comment",
			getAsset,
			user.username
		)),
		id, // Add back the id
		owned: (assetOwned?.owners || []).length > 0,
		sold: getAsset._count.owners,
	}
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "assetComment", getClientAddress, 5)
		if (limit) return limit

		const { content } = form.data
		const replyId = url.searchParams.get("rid")
		// If there is a replyId, it is a reply to another comment

		let receiverId
		if (replyId) {
			const assetcomment = await prisma.assetComment.findUnique({
				where: { id: replyId },
			})
			if (!assetcomment) throw error(404)
			receiverId = assetcomment?.authorId || ""
		} else {
			const assetcomment = await prisma.asset.findUnique({
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
				topParentId: parseInt(params.id),
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
		const replyId = url.searchParams.get("rid")

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
	delete: async ({ url, locals }) => {
		const { user } = await authorise(locals)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "No comment id provided")

		const comment = await prisma.assetComment.findUnique({
			where: { id },
			select: {
				authorId: true,
				visibility: true,
			},
		})

		if (!comment) throw error(404, "Comment not found")

		if (comment.authorId != user.id)
			throw error(403, "You cannot delete someone else's comment")

		if (comment.visibility != "Visible")
			throw error(400, "Comment already deleted")

		await prisma.assetComment.update({
			where: { id },
			data: {
				visibility: "Deleted",
				content: {
					create: {
						text: "[deleted]",
					},
				},
			},
		})
	},
	moderate: async ({ url, locals }) => {
		await authorise(locals, 4)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "No comment id provided")

		try {
			await prisma.assetComment.update({
				where: { id },
				data: {
					visibility: "Moderated",
					content: {
						create: {
							text: "[removed]",
						},
					},
				},
			})
		} catch (e) {
			throw error(404, "Comment not found")
		}
	},
}
