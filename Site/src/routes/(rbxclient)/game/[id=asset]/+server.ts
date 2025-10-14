import { error } from "@sveltejs/kit"
// import { GAMESERVER_KEY } from "$env/static/private"
import { find } from "$lib/server/surreal"

export async function GET({ params, request }) {
	// get bearer token from header instead of insecure url (temporarily disabled)
    // const auth = request.headers.get("Authorization")
	// if (!auth || !auth.startsWith("Bearer ") || auth.slice(7) !== GAMESERVER_KEY)
	// 	throw error(403, "Unauthorised")

	const id = +params.id
	if (!(await find("place", id))) error(404, "Not Found")

	const file = Bun.file(`../data/places/${id}`)
	if (!(await file.exists())) return error(404, "File not found")

	return new Response(file)
}
