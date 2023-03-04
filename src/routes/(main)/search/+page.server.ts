import type { PageServerLoad, Actions } from "./$types"
import { prisma, findPlaces, findItems, findGroups } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ url }) => {
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) throw error(400, "No query provided")
	if (category && !["users", "places", "items", "groups"].includes(category)) throw error(400, "Invalid category")

	console.log(`search for ${query} in ${category}`)

	if (category == "users") {
		const user = await prisma.user.findUnique({
			where: {
				username: query,
			},
			select: {
				number: true,
			},
		})
		if (user) throw redirect(302, `/user/${user.number}`)
	}

	return {
		query,
		category,
		users:
			category == "users"
				? prisma.user.findMany({
						where: {
							displayname: {
								contains: query,
								mode: "insensitive",
							},
						},
				  })
				: null,
		places:
			category == "places"
				? findPlaces({
						where: {
							name: {
								contains: query,
								mode: "insensitive",
							},
							privateServer: false,
						},
				  })
				: null,
		items:
			category == "items"
				? findItems({
						where: {
							name: {
								contains: query,
								mode: "insensitive",
							},
						},
				  })
				: null,
		groups:
			category == "groups"
				? findGroups({
						where: {
							name: {
								contains: query,
								mode: "insensitive",
							},
						},
				  })
				: null,
	}
}

export const actions: Actions = {
	default: async ({ request }) => {
		const data = await request.formData()
		const query = data.get("query")?.toString() || ""
		const category = data.get("category")?.toString() || ""
		console.log(`searching for ${query} in ${category}`)

		throw redirect(302, `/search?q=${query}${category ? `&c=${category}` : ""}`)
	},
}
