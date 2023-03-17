// A collection of functions useful for Prisma, as well
// as only needing to initialise PrismaClient once.

import { PrismaClient } from "@prisma/client"
import type { Place, Item, Group, Prisma } from "@prisma/client"
import { client, roQuery } from "./redis"

export const prisma = new PrismaClient()

// Required because likes and dislikes are stored in RedisGraph,
// while the rest of the info for places is stored in Postgres.
export async function findPlaces(query: Prisma.PlaceFindManyArgs) {
	const places = await prisma.place.findMany(query)

	// Add like/dislike ratio to each place
	for (let place of places as (Place & { ratio: any })[]) {
		const query = {
			params: {
				place: place.id,
			},
		}
		const [likes, total] = await Promise.all([roQuery("places", "RETURN SIZE((:User) -[:likes]-> (:Place { name: $place }))", query, true), roQuery("places", "RETURN SIZE((:User) -[:likes|dislikes]-> (:Place { name: $place }))", query, true)])
		const ratio = Math.floor((likes / total) * 100)

		place["ratio"] = isNaN(ratio) ? "--" : ratio
	}
	return places
}

// Required because likes and dislikes are stored in RedisGraph,
// while the rest of the info for items is stored in Postgres.
export async function findItems(query: Prisma.ItemFindManyArgs) {
	const items = await prisma.item.findMany(query)

	// Add like/dislike ratio to each item
	for (let item of items as (Item & { ratio: any })[]) {
		const query = {
			params: {
				itemid: item.id,
			},
		}
		const [likes, total] = await Promise.all([roQuery("items", "RETURN SIZE((:User) -[:likes]-> (:Item { name: $itemid }))", query, true), roQuery("items", "RETURN SIZE((:User) -[:likes|dislikes]-> (:Item { name: $itemid }))", query, true)])
		const ratio = Math.floor((likes / total) * 100)
		item["ratio"] = isNaN(ratio) ? "--" : ratio
	}
	return items
}

// Required because group members are stored in RedisGraph,
// while the rest of the info for groups is stored in Postgres.
export async function findGroups(query: Prisma.GroupFindManyArgs) {
	const groups = await prisma.group.findMany(query)

	// Add members to each group
	for (let group of groups as (Group & { members: any })[])
		group["members"] = await roQuery(
			"groups",
			"RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))",
			{
				params: {
					group: group.name,
				},
			},
			true
		)

	return groups
}

type User = {
	id?: string
	number?: number
	username?: string
}
export async function transaction(sender: User, receiver: User, amountSent: number, { note, link }: { note: String | undefined; link: String | undefined }, tx: any /* awful */ = prisma) {
	const sender2 = await tx.user.findUnique({
		where: sender,
		select: {
			currency: true,
		},
	})
	if (!sender2) throw new Error("Sender not found")
	if (sender2.currency < amountSent) throw new Error(`Insufficient funds: You need ${amountSent - sender2.currency} more to buy this`)
	// const receiver2 = await prisma.user.findUnique({
	// 	where: receiver,
	// })
	// if (!receiver2) throw new Error("Receiver not found")

	const taxRate = Number((await client.get("taxRate")) || 30)
	const finalAmount = Math.round(amountSent * (1 - taxRate / 100))

	await tx.user.update({
		where: sender,
		data: {
			currency: {
				decrement: amountSent,
			},
		},
	})
	await tx.user.update({
		where: receiver,
		data: {
			currency: {
				increment: finalAmount,
			},
		},
	})

	await tx.transaction.create({
		data: {
			sender: {
				connect: sender,
			},
			receiver: {
				connect: receiver,
			},
			amountSent,
			taxRate,
			note,
			link,
		},
	})
}
