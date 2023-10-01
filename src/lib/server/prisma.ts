// A collection of functions useful for Prisma, as well
// as only needing to initialise PrismaClient once.

import cql from "$lib/cyphertag"
import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { building } from "$app/environment"
import { PrismaClient } from "@prisma/client"
import type { Prisma } from "@prisma/client"
import { roQuery } from "./redis"

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
			},
			[likes, total] = await Promise.all([
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
			]),
			ratio = Math.floor((likes / total) * 100)

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

const failed = "The query was not executed due to a failed transaction"
/**
 * Transfers currency from one user to another, and creates a transaction in the database.
 * @param sender An object containing the id or number of the user sending the currency.
 * @param receiver An object containing the id or number of the user receiving the currency.
 * @param amountSent The amount of currency to send.
 * @param notelink An object containing a note for the transaction, as well as a link to what the transaction was for if possible.
 */
export async function transaction(
	sender: { id?: string; number?: 1 },
	receiver: { id?: string; number?: 1 },
	amountSent: number,
	{ note, link }: { note?: String; link?: String },
) {
	// TODO: ADD A CALLBACK OR SOMETHING
	// so we know when (if) the transaction succeeds


	const query = (await squery(
		surql`
			BEGIN TRANSACTION; # lmfao

			LET $taxRate = stuff:economy.taxRate OR 30;

			LET $sender = (SELECT
				id,
				currency,
				number
			FROM user WHERE number = $senderNumber OR id = $senderId)[0];
			IF !$sender {
				THROW "Sender not found"
			};

			LET $receiver = (SELECT
				id,
				currency,
				number
			FROM user WHERE number = $receiverNumber OR id = $receiverId)[0];
			IF !$receiver {
				THROW "Receiver not found"
			};

			LET $senderAdmin = $sender.number == 1;
			LET $receiverAdmin = $receiver.number == 1;

			IF $amountSent > 0 {
				IF /*!$senderAdmin AND*/ $sender.currency < $amountSent {
					THROW string::join(" ", "Insufficient funds: You need", $amountSent - $sender.currency, "more to buy this")
				};

				LET $finalAmount = math::round($amountSent * (1 - $taxRate / 100));

				UPDATE $sender SET currency -= 
					IF $senderAdmin THEN
						0
					ELSE
						$amountSent
					END;

				UPDATE $receiver SET currency += 
					IF $receiverAdmin THEN
						0
					ELSE
						$finalAmount
					END;
			};

			RELATE $sender->transaction->$receiver CONTENT {
				amountSent: $amountSent,
				taxRate: $taxRate,
				note: $note,
				link: $link,
				time: time::now(),
			};

			COMMIT TRANSACTION`,
		{
			...(sender?.number
				? { senderNumber: sender.number }
				: { senderId: sender.id }),
			...(receiver?.number
				? { receiverNumber: receiver.number }
				: { receiverId: receiver.id }),
			amountSent,
			note,
			link,
		},
	)) as
		| string[]
		| {
				amountSent: number
				taxRate: number
				note: string
				link: string
				time: string
		  }[]

	for (const result of query)
		if (result == failed)
			for (const result2 of query)
				if (typeof result2 == "string" && result2 != failed)
					throw result2.match(/"An error occured: (.*)"/)?.[1]
}
