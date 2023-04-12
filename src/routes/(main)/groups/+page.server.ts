import { findGroups } from "$lib/server/prisma"

export const load = () => ({
	groups: findGroups({
		select: {
			name: true,
		},
	}),
})

export const actions = {
	default: async ({ request }) => ({
		places: await findGroups({
			where: {
				name: {
					contains: (await request.formData()).get("query") as string,
					mode: "insensitive",
				},
			},
			// When returning from an action, remember to only select
			// the data needed, as it will by sent directly to the client.
			select: {
				name: true,
			},
		}),
	}),
}
