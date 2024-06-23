import { json } from "@sveltejs/kit"
import settings from "../settings.toml"

export const GET = () => json(settings)
