import { describe, expect, test } from "bun:test"
import { BufReader, SerialiseItem } from "./items"
import { DeserialiseItem, itemKinds } from "./types"

// Every kind the ledger defines must round-trip through the wire format. The hand-written DeserialiseItem switch is the part that can fall behind the generated classes, so this catches a kind it doesn't handle.
describe("item kinds", () => {
	for (const kind of itemKinds) {
		test(`${kind.name} writes its Type byte and reads back`, () => {
			const bytes = SerialiseItem(kind.sample)
			expect(bytes.buf[0]).toBe(kind.type)

			const decoded = DeserialiseItem(new BufReader(bytes))
			expect(decoded).toBeInstanceOf(kind.sample.constructor)
			expect(decoded).toStrictEqual(kind.sample)
		})
	}
})
