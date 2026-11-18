import { describe, expect, test } from "bun:test"
import commentType from "./commentType.ts"

describe("commentType", () => {
	test("appends reply id to top-level types", () => {
		expect(commentType(["status"], "r1")).toEqual(["status", "r1"])
		expect(commentType(["forum", "c1"], "r1")).toEqual([
			"forum",
			"c1",
			"r1",
		])
		expect(commentType(["asset", "7"], "r1")).toEqual(["asset", "7", "r1"])
	})

	test("nested replies keep the root type", () => {
		expect(commentType(["forum", "c1", "p1"], "r2")).toEqual([
			"forum",
			"c1",
			"p1",
		])
		expect(commentType(["status", "s1"], "r2")).toEqual(["status", "s1"])
		expect(commentType(["asset", "7", "c9"], "r2")).toEqual([
			"asset",
			"7",
			"c9",
		])
	})
})
