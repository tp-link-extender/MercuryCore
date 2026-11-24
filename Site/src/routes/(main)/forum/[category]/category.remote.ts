import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { categoryPage } from "#lib/server/db/forums.ts"
import exclude from "#lib/server/exclude.ts"
import { Record } from "#lib/server/surreal.ts"
import { getRequestEvent, query } from "$app/server"

const schema = type("string")

export const getCategory = query(schema, async name => {
	exclude("Forum")

	const { locals, url } = getRequestEvent()
	const { user } = await authorise(locals)

	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(Number(pageQ)) ? 1 : Math.round(Number(pageQ))
	if (page < 1) redirect(303, `/forum/${name}?p=1`)

	const { category, pages } = await categoryPage(
		name,
		page,
		Record("user", user.id)
	)
	if (!category) error(404, "Not Found")
	if (page > pages) redirect(303, `/forum/${name}?p=${pages}`)

	return { ...category, pages }
})
