import { PrismaClient } from "@prisma/client"
import { roQuery } from "./redis"

export const prisma = new PrismaClient()

export async function findPlaces(query: any) {
	const places = await prisma.place.findMany(query)

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

export async function findItems(query: any) {
	const items = await prisma.item.findMany(query)

	// Add like/dislike ratio to each item
	for (let item of items as any) {
		let ratio = Math.floor(
			(await roQuery(
				`
				RETURN (SIZE(() -[:likes]-> (:Item { name: $itemid })))
				/ (SIZE(() -[:likes|dislikes]-> (:Item { name: $itemid })))
				`,
				{
					params: {
						itemid: item.id,
					},
				},
				true
			)) * 100
		)
		item["ratio"] = isNaN(ratio) ? "--" : ratio
	}
	return items
}
