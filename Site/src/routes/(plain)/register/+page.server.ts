import config from "$lib/server/config"
import accountRegistered from "../accountRegistered"

const prefix = config.Registration.Keys.Prefix

export const load = async () => ({
	users: await accountRegistered(),
	regKeysEnabled: config.Registration.Keys.Enabled,
	emailsEnabled: config.Registration.Emails,
	prefix,
})
