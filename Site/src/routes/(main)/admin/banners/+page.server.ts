import { authorise } from "$lib/server/auth"
import { db } from "$lib/server/surreal"
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

	const [banners] = await db.query<BannerType[][]>(bannersQuery)
	return { banners }
}
