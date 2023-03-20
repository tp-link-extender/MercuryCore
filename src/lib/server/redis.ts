// A collection of functions useful for Redis, as well
// as only needing to initialise the Redis client once.

import { error } from "@sveltejs/kit"
import { createClient, Graph } from "redis"

export const client = createClient({ url: "redis://localhost:6479" })

console.log("loaded redis")
client.on("error", e => {
	console.error("Redis error", e)
	throw error(500, "Redis error")
})
await client.connect()

const graphs = {
	friends: new Graph(client, "friends"), // Stores follows, friends, requests, etc
	groups: new Graph(client, "groups"), // Stores groups, members, etc
	places: new Graph(client, "places"), // Stores likes and dislikes on places
	items: new Graph(client, "items"), // Stores likes and dislikes on avatar shop items
	forum: new Graph(client, "forum"), // Stores forum post and reply likes and dislikes
}

/**
 * A writable RedisGraph query.
 * @param graph The name of the graph to query, eg. friends, groups, etc.
 * @param query A query to execute, in Cypher.
 * @param params Parameters to pass to the query.
 * @returns the result of the query.
 * @example
 *	await Query(
 *		"places",
 *		`
 *			MERGE (u:User { name: $user })
 *			MERGE (p:Place { name: $id })
 *			MERGE (u) -[:likes]-> (p)
 *		`,
 *		{
 *			user: "Heliodex",
 *			id: "1",
 *		}
 *	)
 */
export const Query = (
	graph: keyof typeof graphs,
	query: string,
	params: { [k: string]: string | number }
) => graphs[graph].query(query, { params })

/**
 * A read-only query, cannot modify the graph.
 * @param graph The name of the graph to query, eg. friends, groups, etc.
 * @param query A query to execute, in Cypher.
 * @param params Parameters to pass to the query.
 * @param res Whether to immediately extract the result from the query. Useful when doing "RETURN {query}" rather than returning a variable from a previous statement.
 * @param arr Whether to return an array of results, otherwise returns the first result.
 * @returns the result of the query.
 * @example
 *	friendCount: roQuery(
 *		"friends",
 *		"RETURN SIZE((:User) -[:friends]- (:User { name: $user }))",
 *		{
 *			user: "Heliodex",
 *		},
 *		true
 *	),
 */
export async function roQuery(
	graph: keyof typeof graphs,
	query: string,
	params: { [k: string]: string | number },
	res = false,
	arr = false
) {
	// this is a stupid bug. previously just returning the result of a roQuery as "data" or whatever, then using .data, would break randomly
	const c = () =>
		"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(
			Math.random() * 52
		)
	const rand: any = Array(5).fill(0).map(c).join("")
	let result: any

	try {
		result =
			(
				await graphs[graph].roQuery(
					res ? `${query} as ${rand}` : query,
					{ params }
				)
			).data || []
		if (!arr) result = result[0]
		if (res) result = result[rand]
	} catch (e) {
		console.error(e)
		result = false
	}
	return result
}
