import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { PageServerLoadEvent } from "./$types"
import bannersQuery from "./banners.surql"

interface BannerType {
	active: boolean
	bgColour: string
	body: string
	creator: BasicUser
	// bruce, it's been five years
	id: string
	textLight: boolean
}

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const [banners] = await dbQuery<BannerType[][]>(bannersQuery)
	return { banners }
}
