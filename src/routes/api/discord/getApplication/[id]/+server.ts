import { squery, surql } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { verify } from "../../discord"

export async function GET({ url, params }) {
	verify(url)
	// Get information about the application

	const application = await squery<{
		response: string[]
		created: string
		status: string
		reviewed: string
		reason: string | undefined
	}>(
		surql`
			SELECT
				response,
				created,
				status,
				reviewed,
				reason
			FROM application
			WHERE discordId = $id
			ORDER BY created DESC LIMIT 1`,
		{ id: params.id }
	)

	return json(application)
}
