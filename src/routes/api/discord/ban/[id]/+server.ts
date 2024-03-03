import { query, surql } from "$lib/server/surreal"
import { verify } from "../../discord"

export async function POST({ url, params }) {
	verify(url)
	// Ban user by id from applying
	const id = parseInt(params.id)

	await query(
		surql`CREATE $ban SET created = time::now()`,
		{ ban: `applicationBan:${id}` }
	)

	return new Response("OK")
}
