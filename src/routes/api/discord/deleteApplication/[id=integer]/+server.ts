import { equery, surql } from "$lib/server/surreal"
import { verify } from "../../discord.ts"

export async function POST({ url, params }) {
	verify(url)

	// Delete application by id
	await equery(
		surql`
			UPDATE (
				SELECT * FROM application WHERE discordId = ${params.id}
				ORDER BY created DESC LIMIT 1
			)[0] SET deleted = true`
	)

	return new Response()
}
