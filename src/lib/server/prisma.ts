import { PrismaClient } from "@prisma/client"
import { client, roQuery } from "./redis"

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

export async function findGroups(query: any) {
	const groups = await prisma.group.findMany(query)

	// Add members and followers to each group
	for (let group of groups as any) {
		const query = {
			params: {
				group: group.name,
			},
		}
		group["members"] = await roQuery("RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))", query, true)
		group["followers"] = await roQuery("RETURN SIZE((:User) -[:follows]-> (:Group { name: $group }))", query, true)
	}
	return groups
}

type User = {
	id?: string
	number?: number
	username?: string
}
export async function transaction(sender: User, receiver: User, amountSent: number) {
	// balance of both parties should have been checked already by now
	// the user accounts also had better exist or else

	const sender2 = await prisma.user.findUnique({
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

	await prisma.user.update({
		where: sender,
		data: {
			currency: {
				decrement: amountSent,
			},
		},
	})
	await prisma.user.update({
		where: receiver,
		data: {
			currency: {
				increment: finalAmount,
			},
		},
	})

	await prisma.transaction.create({
		data: {
			sender: {
				connect: sender,
			},
			receiver: {
				connect: receiver,
			},
			amountSent,
			taxRate,
		},
	})
}
