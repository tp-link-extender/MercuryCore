import { authorise } from "$lib/server/lucia"
import { json } from "@sveltejs/kit"
import getAssets from "../getAssets.ts"

export async function GET({ locals, url }) {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string
	return json(await getAssets(user.id, query))
}
