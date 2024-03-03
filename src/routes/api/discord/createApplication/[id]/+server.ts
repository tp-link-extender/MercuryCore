import { query, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { verify, canApply } from "../../discord"

export async function POST({ url, params }) {
	verify(url)
	// Create a new application for the user
	const id = parseInt(params.id)
	if (!(await canApply(id))) error(400, "This user can't apply again")

	await query(
		surql`
			CREATE application CONTENT {
				discordId: $id,
				status: "Pending",
				created: time::now()
			}`,
		{ id }
	)

	return new Response("OK")
}
