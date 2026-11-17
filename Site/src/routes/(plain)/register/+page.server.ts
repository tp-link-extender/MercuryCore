import config from "#lib/server/config.ts"
import accountRegistered from "../accountRegistered"

const prefix = config.Registration.Keys.Prefix

export const load = async () => ({
	emailsEnabled: config.Registration.Emails,
	prefix,
	regKeysEnabled: config.Registration.Keys.Enabled,
	users: await accountRegistered(),
})
