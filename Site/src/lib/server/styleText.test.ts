import { describe, expect, test } from "bun:test"
import { styleText } from "./styleText"

describe("styleText", () => {
	test("leaves CSS without < unchanged", () => {
		const css = "body > div { color: red; content: '$&'; }"

		expect(styleText(css)).toBe(css)
	})

	test("can't close the style element", () => {
		const out = styleText("a{}</style><script>alert(1)</script>")

		expect(out).not.toContain("<")
		expect(out).toBe(
			String.raw`a{}\3c /style>\3c script>alert(1)\3c /script>`
		)
	})

	test("catches any case of the closing tag", () => {
		expect(styleText("</STYLE >")).not.toContain("<")
	})
})
