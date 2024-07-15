import { authorise } from "$lib/server/lucia"
import getAssets from "./getAssets.ts"

export async function load({ locals, url }) {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string
	return { query, assets: await getAssets(user.id, query) }
}
