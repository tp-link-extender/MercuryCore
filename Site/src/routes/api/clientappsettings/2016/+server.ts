import { json } from "@sveltejs/kit"
import settings from "./settings2016.json"

export const GET = () => json(settings)
