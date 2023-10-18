import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import "dotenv/config"

export async function GET({ url }) {
	const apiKey = url.searchParams.get("apiKey")
	if (!apiKey || apiKey != process.env.RCC_KEY) throw error(400, "Forget you")

	await query(surql`UPDATE stuff:ping SET render = time::now()`)

	return new Response()
}
