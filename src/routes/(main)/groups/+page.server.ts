import type { PageServerLoad, Actions } from "./$types"
import { findGroups } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	groups: findGroups({
		select: {
			name: true,
		},
	}),
})

export const actions: Actions = {
	default: async ({ request }) => {
		const filter = (await request.formData()).get("query") as string
		return {
			places: await findGroups({
				where: {
					name: {
						contains: filter,
						mode: "insensitive",
					},
				},
				select: {
					name: true,
				},
			}),
		}
	},
}
