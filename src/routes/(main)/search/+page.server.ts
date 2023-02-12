import type { Actions, PageServerLoad } from "./$types"
import { prisma, findPlaces, findItems } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ url }) => {
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) throw error(400, "No query provided")
	if (category && !["users", "places", "items"].includes(category)) throw error(400, "Invalid category")

	return {
		query,
		category,
		users: prisma.user.findMany({
			where: {
				displayname: {
					contains: query,
					mode: "insensitive",
				},
			},
		}),
		places: findPlaces({
			where: {
				name: {
					contains: query,
					mode: "insensitive",
				},
			},
		}),
		items: findItems({
			where: {
				name: {
					contains: query,
					mode: "insensitive",
				},
			},
		}),
	}
}

export const actions: Actions = {
	default: async ({ request }) => {
		const data = await request.formData()
		const query = data.get("query")?.toString() || ""
		const category = data.get("category")?.toString() || ""
		console.log(query)

		const user = await prisma.user.findUnique({
			where: {
				username: query,
			},
			select: {
				number: true,
			},
		})
		if (user && category == "users") throw redirect(302, `/user/${user.number}`)

		throw redirect(302, `/search?q=${query}${category ? `&c=${category}` : ""}`)
	},
}
