import { query, surql } from "$lib/server/surreal"
import { verify } from "../../discord"

export async function POST({ url, params }) {
	verify(url)
	// Delete application by id?
	const id = parseInt(params.id)

	await query(
		surql`
			UPDATE application SET deleted = true
			WHERE discordId = $id`,
		{ id }
	)

	return new Response("OK")
}
