import { error } from "@sveltejs/kit"
import { RCC_KEY } from "$env/static/private"
import { db } from "$lib/server/surreal"
import pingQuery from "./ping.surql"

export async function GET({ url }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== RCC_KEY) error(400, "Nerd")

	await db.query(pingQuery)
	return new Response()
}
