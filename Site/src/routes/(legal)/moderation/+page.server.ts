import { redirect } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import getModerationQuery from "./getModeration.surql"

interface Moderation {
	note: string
	time: string
	timeEnds: string
	type: string
}

async function getModeration(id: string) {
	const [[moderation]] = await db.query<Moderation[][]>(getModerationQuery, {
		user: Record("user", id),
	})
	if (!moderation) redirect(302, "/home")

	return moderation
}

// Make sure a user has been moderated before loading the page.
export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	return getModeration(user.id)
}
