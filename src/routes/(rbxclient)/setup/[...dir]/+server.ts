import type { RequestHandler } from "./$types"
import { error } from "@sveltejs/kit"
import fs from "fs"

export const GET: RequestHandler = async ({ url }) => {
	try {
		return new Response(fs.readFileSync(`./setup/${url.pathname.match(/\/setup\/(.+)/)?.[1]}`).toString())
	} catch {
		throw error(404, "Not Found")
	}
}
