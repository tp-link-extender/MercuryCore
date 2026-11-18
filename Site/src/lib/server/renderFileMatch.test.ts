import { describe, expect, test } from "bun:test"
import { renderFileMatcher } from "./renderFileMatch.ts"
import type { RenderType } from "./requestRender.ts"

const matches = (
	renderType: RenderType,
	relativeId: string | number,
	filename: string | null
) => renderFileMatcher(renderType, relativeId)(filename)

describe("renderFileMatcher", () => {
	test("matches only the bare id file for clothing", () => {
		expect(matches("Clothing", 123, "123")).toBe(true)
		expect(matches("Clothing", 123, "123.png")).toBe(false)
		expect(matches("Clothing", 123, "1234")).toBe(false)
	})

	test("matches only the bare id file for models", () => {
		expect(matches("Model", "123", "123")).toBe(true)
		expect(matches("Model", "123", "12")).toBe(false)
	})

	test("doesn't match an id that is a prefix of another id", () => {
		expect(matches("Clothing", 12, "123")).toBe(false)
		expect(matches("Avatar", 12, "123-head.png")).toBe(false)
		expect(matches("Avatar", 12, "123-body.png")).toBe(false)
	})

	test("matches the head and body files for avatars", () => {
		expect(matches("Avatar", 123, "123-head.png")).toBe(true)
		expect(matches("Avatar", 123, "123-body.png")).toBe(true)
		expect(matches("Avatar", 123, "123")).toBe(false)
		expect(matches("Avatar", 123, "123-head")).toBe(false)
	})

	test("doesn't match a missing filename", () => {
		expect(matches("Clothing", 123, null)).toBe(false)
		expect(matches("Avatar", 123, null)).toBe(false)
	})
})
