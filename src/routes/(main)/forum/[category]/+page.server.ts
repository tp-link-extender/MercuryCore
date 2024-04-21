import { authorise } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"
import { likeScoreActions } from "$lib/server/like"
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

type Thing = {
	id: string
	score: number
}

const select = (thing: string) =>
	squery<Thing>(
		surql`
			SELECT
				meta::id(id) AS id,
				count(<-likes) - count(<-dislikes) AS score
			FROM $thing`,
		{ thing }
	)

export const actions: import("./$types").Actions = {}
actions.like = async ({ request, locals, params, url }) => {
	const { user } = await authorise(locals)
	const action = (await formData(request)).action as keyof typeof likeScoreActions
	const id = url.searchParams.get("id")
	const replyId = url.searchParams.get("rid")

	if (replyId && !/^[0-9a-z]+$/.test(replyId)) error(400, "Invalid reply id")

	const foundPost = id ? await select(`forumPost:${id}`) : null
	const foundReply = replyId ? await select(`forumReply:${replyId}`) : null

	if (!foundPost === !foundReply) error(404)

	const type = foundPost ? "Post" : "Reply"
	const likes = await likeScoreActions[action](
		user.id,
		`forum${type}:${id || replyId}`
	)

	const thing = (foundPost || foundReply) as Thing

	thing.score = likes
	await publish(`forum:${params.category}`, {
		...thing,
		action,
		type,
		hash: user.realtimeHash,
	})
}
