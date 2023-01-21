import { error } from "@sveltejs/kit"
import { createClient, Graph } from "redis"

const client = createClient({ url: "redis://localhost:6479" })

console.log("yo")
client.on("error", e => {
	console.log("Redis error", e)
	throw error(500, "Redis error")
})
await client.connect()

export default new Graph(client, "friends")
