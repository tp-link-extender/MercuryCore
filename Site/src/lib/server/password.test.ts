import { describe, expect, test } from "bun:test"
import { hashPassword, verifyPassword } from "./password"

describe("verifyPassword", () => {
	test("accepts the right password and refuses a wrong one", async () => {
		const hash = await hashPassword("correct horse battery staple")

		expect(await verifyPassword("correct horse battery staple", hash)).toBe(
			true
		)
		expect(await verifyPassword("wrong", hash)).toBe(false)
	})

	test("refuses every password when there's no hash", async () => {
		expect(await verifyPassword("", undefined)).toBe(false)
		expect(await verifyPassword("anything", undefined)).toBe(false)
	})

	test("still does the work of a real check when there's no hash", async () => {
		const hash = await hashPassword("x")
		await verifyPassword("warm up", undefined)

		const start = performance.now()
		await verifyPassword("y", hash)
		const real = performance.now() - start

		const dummyStart = performance.now()
		await verifyPassword("y", undefined)
		const dummy = performance.now() - dummyStart

		expect(dummy).toBeGreaterThan(real / 4)
	})
})
