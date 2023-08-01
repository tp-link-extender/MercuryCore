import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import addLikes from "$lib/server/addLikes"
import { error } from "@sveltejs/kit"
import { NotificationType, Prisma } from "@prisma/client"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(5).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectReplies = {
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
		selectReplies.select.replies = structuredClone(selectReplies)

	const forumPost = await prisma.forumPost.findUnique({
		where: {
			id: params.post,
		},
		select: {
			id: true,
			title: true,
			posted: true,
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			forumCategory: {
				select: {
					name: true,
				},
			},
			replies: {
				...selectReplies,
				where: {
					// OR: [
					// 	{ visibility: Visibility.Visible },
					// 	{ authorId: user.id },
					// ],
					parentReplyId: null,
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
		},
	})

	if (!forumPost) throw error(404, "Not found")

	return {
		form: superValidate(schema),
		...(await addLikes<typeof forumPost>(
			"forum",
			"Post",
			forumPost,
			user.username,
			"Reply",
		)),
		baseDepth: 0,
	}
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "forumReply", getClientAddress, 5)
		if (limit) return limit

		const { content } = form.data
		const replyId = url.searchParams.get("rid")
		// If there is a replyId, it is a reply to another comment

		const replypost = replyId
			? await prisma.forumReply.findUnique({
					where: { id: replyId },
			  })
			: await prisma.forumPost.findUnique({
					where: { id: params.post },
			  })

		if (!replypost) throw error(404)

		const newReplyId = await id()

		await prisma.forumReply.create({
			data: {
				id: newReplyId,
				authorId: user.id,
				content: {
					create: {
						text: content,
					},
				},
				topParentId: params.post,
				parentReplyId: replyId,
			},
		})

		if (user.id != replypost.authorId)
			await prisma.notification.create({
				data: {
					type: replyId
						? NotificationType.ForumReplyReply
						: NotificationType.ForumPostReply,
					senderId: user.id,
					receiverId: replypost.authorId,
					note: `${user.username} replied to your ${
						replyId ? "reply" : "post"
					}: ${content}`,
					relativeId: newReplyId,
				},
			})
	},
	delete: async ({ url, locals }) => {
		const { user } = await authorise(locals)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "No reply id provided")

		const reply = await prisma.forumReply.findUnique({
			where: { id },
			select: {
				authorId: true,
				visibility: true,
			},
		})

		if (!reply) throw error(404, "Reply not found")

		if (reply.authorId != user.id)
			throw error(403, "You cannot delete someone else's reply")

		if (reply.visibility != "Visible")
			throw error(400, "Reply already deleted")

		await prisma.forumReply.update({
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
		if (!id) throw error(400, "No reply id provided")

		try {
			await prisma.forumReply.update({
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
			throw error(404, "Reply not found")
		}
	},
	like: categoryActions.like as any,
}
