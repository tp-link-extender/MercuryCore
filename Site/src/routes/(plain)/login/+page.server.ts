import config from "$lib/server/config"
import accountRegistered from "../accountRegistered"

export const load = async () => ({
	users: await accountRegistered(),
	descriptions: Object.entries(config.Branding.Descriptions),
})
