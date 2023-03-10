import { findGroups } from "$lib/server/prisma"

export const load = async () => ({
	groups: findGroups({
		select: {
			name: true,
		},
	}),
})

export const actions = {
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
