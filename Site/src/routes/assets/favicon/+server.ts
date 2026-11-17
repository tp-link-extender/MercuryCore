import config from "#lib/server/config.ts"

// TODO: imports would be nice
export const GET = () =>
	new Response(Bun.file(`../Assets/${config.Branding.Favicon}`))
