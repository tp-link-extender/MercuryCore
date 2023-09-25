import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeSwitch } from "$lib/server/like"

export async function load({ locals, params }) {
	const { user } = await authorise(locals),
		category = (await squery(
			surql`
                SELECT
                    *,
                    (SELECT
                        *,
                        (SELECT text FROM content[0]) AS content,
                        (SELECT number, username FROM <-posted<-user)[0] AS author,
                        count(<-likes<-user) AS likeCount,
                        count(<-dislikes<-user) AS dislikeCount,
                        ($user ∈ <-likes<-user.id) AS likes,
                        ($user ∈ <-dislikes<-user.id) AS dislikes
                    FROM $parent<-in.in) AS posts
                OMIT id
				FROM forumCategory
				WHERE string::lowercase(name) = string::lowercase($category)`,
			{
				...params,
				user: `user:${user.id}`,
			},
		)) as {
			description: string
			name: string
			posts: {
				author: {
					number: number
					username: string
				}
				content: {
					text?: string
				}[]
				dislikeCount: number
				dislikes: boolean
				id: string
				likeCount: number
				likes: boolean
				posted: string
				title: string
				visibility: string
			}[]
		}[]

	if (!(typeof category == "object" ? category : null)?.[0])
		throw error(404, "Not found")

	return category[0]
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
