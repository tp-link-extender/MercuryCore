// A collection of functions useful for Prisma, as well
// as only needing to initialise PrismaClient once.

import cql from "$lib/cyphertag"
import { building } from "$app/environment"
import { PrismaClient } from "@prisma/client"
import type { Prisma } from "@prisma/client"
import { client, roQuery } from "./redis"

let prisma: PrismaClient

if (!building) {
	prisma = new PrismaClient()
	console.log("loaded prisma")
}

export { prisma }

/**
 * Finds places in the database, and adds a like/dislike ratio to each place. Required because likes and dislikes are stored in RedisGraph, while the rest of the info for places is stored in Postgres.
 * @param query The prisma query to execute.
 * @returns The result of the query, with the like/dislike ratio added to each place.
 * @example
 * const places = await findPlaces({
 * 	where: {
 * 		privateServer: false,
 * 	},
 * })
 */
export async function findPlaces(query: Prisma.PlaceFindManyArgs = {}) {
	const places = await prisma.place.findMany(query)

	// Add like/dislike ratio to each place
	for (const place of places as typeof places & { ratio: number | "--" }[]) {
		const query = {
			place: place.id,
		}
		const [likes, total] = await Promise.all([
			roQuery(
				"places",
				cql`RETURN SIZE((:User) -[:likes]-> (:Place { name: $place }))`,
				query,
				true,
			),
			roQuery(
				"places",
				cql`RETURN SIZE((:User) -[:likes|dislikes]-> (:Place { name: $place }))`,
				query,
				true,
			),
		])
		const ratio = Math.floor((likes / total) * 100)

		place["ratio"] = isNaN(ratio) ? "--" : ratio
	}
	return places as typeof places & { ratio: number | "--" }[]
}

/**
 * Finds avatar shoitems in the database, and adds a like/dislike ratio to each place. Required because group members are stored in RedisGraph, while the rest of the info for groups is stored in Postgres.
 * @param query The prisma query to execute.
 * @returns The result of the query, with the like/dislike ratio added to each place.
 * @example
 * const places = await findPlaces({
 * 	where: {
 * 		name: {
 * 			contains: search,
 * 		}
 * 	},
 * })
 */
export async function findGroups(query: Prisma.GroupFindManyArgs = {}) {
	const groups = await prisma.group.findMany(query)

	// Add members to each group
	for (const group of groups as typeof groups & { members: any }[])
		group["members"] = await roQuery(
			"groups",
			cql`RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))`,
			{
				group: group.name,
			},
			true,
		)

	return groups as typeof groups & { members: any }[]
}

type User = {
	id?: string
	number?: number
	username?: string
}
/**
 * Transfers currency from one user to another, and creates a transaction in the database.
 * @param sender An object containing the id, number or username of the user sending the currency.
 * @param receiver An object containing the id, number or username of the user receiving the currency.
 * @param amountSent The amount of currency to send.
 * @param notelink An object containing a note for the transaction, as well as a link to what the transaction was for if possible.
 * @param tx A prisma transaction object, if it needs to be rolled back when an error occurs.
 */
export async function transaction(
	sender: User,
	receiver: User,
	amountSent: number,
	{ note, link }: { note?: String; link?: String },
	tx: any /* awful */ = prisma,
) {
	const sender2 = await tx.authUser.findUnique({
		where: sender,
		select: {
			currency: true,
		},
	})
	if (!sender2) throw new Error("Sender not found")
	if (sender2.currency < amountSent)
		throw new Error(
			`Insufficient funds: You need ${
				amountSent - sender2.currency
			} more to buy this`,
		)
	// const receiver2 = await prisma.authUser.findUnique({
	// 	where: receiver,
	// })
	// if (!receiver2) throw new Error("Receiver not found")

	const taxRate = Number((await client.get("taxRate")) || 30)
	const finalAmount = Math.round(amountSent * (1 - taxRate / 100))

	await tx.authUser.update({
		where: sender,
		data: {
			currency: {
				decrement: amountSent,
			},
		},
	})
	await tx.authUser.update({
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
