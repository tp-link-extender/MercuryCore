// A collection of functions useful for Prisma, as well
// as only needing to initialise PrismaClient once.

import { PrismaClient, type Group, type Item } from "@prisma/client"
import { client, roQuery } from "./redis"

export const prisma = new PrismaClient()

// Required because likes and dislikes are stored in RedisGraph,
// while the rest of the info for places is stored in Postgres.
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

// Required because likes and dislikes are stored in RedisGraph,
// while the rest of the info for items is stored in Postgres.
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
	return items as (Item & { ratio: any })[]
}

// Required because group members are stored in RedisGraph,
// while the rest of the info for groups is stored in Postgres.
export async function findGroups(query: any) {
	const groups = await prisma.group.findMany(query)

	// Add members to each group
	for (let group of groups as any)
		group["members"] = await roQuery(
			"RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))",
			{
				params: {
					group: group.name,
				},
			},
			true
		)

	return groups as (Group & { members: any })[]
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
