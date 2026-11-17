import config from "#lib/server/config.ts"

export const GET = () =>
	new Response(Bun.file(`../Assets/${config.Branding.Icon}`))
