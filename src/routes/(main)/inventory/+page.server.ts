import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal"
import inventoryQuery from "./inventory.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
}

async function getAssets(id: string, query: string) {
	const [assets] = await equery<Asset[][]>(inventoryQuery, {
		query,
		user: Record("user", id),
	})
	return assets
}

export const load = async ({ locals, url }) => {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string

	return { query, assets: await getAssets(user.id, query) }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const query = (await request.formData()).get("q") as string

	return { assets: await getAssets(user.id, query) }
}
