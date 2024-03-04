import { query, surql } from "$lib/server/surreal"
import { verify } from "../../discord"

export async function POST({ url, params }) {
	verify(url)
	// Delete application by id

	await query(
		surql`
			UPDATE (
				SELECT * FROM application WHERE discordId = $id
				ORDER BY created DESC LIMIT 1
			)[0] SET deleted = true`,
		{ id: parseInt(params.id) }
	)

	return new Response()
}
