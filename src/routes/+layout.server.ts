import { auth } from "$lib/lucia"
import { handleSession } from "lucia-sveltekit"

export const load = auth.handleServerLoad(handleSession())
