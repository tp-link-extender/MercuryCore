import { read } from "$app/server"
import config from "$lib/server/config"

export const GET = () => read(`/../Assets/${config.Branding.Icon}`)
