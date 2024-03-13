import { application } from "$lib/server/orm"
import { error } from "@sveltejs/kit"
import "dotenv/config"

export function verify(url: URL) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.DISCORD_KEY) error(400, "Gfy")
}

export const canApply = async (discordId: string) =>
	!(await application
		.where(
			[
				"deleted != true",
				"discordId = $discordId",
				`(status = "Pending"
					OR status = "Banned"
					OR status = "Denied" AND reviewed > time::now() - 1w)`,
			],
			{ discordId }
		)
		.find())
