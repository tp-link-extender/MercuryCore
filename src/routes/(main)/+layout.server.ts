import type { PageServerLoad } from "./$types"

export const load: PageServerLoad = async ({ url: { pathname } }) => {
	return { pathname }
}