import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { multiSquery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeSwitch } from "$lib/server/like.js"

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
		posts = (
			await multiSquery(
				surql`
					LET $posts = (SELECT * FROM (SELECT * FROM forumCategory:Category<-in).in);

					RETURN function($posts, ($posts<-posted[0]<-user[0])) {
						const [posts, users] = arguments
						for (const i in posts) {
							posts[i].author = users[i]
						}
						return posts
					}
				`,
			)
		)?.[1]

	// console.log(posts)

	return {
		...category,
		posts,
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
			user.username,
			replyId ? "reply" : "post",
			id || replyId || "",
		)
	},
}
