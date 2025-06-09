import config from "$lib/server/config"

export const GET = () =>
	new Response(Bun.file(`../Assets/${config.Branding.Icon}`))
