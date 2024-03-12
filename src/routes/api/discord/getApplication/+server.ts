import { query, surql } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { verify } from "../discord"

export async function GET({ url }) {
	verify(url)
	// Get all pending applications

	const applications = await query<{
		discordId: string
		response: string[]
		created: string
		status: string
		reviewed: string
		reason: string | undefined
	}>(
		surql`
			SELECT
				discordId,
				response,
				created,
				status,
				reviewed,
				reason
			FROM application
			WHERE status = "Pending"
			ORDER BY created`
	)

	return json(applications)
}
