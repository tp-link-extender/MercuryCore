import config from "#lib/server/config.ts"
import { activeBanners } from "#lib/server/db/banners.ts"
import type { LayoutServerLoadEvent } from "./$types"
import getNotifications from "./notifications"

export async function load({ locals, url }: LayoutServerLoadEvent) {
	const { user } = locals
	// No authorise() function call, as we don't want to redirect to login page if not logged in

	const banners = await activeBanners()
	return {
		banners,
		currencySymbol: config.CurrencySymbol,
		domain: config.Domain,
		longTagline: config.Branding.LongTagline,
		notifications: await getNotifications(user),
		pages: config.Pages,
		siteName: config.Name,
		tagline: config.Branding.Tagline,
		// event.url, not request.url: data requests for client-side navigations end in __data.json and carry x-sveltekit-invalidated, which would end up in the links built from this
		url: url.href,
		user,
	}
}
