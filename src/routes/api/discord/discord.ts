import { squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export function verify(url: URL) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.DISCORD_KEY) error(400, "Gfy")
}

export const canApply = async (discordId: number) =>
	!(await squery(
		surql`
			SELECT 1 FROM application
			WHERE discordId = $discordId
				AND (status = "Pending"
					OR status = "Denied" AND reviewed > time::now() - 1w)`,
		{ discordId }
	))
