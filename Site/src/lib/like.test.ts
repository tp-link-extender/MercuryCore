import { describe, expect, test } from "bun:test"
import type { SubmitFunction } from "$app/forms"
import { likeEnhance, type Scored } from "./like.ts"

const scored = (overrides?: Partial<Scored>): Scored => ({
	dislikeCount: 0,
	dislikes: false,
	likeCount: 0,
	likes: false,
	score: 0,
	...overrides,
})

// likeEnhance only reads formData.get("action"), so a minimal stub suffices
const submit = (t: Scored, action: unknown) =>
	likeEnhance(t, () => {})({
		formData: { get: () => action },
	} as unknown as Parameters<SubmitFunction>[0])

describe("likeEnhance", () => {
	test("liking twice only counts once", () => {
		const t = scored()
		submit(t, "like")
		submit(t, "like")
		expect(t.likes).toBe(true)
		expect(t.likeCount).toBe(1)
		expect(t.score).toBe(1)
	})

	test("disliking twice only counts once", () => {
		const t = scored()
		submit(t, "dislike")
		submit(t, "dislike")
		expect(t.dislikes).toBe(true)
		expect(t.dislikeCount).toBe(1)
		expect(t.score).toBe(-1)
	})

	test("switching like to dislike nets -2", () => {
		const t = scored({ likeCount: 1, likes: true, score: 1 })
		submit(t, "dislike")
		expect(t.likes).toBe(false)
		expect(t.dislikes).toBe(true)
		expect(t.likeCount).toBe(0)
		expect(t.dislikeCount).toBe(1)
		expect(t.score).toBe(-1)
	})

	test("unknown action does not throw", () => {
		const t = scored()
		expect(() => submit(t, "frobnicate")).not.toThrow()
		expect(t.score).toBe(0)
	})

	test("missing action does not throw", () => {
		const t = scored()
		expect(() => submit(t, null)).not.toThrow()
		expect(t.score).toBe(0)
	})
})
