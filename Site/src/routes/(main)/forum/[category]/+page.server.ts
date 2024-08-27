import { idRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import exclude from "$lib/server/exclude"
import formData from "$lib/server/formData"
import { likeScoreActions } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import { Record, type RecordIdTypes, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import categoryQuery from "./category.surql"

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
	if (!config.Pages.includes("forum")) error(404, "Not Found")
	const { user } = await authorise(locals)

	const [[category]] = await equery<Category[][]>(categoryQuery, {
		...params,
		user: Record("user", user.id),
	})
	if (!category) error(404, "Not found")
	return category
}

type Thing = {
	id: string
	score: number
}

async function select(table: keyof RecordIdTypes, id: string) {
	const [[thing]] = await equery<Thing[][]>(
		surql`
			SELECT
				meta::id(id) AS id,
				count(<-likes) - count(<-dislikes) AS score
			FROM ${Record(table, id)}`
	)
	return thing
}

export const actions: import("./$types").Actions = {}
actions.like = async ({ request, locals, url }) => {
	exclude("Forum")
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as keyof typeof likeScoreActions
	const id = url.searchParams.get("id")
	const replyId = url.searchParams.get("rid")
	if (replyId && !idRegex.test(replyId)) error(400, "Invalid reply id")

	const foundPost = id ? await select("forumPost", id) : null
	const foundReply = replyId ? await select("forumReply", replyId) : null
	if (!foundPost || !foundReply) error(404)

	const type = foundPost ? "Post" : "Reply"
	await likeScoreActions[action](
		user.id,
		Record(`forum${type}`, (id || replyId) as string)
	)
}
