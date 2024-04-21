import { Centrifuge, type PublicationContext } from "centrifuge"
import { browser, dev } from "$app/environment"

export type ForumResponse = {
	id: string
	score: number
	action: "like" | "dislike" | "unlike" | "undislike"
	type: "Post" | "Reply"
	hash: number
}

export type AssetResponse = {
	id: string
	score: number
	action: "like" | "dislike" | "unlike" | "undislike"
	hash: number
}

// Centrifugo supports many other transports:
// - SockJS is being deprecated and is only useful in legacy scenarios
// - SSE is nice with HTTP 2 and 3, but we can't guarantee that and its limit of 6 connections per browser/server on HTTP 1 causes it to get swamped
// - HTTP streaming/long polling might be okay but it's not as efficient
// - WebRTC isn't supported and wouldn't be used for this kind of thing anyway
// - WebTransport I LOVE and using it with Centrifugo is a joy, but concerns with TLS between Caddy reverse proxy and Centrifugo server (plus it isn't supported in Safari... STILL)
// WebSockets are fine for now. Might even mean we don't need to use the Centrifuge client library (~50kb iirc), but it has some nice features for reconnection and such

const url = `ws${
	dev ? "://localhost:7999" : `s://realtime.${process.env.DOMAIN}`
}/connection/websocket` // only i would write template literals like this

export default (
	token: string,
	channel: string,
	onPub: (c: PublicationContext) => void
) => {
	if (!browser) return

	const client = new Centrifuge(url, { token })
	client.connect()
	client.newSubscription(channel).on("publication", onPub).subscribe()
	return client
}
