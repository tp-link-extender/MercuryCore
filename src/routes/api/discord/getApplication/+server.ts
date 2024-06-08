import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { verify } from "../discord.ts"
import getApplicationsQuery from "./getApplications.surql"

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
	const [applications] = await equery<Application[]>(getApplicationsQuery)
	return json(applications)
}
