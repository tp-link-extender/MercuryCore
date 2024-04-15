import { query } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { verify } from "../discord"

type Application = {
	discordId: string
	response: string[]
	created: string
	status: string
	reviewed: string
	reason: string | undefined
}

export async function GET({ url }) {
	verify(url)
	// Get all pending applications

	const applications = await query<Application>(
		import("./getApplications.surql")
	)

	return json(applications)
}
