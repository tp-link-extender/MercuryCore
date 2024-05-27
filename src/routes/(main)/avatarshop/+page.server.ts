import { authorise } from "$lib/server/lucia"
import { equery } from "$lib/server/surreal"
import avatarshopQuery from "./avatarshop.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export const load = async () => {
	const [assets] = await equery<Asset[][]>(avatarshopQuery)
	return { assets }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals }) => {
	await authorise(locals)

	const query = (await request.formData()).get("q") as string
	const [assets] = await equery<Asset[][]>(avatarshopQuery, { query })
	return { assets }
}
