import { query, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function GET({ url }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey !== process.env.RCC_KEY) error(400, "Nerd")

	await query(surql`UPDATE stuff:ping SET render = time::now()`)

	return new Response()
}
