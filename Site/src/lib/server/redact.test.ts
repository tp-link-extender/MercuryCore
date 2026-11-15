import { describe, expect, test } from "bun:test"
import { redactSearch } from "./redact"

describe("redactSearch", () => {
	test("redacts each credential parameter", () => {
		for (const name of [
			"ticket",
			"serverTicket",
			"privateTicket",
			"privateServer",
		])
			expect(redactSearch(`?${name}=abc123`)).toBe(`?${name}=[redacted]`)
	})

	test("keeps other parameters and their order", () => {
		expect(
			redactSearch(
				"?autopilot=Baseplate&ticket=abc&privateServer=xyz&a=1"
			)
		).toBe(
			"?autopilot=Baseplate&ticket=[redacted]&privateServer=[redacted]&a=1"
		)
	})

	test("is not fooled by case or by parameters that merely end in the same name", () => {
		expect(redactSearch("?TICKET=abc")).toBe("?TICKET=[redacted]")
		expect(redactSearch("?myticket=abc")).toBe("?myticket=abc")
	})

	test("leaves searches without credentials alone", () => {
		expect(redactSearch("")).toBe("")
		expect(redactSearch("?q=ticket")).toBe("?q=ticket")
	})
})
