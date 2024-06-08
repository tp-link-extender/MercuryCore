import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { verify } from "../../discord.ts"
import getApplicationQuery from "./getApplication.surql"

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
	const [[application]] = await equery<Application[][]>(getApplicationQuery, {
		id: params.id,
	})
	return json(application)
}
