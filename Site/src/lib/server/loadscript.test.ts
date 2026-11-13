import { describe, expect, test } from "bun:test"
import { isValidMapName } from "../mapName"
import {
	buildLoadscript,
	luaRaw,
	luaString,
	parseMapLocation,
} from "./loadscript"

const encode = (value: string): string => Buffer.from(value).toString("base64")

// data/ is gitignored, so the real host template is absent from a clean checkout such as CI. That test only runs where the template exists.
const hostTemplatePath = "../data/server/loadscripts/host.lua"
const hostTemplateExists = await Bun.file(hostTemplatePath).exists()

describe("parseMapLocation", () => {
	test("treats a missing or empty map as no map", () => {
		expect(parseMapLocation(null)).toBe("")
		expect(parseMapLocation("")).toBe("")
		expect(parseMapLocation(encode(""))).toBe("")
	})

	test("accepts safe map names", () => {
		for (const name of ["CoolMap.rbxl", "my map.rbxl", "foo.bar.rbxl"])
			expect(parseMapLocation(encode(name))).toBe(
				`rbxasset://maps/${name}`
			)
	})

	test("rejects injection and traversal payloads", () => {
		const payloads = [
			'x"\nprint("pwned")\n--.rbxl',
			"../evil.rbxl",
			"foo/bar.rbxl",
			String.raw`foo\bar.rbxl`,
			'x"y.rbxl',
			"a\nb.rbxl",
			"..rbxl",
			".hidden.rbxl",
			"map.lua",
			`${"a".repeat(65)}.rbxl`,
		]

		for (const payload of payloads)
			expect(parseMapLocation(encode(payload))).toBeNull()
	})
})

describe("isValidMapName", () => {
	test("allows plain map names", () => {
		expect(isValidMapName("CoolMap.rbxl")).toBe(true)
		expect(isValidMapName("my map.rbxl")).toBe(true)
	})

	test("rejects path traversal and script-like names", () => {
		expect(isValidMapName("..rbxl")).toBe(false)
		expect(isValidMapName("a..rbxl")).toBe(false)
		expect(isValidMapName("../../map.rbxl")).toBe(false)
		expect(isValidMapName("map.lua")).toBe(false)
	})
})

describe("luaString", () => {
	test("escapes quotes, backslashes and control characters", () => {
		const escaped = luaString('x"\\\n\u0001')

		expect(escaped.startsWith('"')).toBe(true)
		expect(escaped.endsWith('"')).toBe(true)
		expect(escaped).not.toContain("\n")
		expect(escaped).toContain(String.raw`\"`)
		expect(escaped).toContain(String.raw`\\`)
		expect(escaped).toContain(String.raw`\010`)
		expect(escaped).toContain(String.raw`\001`)
	})
})

describe("buildLoadscript", () => {
	test("quotes strings and leaves numbers raw", () => {
		const script = buildLoadscript(
			"local url = _BASE_URL local port = _SERVER_PORT",
			{ BASE_URL: "example.com", SERVER_PORT: 53640 }
		)

		expect(script).toBe('local url = "example.com" local port = 53640')
	})

	test("does not rescan substituted values", () => {
		const script = buildLoadscript("local a,b=_BASE_URL,_MAP_LOCATION", {
			BASE_URL: "_MAP_LOCATION",
			MAP_LOCATION: "safe.rbxl",
		})

		expect(script).toBe('local a,b="_MAP_LOCATION","safe.rbxl"')
	})

	test("keeps an injection payload inside a string", () => {
		const script = buildLoadscript("local k,l=_BASE_URL,_MAP_LOCATION", {
			BASE_URL: "example.com",
			MAP_LOCATION: 'x"\nprint("pwned")\n--.rbxl',
		})

		expect(script.split("\n")).toHaveLength(1)
		expect(script).not.toContain('\nprint("pwned")')
		expect(script).toContain(String.raw`\"`)
	})

	test("leaves trusted raw values as source", () => {
		const script = buildLoadscript("local m=_MEMBERSHIP_TYPE", {
			MEMBERSHIP_TYPE: luaRaw("Enum.MembershipType.None"),
		})

		expect(script).toBe("local m=Enum.MembershipType.None")
	})

	test.skipIf(!hostTemplateExists)(
		"fills the real host loadscript safely",
		async () => {
			const template = await Bun.file(hostTemplatePath).text()
			const script = buildLoadscript(template, {
				BASE_URL: "www.example.com",
				MAP_LOCATION: "rbxasset://maps/CoolMap.rbxl",
				SERVER_PORT: 53640,
				SERVER_PRESENCE_URL:
					"http://www.example.com/game/serverpresence",
			})

			expect(script).not.toContain("_MAP_LOCATION")
			expect(script).toContain(
				'local k,l="www.example.com","rbxasset://maps/CoolMap.rbxl"'
			)
		}
	)

	test("leaves unknown placeholders alone", () => {
		expect(buildLoadscript("_UNKNOWN _G", {})).toBe("_UNKNOWN _G")
	})
})
