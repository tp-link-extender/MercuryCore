import type { PageServerLoad } from "./$types"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async () => {
	throw error(404, "Nothing to see here")
}
