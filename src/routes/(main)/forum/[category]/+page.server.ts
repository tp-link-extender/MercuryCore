import { authorise } from "$lib/server/lucia"
import { squery, find } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeActions } from "$lib/server/like"

type Category = {
	description: string
	name: string
	posts: {
		author: BasicUser
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
	const category = await squery<Category>(import("./category.surql"), {
		...params,
		user: `user:${user.id}`,
	})

	if (!category) error(404, "Not found")

	return category
}

export const actions: import("./$types").Actions = {}
actions.like = async ({ request, locals, url }) => {
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
}
