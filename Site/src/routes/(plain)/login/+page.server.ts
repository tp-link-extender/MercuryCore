import config from "$lib/server/config"
import accountRegistered from "../accountRegistered"

export const load = async () => ({
	descriptions: Object.entries(config.Branding.Descriptions),
	users: await accountRegistered(),
})
