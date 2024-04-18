import { sign } from "jsonwebtoken"

const config = await Bun.file("./centrifugo.yml").text()

// average yaml parser
const getLine = (key: string) =>
	config
		.split("\n")
		.filter(l => l.startsWith(key))[0]
		.split(" ")
		.pop() || ""

export const apiKey = getLine("api_key")
const secret = getLine("token_hmac_secret_key")

export function token(sub: string) {
	const exp = Date.now() / 1000 + 3600
	const realtimeToken = sign({ sub, exp }, secret)

	return {
		expiry: exp,
		realtimeToken,
		realtimeHash: Bun.hash.crc32(realtimeToken),
	}
}

export const publish = (channel: string, data: unknown) =>
	fetch("http://localhost:7999/api/publish", {
		method: "POST",
		body: JSON.stringify({ channel, data }),
		headers: {
			"content-type": "application/json",
			"x-api-key": apiKey,
		},
	})
