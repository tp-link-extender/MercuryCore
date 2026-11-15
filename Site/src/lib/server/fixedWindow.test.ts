import { describe, expect, test } from "bun:test"
import { FixedWindow } from "./fixedWindow"

describe("FixedWindow", () => {
	test("allows up to max hits per window, then refuses", () => {
		const w = new FixedWindow()
		expect(w.hit("a", 5000, 3, 0)).toBe(true)
		expect(w.hit("a", 5000, 3, 1000)).toBe(true)
		expect(w.hit("a", 5000, 3, 2000)).toBe(true)
		expect(w.hit("a", 5000, 3, 3000)).toBe(false)
	})

	test("the window ends a fixed time after its first hit", () => {
		const w = new FixedWindow()
		expect(w.hit("a", 5000, 1, 0)).toBe(true)
		expect(w.hit("a", 5000, 1, 4999)).toBe(false)
		expect(w.hit("a", 5000, 1, 5000)).toBe(true)
	})

	test("refused hits don't extend the window", () => {
		const w = new FixedWindow()
		expect(w.hit("a", 5000, 1, 0)).toBe(true)
		for (let t = 1000; t < 5000; t += 1000)
			expect(w.hit("a", 5000, 1, t)).toBe(false)
		expect(w.hit("a", 5000, 1, 5000)).toBe(true)
	})

	test("keys are independent", () => {
		const w = new FixedWindow()
		expect(w.hit("a", 5000, 1, 0)).toBe(true)
		expect(w.hit("b", 5000, 1, 0)).toBe(true)
		expect(w.hit("a", 5000, 1, 1)).toBe(false)
	})

	test("expired windows are removed", () => {
		const w = new FixedWindow()
		for (let i = 0; i < 100; i++) w.hit(`k${i}`, 1000, 1, 0)
		expect(w.size).toBe(100)
		w.hit("late", 1000, 1, 120_000)
		expect(w.size).toBe(1)
	})
})
