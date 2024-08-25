import config from "$lib/server/config.ts"
import { equery, surql } from "$lib/server/surreal"
import getNotifications from "./notifications.ts"

type Banner = {
	// bruce, it's- I'm not doing this again
	id: string
	bgColour: string
	body: string
	textLight: boolean
}

export async function load({ request, locals }) {
	const { user } = locals
	// No authorise() function call, as we don't want to redirect to login page if not logged in

	const [banners] = await equery<Banner[][]>(surql`
		SELECT
			body,
			bgColour,
			textLight,
			meta::id(id) AS id
		OMIT deleted
		FROM banner WHERE !deleted AND active`)
	return {
		banners,
		user,
		notifications: await getNotifications(user),
		url: request.url,
		domain: config.Domain,
		currencySymbol: config.CurrencySymbol,
		siteName: config.Name,
		tagline: config.Branding.Tagline,
	}
}
