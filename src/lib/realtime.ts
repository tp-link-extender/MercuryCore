import { Centrifuge } from "centrifuge"
import { browser } from "$app/environment"

export type ForumResponse = {
	id: string
	score: number
	action: "like" | "dislike" | "unlike" | "undislike"
	type: "Post" | "Reply"
	hash: number
}

export default (token: string) => {
	if (!browser) return

	const client = new Centrifuge("ws://localhost:7999/connection/websocket", {
		token,
	})

	client
		.on("connecting", c => {
			console.log(`connecting: ${c.code}, ${c.reason}`)
		})
		.on("connected", c => {
			console.log(`connected over ${c.transport}`)
		})
		.on("disconnected", c => {
			console.log(`disconnected: ${c.code}, ${c.reason}`)
		})
		.connect()

	return client
}
