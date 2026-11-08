import config from "$lib/server/config"
import { db } from "$lib/server/surreal"
import type { LayoutServerLoadEvent } from "./$types"
import bannersQuery from "./banners.surql"
import getNotifications from "./notifications"

interface Banner {
	// bruce, it's- I'm not doing this again
	id: string
	bgColour: string
	body: string
	textLight: boolean
}

export async function load({ locals, request }: LayoutServerLoadEvent) {
	const { user } = locals
	// No authorise() function call, as we don't want to redirect to login page if not logged in

	const [banners] = await db.query<Banner[][]>(bannersQuery)
	return {
		banners,
		currencySymbol: config.CurrencySymbol,
		domain: config.Domain,
		longTagline: config.Branding.LongTagline,
		notifications: await getNotifications(user),
		pages: config.Pages,
		siteName: config.Name,
		tagline: config.Branding.Tagline,
		url: request.url,
		user,
	}
}
