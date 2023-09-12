import cql from "$lib/cyphertag"
import { authorise } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
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
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid asset id: ${params.id}`)
	const id = parseInt(params.id),
		// Since prisma does not yet support recursive copying, we have to do it manually
		selectComments = {
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
			description: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
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

	const { user } = await authorise(locals),
		assetOwned = await prisma.asset.findUnique({
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
		...(await addLikes<typeof getAsset>(
			"asset",
			"Comment",
			getAsset,
			user.username,
		)),
		id, // Add back the id
		owned: (assetOwned?.owners || []).length > 0,
		sold: getAsset._count.owners,
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

		await Query(
			"forum",
			cql`
				MERGE (u:User { name: $user })
				MERGE (p:Comment { name: $id })
				MERGE (u) -[:likes]-> (p)`,
			{ id: newReplyId, user: user.username },
		)
	},
	like: async ({ url, request, locals }) => {
		const { user } = await authorise(locals),
			data = await formData(request),
			{ action } = data,
			id = url.searchParams.get("id"),
			replyId = url.searchParams.get("rid")

		if (
			(id &&
				!(await prisma.asset.findUnique({
					where: {
						id: parseInt(id),
					},
				}))) ||
			!replyId
		)
			throw error(404)

		const query = {
			user: user.username,
			id: id || replyId,
		}

		try {
			switch (action) {
				case "like":
					await Query(
						"asset",
						cql`
							MATCH (:User { name: $user }) -[r:dislikes]-> (:Comment { name: $id })
							DELETE r`,
						query,
					)
					await Query(
						"asset",
						cql`
							MERGE (u:User { name: $user })
							MERGE (p:Comment { name: $id })
							MERGE (u) -[:likes]-> (p)`,
						query,
					)
					break
				case "unlike":
					await Query(
						"asset",
						cql`
							MATCH (:User { name: $user }) -[r:likes]-> (:Comment { name: $id })
							DELETE r`,
						query,
					)
					break
				case "dislike":
					await Query(
						"asset",
						cql`
							MATCH (:User { name: $user }) -[r:likes]-> (:Comment { name: $id })
							DELETE r`,
						query,
					)
					await Query(
						"asset",
						cql`
							MERGE (u:User { name: $user })
							MERGE (p:Comment { name: $id })
							MERGE (u) -[:dislikes]-> (p)`,
						query,
					)
					break
				case "undislike":
					await Query(
						"asset",
						cql`
							MATCH (:User { name: $user }) -[r:dislikes]-> (:Comment { name: $id })
							DELETE r`,
						query,
					)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
	buy: async ({ url, locals, params }) => {
		const { user } = await authorise(locals),
			action = url.searchParams.get("a"),
			id = parseInt(params.id)

		console.log(action)

		if (
			!(await prisma.asset.findUnique({
				where: {
					id,
				},
			}))
		)
			throw error(404)

		console.log("Action:", action)

		switch (action) {
			case "buy": {
				const asset = await prisma.asset.findUnique({
					where: {
						id,
					},
					include: {
						creatorUser: true,
						// creatorGroup: true,
						owners: {
							where: {
								id: user.id,
							},
						},
					},
				})
				if (!asset) throw error(404, "Not found")
				if ((asset.owners || []).length > 0)
					throw error(400, "You already own this item")

				try {
					await transaction(
						{ id: user.id },
						{ id: asset.creatorUser?.id },
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
					prisma.authUser.update({
						where: {
							id: user.id,
						},
						data: {
							assetsOwned: {
								connect: {
									id,
								},
							},
						},
					}),
					user.id == asset.creatorUser?.id
						? null
						: prisma.notification.create({
								data: {
									type: NotificationType.ItemPurchase,
									senderId: user.id,
									receiverId: asset.creatorUser?.id || "",
									note: `${user.username} just purchased your item: ${asset.name}`,
									relativeId: params.id,
								},
						  }),
				])

				break
			}
			case "delete": {
				const asset = await prisma.asset.findUnique({
					where: {
						id,
					},
					include: {
						creatorUser: true,
						owners: {
							where: {
								id: user.id,
							},
						},
					},
				})
				if (!asset) throw error(404, "Not found")
				if ((asset?.owners || []).length < 1)
					throw error(400, "You don't own this item")

				await prisma.authUser.update({
					where: {
						id: user.id,
					},
					data: {
						assetsOwned: {
							disconnect: {
								id,
							},
						},
					},
				})

				break
			}
		}
	},
	delete: async ({ url, locals }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("id")

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
