import { dbQuery } from "#lib/server/db/query.ts"
import activeQuery from "./banners/active.surql"

export interface Banner {
	bgColour: string
	body: string
	id: string
	textLight: boolean
}

/** Finds the banners shown on every page. */
export async function activeBanners(): Promise<Banner[]> {
	const [banners] = await dbQuery<Banner[][]>(activeQuery)
	return banners
}
