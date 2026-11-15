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

	// The stream is read through its reader, as the reader holds the stream's lock and is what has to cancel it
	const reader = res.body.getReader()
	const chunks: Uint8Array[] = []
	let size = 0
	for (;;) {
		const { done, value } = await reader.read()
		if (done) break
		size += value.byteLength
		if (size > limit) {
			await reader.cancel()
			throw new TooLargeError(limit)
		}
		chunks.push(value)
	}

	const out = new Uint8Array(size)
	let offset = 0
	for (const chunk of chunks) {
		out.set(chunk, offset)
		offset += chunk.byteLength
	}
	return out
}
