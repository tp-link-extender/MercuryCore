import { PrismaClient } from "@prisma/client"

export const prisma = new PrismaClient()

export async function findPlaces(query: any) {
	const places = await prisma.place.findMany(query)
	const roQuery = (await import("$lib/server/redis")).roQuery

	// Add like/dislike ratio to each place
	for (let place of places as any) {
		let ratio = Math.floor(
			(await roQuery(
				`
				RETURN (SIZE(() -[:likes]-> (:Place { name: $place })))
				/ (SIZE(() -[:likes|dislikes]-> (:Place { name: $place })))
				`,
				{
					params: {
						place: place.slug,
					},
				},
				true
			)) * 100
		)
		place["ratio"] = isNaN(ratio) ? "--" : ratio
	}
	return places
}
