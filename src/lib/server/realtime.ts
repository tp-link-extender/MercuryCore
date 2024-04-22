import jwt from "jsonwebtoken"
const { sign } = jwt // I LOVE COMMONJS! (lies)

const secret = process.env.REALTIME_HMAC as string
export const apiKey = process.env.REALTIME_KEY as string

export function token(sub: string) {
	const exp = Date.now() / 1000 + 3600 * 12
	const realtimeToken = sign({ sub, exp }, secret)

	return {
		expiry: exp,
		realtimeToken,
		realtimeHash: Bun.hash.crc32(realtimeToken), // crc32 because it's short
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
