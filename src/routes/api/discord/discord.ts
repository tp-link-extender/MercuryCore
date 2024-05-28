import { findWhere } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export function verify(url: URL) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.DISCORD_KEY) error(400, "Gfy")
}

export const canApply = async (discordId: string) =>
	!(await findWhere(
		"application",
		`discordId = $discordId
			AND deleted != true
			AND (status = "Pending"
				OR status = "Banned"
				OR status = "Denied" AND reviewed > time::now() - 3d)`,
		{ discordId }
	))
