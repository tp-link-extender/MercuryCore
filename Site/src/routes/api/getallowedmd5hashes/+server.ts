import config from "#lib/server/config.ts"

export const GET = () => Response.json({ data: config.AllowedMD5Hashes })
