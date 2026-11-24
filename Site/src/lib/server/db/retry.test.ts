import { describe, expect, test } from "bun:test"
import { retryOnConflict } from "./retry"

const retriable = () =>
	new Error("Transaction failed: This transaction can be retried")

// Resolves with the value a promise rejects with, and fails the test if it resolves
const rejection = async (p: PromiseLike<unknown>): Promise<unknown> => {
	try {
		await p
	} catch (err) {
		return err
	}
	throw new Error("expected a rejection")
}

describe("retryOnConflict", () => {
	test("returns the result without retrying when nothing fails", async () => {
		let calls = 0
		const result = await retryOnConflict(() => {
			calls++
			return Promise.resolve("ok")
		})
		expect(result).toBe("ok")
		expect(calls).toBe(1)
	})

	test("runs again once after a retriable error and returns that result", async () => {
		let calls = 0
		const result = await retryOnConflict(() => {
			calls++
			return calls === 1
				? Promise.reject(retriable())
				: Promise.resolve("second")
		})
		expect(result).toBe("second")
		expect(calls).toBe(2)
	})

	test("rethrows other errors without retrying", async () => {
		let calls = 0
		const err = await rejection(
			retryOnConflict(() => {
				calls++
				return Promise.reject(new Error("Connection refused"))
			})
		)
		expect(err).toEqual(new Error("Connection refused"))
		expect(calls).toBe(1)
	})

	test("rethrows a non-Error without retrying", async () => {
		let calls = 0
		const thrown: unknown = "not an error"
		const err = await rejection(
			retryOnConflict(() => {
				calls++
				// oxlint-disable-next-line typescript/prefer-promise-reject-errors
				return Promise.reject(thrown)
			})
		)
		expect(err).toBe("not an error")
		expect(calls).toBe(1)
	})

	test("gives up after the second attempt also fails", async () => {
		let calls = 0
		const err = await rejection(
			retryOnConflict(() => {
				calls++
				return Promise.reject(retriable())
			})
		)
		expect(err).toEqual(retriable())
		expect(calls).toBe(2)
	})
})
