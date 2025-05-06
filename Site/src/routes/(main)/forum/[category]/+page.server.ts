import { idRegex } from "$lib/paramTests"
import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import formData from "$lib/server/formData"
import { likeScoreActions } from "$lib/server/like"
import { Record, db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import categoryQuery from "./category.surql"
import replypostQuery from "./replypost.surql"

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

	const [category, pages] = await db.query<[Category, number]>(
		categoryQuery,
		{
			...params,
			page,
			user: Record("user", user.id),
		}
	)
	if (!category) error(404, "Not found")
	if (page > pages) redirect(303, `/forum/${params.category}?p=${pages}`)

	return { ...category, pages }
}

type Thing = {
	id: string
	score: number
}

async function select(replypost: "forumReply" | "forumPost", id: string) {
	const [[thing]] = await db.query<Thing[][]>(replypostQuery, {
		replypost: Record(replypost, id),
	})
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

	const ids = id || replyId
	if (!ids) error(400, "Missing id")

	const type = id ? "Post" : "Reply"
	if (!(await select(`forum${type}`, ids))) error(404, `${type} not found`)

	await likeScoreActions[action](user.id, Record(`forum${type}`, ids))
}
