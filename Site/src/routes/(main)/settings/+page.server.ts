import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import { profileOf } from "#lib/server/db/accounts.ts"
import type { PageServerLoadEvent } from "./$types"

const themeNames = config.Themes.map(t => t.Name)

export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const profile = await profileOf(user.id)
	if (!profile) error(404, "User not found")

	return { profile, themes: themeNames }
}
