import { describe, expect, test } from "bun:test"
import { bearerMatches, isUsableKey } from "./bearer"

const key = "0123456789abcdef0123456789abcdef"
const request = (auth?: string): Request =>
	new Request("http://localhost/", {
		headers: auth ? { Authorization: auth } : {},
	})

describe("bearerMatches", () => {
	test("accepts the right key", () => {
		expect(bearerMatches(request(`Bearer ${key}`), key, "TEST_KEY")).toBe(
			true
		)
	})

	test("refuses a wrong, missing or malformed header", () => {
		for (const auth of [
			undefined,
			"",
			key,
			`Basic ${key}`,
			`Bearer ${key}x`,
			`Bearer ${key.slice(1)}`,
			"Bearer ",
		])
			expect(bearerMatches(request(auth), key, "TEST_KEY")).toBe(false)
	})

	test("refuses everything when the key isn't usable", () => {
		for (const bad of [undefined, "", "short", "password", "change-me"])
			expect(
				bearerMatches(request(`Bearer ${bad}`), bad, "TEST_KEY")
			).toBe(false)
	})
})

describe("isUsableKey", () => {
	test("needs a long key that isn't an example value", () => {
		expect(isUsableKey(key)).toBe(true)
		expect(isUsableKey("a".repeat(15))).toBe(false)
		expect(isUsableKey("a".repeat(16))).toBe(true)
		expect(isUsableKey(undefined)).toBe(false)
	})
})
