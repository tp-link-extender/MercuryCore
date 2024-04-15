import { squery, surql } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { verify } from "../../discord"

type Application = {
	response: string[]
	created: string
	status: string
	reviewed: string
	reason: string | undefined
}

export async function GET({ url, params }) {
	verify(url)
	// Get information about the application

	const application = await squery<Application>(
		import("./getApplication.surql"),
		{ id: params.id }
	)

	return json(application)
}
