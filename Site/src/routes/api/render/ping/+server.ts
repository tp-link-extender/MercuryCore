import { db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import pingQuery from "./ping.surql"

export async function GET({ url }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.RCC_KEY) error(400, "Nerd")

	await db.query(pingQuery)
	return new Response()
}
