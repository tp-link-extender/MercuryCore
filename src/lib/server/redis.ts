import { error } from "@sveltejs/kit"
import { createClient, Graph } from "redis"

const client = createClient({ url: "redis://localhost:6479" })

console.log("loaded redis")
client.on("error", e => {
	console.error("Redis error", e)
	throw error(500, "Redis error")
})
await client.connect()

export const graph = new Graph(client, "friends")

export async function Query(str: any, query: any) {
	await graph.query(str, query)
}

export async function roQuery(str: string, query: any, res = false) {
	// this is a stupid bug. previously just returning the result of a roQuery as "data" or whatever, then using .data, would break randomly
	const c = () => "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(Math.random() * 52)
	const rand: any = Array(5).fill(0).map(c).join("")
	let result: any

	try {
		result = ((await graph.roQuery(res ? `${str} as ${rand}` : str, query)).data || [])[0]
		if (res) result = result[rand]
	} catch (e) {
		console.error(e)
		result = false
	}
	return result
}
