/** Thrown when a response body is larger than allowed. */
export class TooLargeError extends Error {
	override name = "TooLargeError"

	constructor(readonly limit: number) {
		super(`Response body is larger than ${limit} bytes`)
	}
}

/**
 * Reads a response body, stopping as soon as it passes `limit` bytes instead of buffering all of it.
 * @throws TooLargeError if the body (or its Content-Length) is over the limit.
 */
export async function readLimited(
	res: Response,
	limit: number
): Promise<Uint8Array<ArrayBuffer>> {
	const length = Number(res.headers.get("Content-Length"))
	if (length > limit) {
		await res.body?.cancel()
		throw new TooLargeError(limit)
	}
	if (!res.body) return new Uint8Array()

	const chunks: Uint8Array[] = []
	let size = 0
	for await (const chunk of res.body) {
		size += chunk.byteLength
		if (size > limit) {
			await res.body.cancel()
			throw new TooLargeError(limit)
		}
		chunks.push(chunk)
	}

	const out = new Uint8Array(size)
	let offset = 0
	for (const chunk of chunks) {
		out.set(chunk, offset)
		offset += chunk.byteLength
	}
	return out
}
