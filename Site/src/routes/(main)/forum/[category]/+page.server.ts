import { idRegex } from "$lib/paramTests"
import exclude from "$lib/server/exclude"
import formData from "$lib/server/formData"
import { likeScoreActions } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import { Record, type RecordIdTypes, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
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

export async function load({ locals, params, url }) {
	exclude("Forum")
	const { user } = await authorise(locals)
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) redirect(303, `/forum/${params.category}?p=1`)

	const [category, pages] = await equery<[Category, number]>(categoryQuery, {
		...params,
		page: 1,
		user: Record("user", user.id),
	})
	console.log(category, pages)
	if (!category) error(404, "Not found")
	if (page > pages) redirect(303, `/forum/${params.category}?p=${pages}`)

	return { ...category, pages }
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
