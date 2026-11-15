import { describe, expect, test } from "bun:test"
import { readLimited, TooLargeError } from "./readLimited"

const streamed = (chunks: number[]): Response =>
	new Response(
		new ReadableStream({
			start(controller) {
				for (const size of chunks)
					controller.enqueue(new Uint8Array(size))
				controller.close()
			},
		})
	)

describe("readLimited", () => {
	test("reads a body within the limit", async () => {
		const body = await readLimited(new Response("hello"), 5)

		expect(new TextDecoder().decode(body)).toBe("hello")
	})

	test("joins a streamed body", async () => {
		expect(await readLimited(streamed([3, 4, 5]), 12)).toHaveLength(12)
	})

	test("refuses a body over the limit while streaming", async () => {
		const result = await readLimited(streamed([3, 4, 5]), 11).catch(
			(e: unknown) => e
		)

		expect(result).toBeInstanceOf(TooLargeError)
	})

	test("refuses a Content-Length over the limit without reading", async () => {
		const res = new Response("small", {
			headers: { "Content-Length": "1000" },
		})
		const result = await readLimited(res, 100).catch((e: unknown) => e)

		expect(result).toBeInstanceOf(TooLargeError)
	})
})
