import config from "$lib/server/config.ts"
import { db } from "$lib/server/surreal"
import bannersQuery from "./banners.surql"
import getNotifications from "./notifications.ts"

type Banner = {
	// bruce, it's- I'm not doing this again
	id: string
	bgColour: string
	body: string
	textLight: boolean
}

export async function load({ locals, request }) {
	const { user } = locals
	// No authorise() function call, as we don't want to redirect to login page if not logged in

	const [banners] = await db.query<Banner[][]>(bannersQuery)
	return {
		banners,
		user,
		notifications: await getNotifications(user),
		url: request.url,
		domain: config.Domain,
		currencySymbol: config.CurrencySymbol,
		siteName: config.Name,
		tagline: config.Branding.Tagline,
		pages: config.Pages,
	}
}
