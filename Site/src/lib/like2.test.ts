import { describe, expect, test } from "bun:test"
import { likeFns, type Scored } from "./like2.ts"

const scored = (overrides?: Partial<Scored>): Scored => ({
	dislikeCount: 0,
	dislikes: false,
	likeCount: 0,
	likes: false,
	score: 0,
	...overrides,
})

describe("likeFns", () => {
	test("liking twice only counts once", () => {
		const t = scored()
		likeFns.like(t)
		likeFns.like(t)
		expect(t.likes).toBe(true)
		expect(t.likeCount).toBe(1)
		expect(t.score).toBe(1)
	})

	test("disliking twice only counts once", () => {
		const t = scored()
		likeFns.dislike(t)
		likeFns.dislike(t)
		expect(t.dislikes).toBe(true)
		expect(t.dislikeCount).toBe(1)
		expect(t.score).toBe(-1)
	})

	test("switching dislike to like nets +2", () => {
		const t = scored({ dislikeCount: 1, dislikes: true, score: -1 })
		likeFns.like(t)
		expect(t.dislikes).toBe(false)
		expect(t.likes).toBe(true)
		expect(t.dislikeCount).toBe(0)
		expect(t.likeCount).toBe(1)
		expect(t.score).toBe(1)
	})

	test("unlike without a like is a no-op", () => {
		const t = scored()
		likeFns.unlike(t)
		expect(t.score).toBe(0)
	})
})
