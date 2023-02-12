import type { Actions, PageServerLoad } from "./$types"
import { prisma, findPlaces } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ url }) => {
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) throw error(400, "No query provided")
	if (!["users", "places", "items"].includes(category.toLowerCase())) throw error(400, "Invalid category")

	return {
		query,
		category,
		users: prisma.user.findMany({
			where: {
				displayname: {
					search: query.replaceAll(" ", " | "),
				},
			},
		}),
		places: findPlaces({
			where: {
				name: {
					search: query.replaceAll(" ", " | "),
				},
			},
		}),
		items: prisma.item.findMany({
			where: {
				name: {
					search: query.replaceAll(" ", " | "),
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
