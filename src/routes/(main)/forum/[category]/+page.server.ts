import { authorise } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeActions } from "$lib/server/like"
import { publish } from "$lib/server/realtime"

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

const select = (thing: string) =>
	squery<{
		id: string
		score: number
	}>(
		surql`
			SELECT
				meta::id(id) AS id,
				count(<-likes<-user) - count(<-dislikes<-user) AS score
			FROM $thing`,
		{ thing }
	)

export const actions: import("./$types").Actions = {}
actions.like = async ({ request, locals, params, url }) => {
	const { user } = await authorise(locals)
	const action = (await formData(request)).action as keyof typeof likeActions
	const id = url.searchParams.get("id")
	const replyId = url.searchParams.get("rid")

	const foundPost = id ? await select(`forumPost:${id}`) : null
	const foundReply = replyId ? await select(`forumReply:${replyId}`) : null

	if (!foundPost && !foundReply) error(404)

	const likes = await likeActions[action](
		user.id,
		`forum${foundPost ? "Post" : "Reply"}:${id || replyId}`
	)

	if (foundPost) {
		// waiting for the likeAction to complete first doesn't work
		foundPost.score = likes
		await publish(`forum:${params.category}`, foundPost)
	} else if (foundReply) {
		foundReply.score = likes
		await publish(`forum:${params.category}`, foundReply)
	}
}
