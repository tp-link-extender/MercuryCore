import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeSwitch } from "$lib/server/like"

export async function load({ locals, params }) {
	const category = (
		await prisma.forumCategory.findMany({
			where: {
				name: {
					equals: params.category,
					mode: "insensitive",
				},
			},
		})
	)[0]

	if (!category) throw error(404, "Not found")

	const { user } = await authorise(locals),
		posts = await squery(
			surql`
                SELECT
                    *,
                    content[0] as content,
                    (SELECT number, username FROM <-posted<-user)[0] as author,
                    count(SELECT * FROM <-likes<-user) as likeCount,
                    count(SELECT * FROM <-dislikes<-user) as dislikeCount,
                    ($user ∈ (SELECT * FROM <-likes<-user).id) as likes,
                    ($user ∈ (SELECT * FROM <-dislikes<-user).id) as dislikes

				FROM (SELECT * FROM $forumCategory<-in).in`,
			{
				user: `user:${user.id}`,
				forumCategory: `forumCategory:${category.name}`,
			},
		)

	return {
		...category,
		posts: posts as {
			author: {
				number: number
				username: string
			}
			content: {
				id: string
				text?: string
				updated: string
			}[]
			dislikeCount: number
			dislikes: boolean
			id: string
			likeCount: number
			likes: boolean
			posted: string
			title: string
			visibility: string
		}[],
	}
}

export const actions = {
	like: async ({ request, locals, url }) => {
		const { user } = await authorise(locals),
			data = await formData(request),
			{ action } = data,
			id = url.searchParams.get("id"),
			replyId = url.searchParams.get("rid")

		if (
			(id &&
				!(await prisma.forumPost.findUnique({
					where: { id },
				}))) ||
			(replyId &&
				!(await prisma.forumReply.findUnique({
					where: { id: replyId },
				})))
		)
			throw error(404)

		await likeSwitch(
			action,
			user.id,
			`${replyId ? "forumReply" : "forumPost"}:${id || replyId}`,
		)
	},
}
