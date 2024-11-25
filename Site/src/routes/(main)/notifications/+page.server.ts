import { authorise } from "$lib/server/lucia"
import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import readQuery from "./read.surql"
import readAllQuery from "./readAll.surql"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)
	await db.query(readAllQuery, {
		user: Record("user", user.id),
	})
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, url }) => {
	const { user } = await authorise(locals)
	const id = url.searchParams.get("s")
	if (!id) error(400)

	try {
		await db.query(readQuery, {
			notification: Record("notification", id),
			user: Record("user", user.id),
		})
	} catch (e) {
		error(400)
	}
}
