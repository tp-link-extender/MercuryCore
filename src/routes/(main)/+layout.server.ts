import type { LayoutServerLoad } from "./$types"
import { authorise } from "$lib/server/lucia"

// Most pages on the site require a user to be logged in.
export const load: LayoutServerLoad = async ({ locals }) => await authorise(locals.validate)
