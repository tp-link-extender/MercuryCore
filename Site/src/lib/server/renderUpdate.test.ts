import { describe, expect, test } from "bun:test"
import { parseRenderUpdate } from "./renderUpdate"

const bytes = (value: string) => new TextEncoder().encode(value)

const renderUpdate = (status: string, body: Uint8Array, head?: Uint8Array) => {
	const lengths = new Uint8Array(8)
	const view = new DataView(lengths.buffer)
	view.setUint32(0, body.byteLength)
	view.setUint32(4, head?.byteLength ?? 0)

	return Uint8Array.from([
		...bytes(`${status}\n`),
		...lengths,
		...body,
		...(head ?? []),
	])
}

const text = (value: Uint8Array | undefined) =>
	value === undefined ? undefined : new TextDecoder().decode(value)

describe("parseRenderUpdate", () => {
	test("reads a status with no images", () => {
		const update = parseRenderUpdate(bytes("Rendering\n"))

		expect(update.status).toBe("Rendering")
		expect(update.body).toBeUndefined()
		expect(update.head).toBeUndefined()
	})

	test("keeps every byte of the body", () => {
		const body = bytes("0123456789")
		const update = parseRenderUpdate(renderUpdate("Completed", body))

		expect(text(update.body)).toBe("0123456789")
	})

	test("splits a body and head at their real lengths", () => {
		const body = bytes("b".repeat(420))
		const head = bytes("h".repeat(150))
		const update = parseRenderUpdate(renderUpdate("Completed", body, head))

		expect(update.status).toBe("Completed")
		expect(update.body).toHaveLength(420)
		expect(update.head).toHaveLength(150)
		expect(update.body).toEqual(body)
		expect(update.head).toEqual(head)
	})

	test("reads a head when there is no body", () => {
		const head = bytes("head")
		const update = parseRenderUpdate(
			renderUpdate("Completed", new Uint8Array(), head)
		)

		expect(update.body).toBeUndefined()
		expect(text(update.head)).toBe("head")
	})

	test("reads a status without a newline as the whole content", () => {
		const update = parseRenderUpdate(bytes("Completed"))

		expect(update.status).toBe("Completed")
		expect(update.body).toBeUndefined()
		expect(update.head).toBeUndefined()
	})
})
