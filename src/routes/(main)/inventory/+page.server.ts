import { authorise } from "$lib/server/lucia"
import { RecordId, equery } from "$lib/server/surreal"
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
		user: new RecordId("user", id),
	})
	return assets
}

export const load = async ({ locals, url }) => {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string

	const assets = await getAssets(user.id, query)
	console.log(assets[0])
	return { query, assets }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const query = (await request.formData()).get("q") as string

	return { assets: await getAssets(user.id, query) }
}
