import { query, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { verify } from "../../discord"

export async function POST({ request, url, params }) {
	verify(url)
	// Ban user by id from applying
	const id = parseInt(params.id)
	let data: {
		reason: string
	}
	try {
		data = await request.json()
	} catch {
		error(400, "Invalid JSON")
	}

	const { reason } = data
	if (!reason) error(400, "Missing reason")

	await query(
		surql`
			CREATE $ban CONTENT {
				created: time::now(),
				reason: $reason
			}`,
		{
			ban: `applicationBan:${id}`,
			reason,
		}
	)

	return new Response("OK")
}
