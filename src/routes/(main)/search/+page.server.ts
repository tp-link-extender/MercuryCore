import { prisma, findPlaces, findItems, findGroups } from "$lib/server/prisma"
import formData from "$lib/server/formData"
import { error, redirect } from "@sveltejs/kit"

export const load = async ({ url }) => {
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) throw error(400, "No query provided")
	if (category && !["users", "places", "items", "groups"].includes(category))
		throw error(400, "Invalid category")

	console.log(`search for ${query} in ${category}`)

	if (category == "users") {
		const user = await prisma.authUser.findUnique({
			where: {
				username: query,
			},
		})
		if (user) throw redirect(302, `/user/${user.number}`)
	}

	return {
		query,
		category,
		users:
			category == "users"
				? prisma.authUser.findMany({
						where: {
							username: {
								contains: query,
								mode: "insensitive",
							},
						},
						select: {
							number: true,
							username: true,
							image: true,
							status: true,
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
						select: {
							gameSessions: {
								where: {
									ping: {
										gt: Math.floor(Date.now() / 1000) - 35,
									},
								},
								select: {
									valid: true,
								},
							},
							id: true,
							name: true,
							image: true,
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
						select: {
							id: true,
							name: true,
							price: true,
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
						select: {
							name: true,
						},
				  })
				: null,
	}
}

export const actions = {
	default: async ({ request }) => {
		const data = await formData(request)
		const query = data.query
		const category = data.category
		console.log(`searching for ${query} in ${category}`)

		throw redirect(
			302,
			`/search?q=${query}${category ? `&c=${category}` : ""}`
		)
	},
}
