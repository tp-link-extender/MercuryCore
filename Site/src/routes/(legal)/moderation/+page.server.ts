import { redirect } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import getModerationQuery from "./getModeration.surql"

interface Moderation {
	note: string
	time: string
	timeEnds: string
	type: string
}

async function getModeration(id: string) {
	const [[moderation]] = await dbQuery<Moderation[][]>(getModerationQuery, {
		user: Record("user", id),
	})
	if (!moderation) redirect(302, "/home")

	return moderation
}

// Make sure a user has been moderated before loading the page.
// The moderation page itself must allow moderated users through, or they would be redirected back to it forever.
export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals, undefined, true)
	return getModeration(user.id)
}
