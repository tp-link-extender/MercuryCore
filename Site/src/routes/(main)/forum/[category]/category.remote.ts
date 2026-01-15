import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { getRequestEvent, query } from "$app/server"
import type { Scored } from "$lib/like2"
import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import { db, Record } from "$lib/server/surreal"
import type { PreviewPost } from "../+page.server"
import categoryQuery from "./category.surql"

interface Post extends PreviewPost, Scored {
	pinned: boolean
	visibility: string
}

type Category = {
	name: string
	posts: Post[]
}

const schema = type("string")

export const getCategory = query(schema, async name => {
	exclude("Forum")

	const { locals, url } = getRequestEvent()
	const { user } = await authorise(locals)

	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) redirect(303, `/forum/${name}?p=1`)

	const [category, pages] = await db.query<[Category, number]>(
		categoryQuery,
		{
			category: name,
			page,
			user: Record("user", user.id),
		}
	)
	if (!category) error(404, "Not Found")
	if (page > pages) redirect(303, `/forum/${name}?p=${pages}`)

	return { ...category, pages }
})
