import surql from "$lib/surrealtag"
import { prisma, findGroups } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error, redirect } from "@sveltejs/kit"

export const load = async ({ url }) => {
	const query = url.searchParams.get("q") || "",
		category = url.searchParams.get("c")?.toLowerCase() || ""

	if (!query) throw error(400, "No query provided")
	if (category && !["users", "places", "assets", "groups"].includes(category))
		throw error(400, "Invalid category")

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
							status: true,
						},
				  })
				: null,
		places:
			category == "places"
				? (squery(
						surql`
							SELECT
								string::split(type::string(id), ":")[1] AS id,
								name,
								serverPing,
								count(
									SELECT * FROM <-playing
									WHERE valid = true
										AND ping > time::now() - 35s
								) AS playerCount,
								count(<-likes) AS likeCount,
								count(<-dislikes) AS dislikeCount
							FROM place
							WHERE !privateServer
								AND !deleted
								AND string::lowercase($query) ∈ string::lowercase(name)`,
						{ query },
				  ) as Promise<
						{
							id: string
							name: string
							playerCount: number
							serverPing: number
						}[]
				  >)
				: null,
		assets:
			category == "assets"
				? prisma.asset.findMany({
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
	default: async ({ url, request }) => {
		const data = await formData(request),
			{ query } = data,
			category = url.searchParams.get("c") || ""

		console.log(`searching for ${query} in ${category}`)

		throw redirect(
			302,
			`/search?q=${query}${category ? `&c=${category}` : ""}`,
		)
	},
}
