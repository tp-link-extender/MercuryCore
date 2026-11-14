import { describe, expect, test } from "bun:test"
import { isValidServerAddress } from "./typeTests"

describe("isValidServerAddress", () => {
	test("accepts hostnames and IP addresses", () => {
		for (const address of [
			"localhost",
			"example.com",
			"game-1.example.co.uk",
			"203.0.113.7",
			"::1",
			"2001:db8::1",
		])
			expect(isValidServerAddress(address)).toBe(true)
	})

	test("rejects anything that isn't a hostname or IP address", () => {
		for (const address of [
			"",
			"a'b",
			'a"b',
			"x');print('pwned')--",
			"a b",
			"-example.com",
			"example-.com",
			"example..com",
			".example.com",
			"http://example.com",
			"example.com:53640",
			"300.1.1.1",
			`${"a".repeat(64)}.com`,
			`${"a.".repeat(50)}com`,
		])
			expect(isValidServerAddress(address)).toBe(false)
	})
})
