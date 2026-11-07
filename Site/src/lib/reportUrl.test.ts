// oxlint-disable eslint/no-script-url -- these are intentional test cases
import { describe, expect, test } from "bun:test"
import { reportPath } from "./reportUrl"

describe("reportPath", () => {
	test("accepts same-site paths", () => {
		for (const path of [
			"/",
			"/comment/abc",
			"/user/name",
			"/place/123/slug",
			"/report?x=1",
			"/path#frag",
		])
			expect(reportPath(path)).toBe(path)
	})

	test("normalises spaces and dot segments", () => {
		expect(reportPath("/comment/a b")).toBe("/comment/a%20b")
		expect(reportPath("/a/../b")).toBe("/b")
	})

	test("rejects external and dangerous URLs", () => {
		for (const value of [
			"javascript:alert(1)",
			"JaVaScRiPt:alert(1)",
			"data:text/html,<script>alert(1)</script>",
			"//evil.com",
			"https://evil.com",
			"http://evil.com",
			String.raw`\\evil.com`,
			String.raw`/\evil.com`,
			"///evil.com",
			"/..//evil.com",
			"/%2e%2e//evil.com",
			"comment/123",
			"",
			" /comment/1",
		])
			expect(reportPath(value)).toBeNull()
	})

	test("rejects control characters and oversized values", () => {
		expect(reportPath("/comment/\n1")).toBeNull()
		expect(reportPath(`/${"a".repeat(2048)}`)).toBeNull()
	})
})
