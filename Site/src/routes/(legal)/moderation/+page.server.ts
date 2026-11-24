import { redirect } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { activeModerationOf } from "#lib/server/db/moderation.ts"
import type { PageServerLoadEvent } from "./$types"

async function getModeration(id: string) {
	const moderation = await activeModerationOf(id)
	if (!moderation) redirect(302, "/home")

	return moderation
}

// Make sure a user has been moderated before loading the page.
// The moderation page itself must allow moderated users through, or they would be redirected back to it forever.
export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals, undefined, true)
	return getModeration(user.id)
}
