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

const graphs: any = {
	friends: new Graph(client, "friends"), // Stores follows, friends, requests, etc
	groups: new Graph(client, "groups"), // Stores groups, members, etc
	places: new Graph(client, "places"), // Stores likes and dislikes on places
	items: new Graph(client, "items"), // Stores likes and dislikes on avatar shop items
	forum: new Graph(client, "forum"), // Stores forum post and reply likes and dislikes
}

export async function Query(graph: string, query: any, params: any) {
	await graphs[graph].query(query, { params })
}

// Read-only query, cannot modify the graph
export async function roQuery(
	graph: string,
	query: string,
	params: any,
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
