import { authorise } from "$lib/server/lucia"
import { squery, surql, find } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeActions } from "$lib/server/like"

type Category = {
	description: string
	name: string
	posts: {
		author: {
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}
		content: {
			text?: string
		}[]
		dislikes: boolean
		id: string
		likes: boolean
		pinned: boolean
		posted: string
		score: number
		title: string
		visibility: string
	}[]
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const category = await squery<Category>(
		surql`
			SELECT
				*,
				(SELECT
					*,
					meta::id(id) AS id,
					(SELECT text, updated FROM $parent.content
					ORDER BY updated DESC) AS content,
					(SELECT number, status, username
					FROM <-posted<-user)[0] AS author,
					count(<-likes<-user) - count(<-dislikes<-user) AS score,
					($user ∈ <-likes<-user.id) AS likes,
					($user ∈ <-dislikes<-user.id) AS dislikes
				FROM $parent<-in.in
				ORDER BY pinned DESC, score DESC) AS posts
			OMIT id
			FROM forumCategory
			WHERE string::lowercase(name) = string::lowercase($category)`,
		{
			...params,
			user: `user:${user.id}`,
		}
	)

	if (!category) error(404, "Not found")

	return category
}

export const actions = {
	like: async ({ request, locals, url }) => {
		const { user } = await authorise(locals)
		const data = await formData(request)
		const action = data.action as keyof typeof likeActions
		const id = url.searchParams.get("id")
		const replyId = url.searchParams.get("rid")

		if (
			(id && !(await find(`forumPost:${id}`))) ||
			(replyId && !(await find(`forumReply:${replyId}`)))
		)
			error(404)

		await likeActions[action](
			user.id,
			`forum${replyId ? "Reply" : "Post"}:${id || replyId}`
		)
	},
}
