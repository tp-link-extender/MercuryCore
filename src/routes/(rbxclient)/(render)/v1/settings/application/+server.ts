import { json } from "@sveltejs/kit"
import settings from "./settings.json"

export const GET = () => json(settings)
