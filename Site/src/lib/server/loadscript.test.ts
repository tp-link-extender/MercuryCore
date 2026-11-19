import { describe, expect, test } from "bun:test"
import { isValidMapName } from "../mapName"
import {
	buildLoadscript,
	luaId,
	luaName,
	luaString,
	parseMapLocation,
} from "./loadscript"

const encode = (value: string): string => Buffer.from(value).toString("base64")

// data/ is gitignored, so the real host template is absent from a clean checkout such as CI. That test only runs where the template exists; the committed fixture below covers every context everywhere.
const hostTemplatePath = "../data/server/loadscripts/host.lua"
const hostTemplateExists = await Bun.file(hostTemplatePath).exists()
const fixturePath = "src/lib/server/loadscript.fixture.lua"
const fixture = await Bun.file(fixturePath).text()

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

// Runs Lua source with luau when it's installed, to check that escaped values parse and come out unchanged. CI installs luau, so these checks run there too; without it they're skipped.
const luau = Bun.which("luau")

async function runLua(source: string): Promise<string> {
	if (!luau) throw new Error("luau is not installed")
	const path = `/tmp/loadscript-test-${crypto.randomUUID()}.luau`
	await Bun.write(path, source)
	try {
		const proc = Bun.spawn([luau, path], { stderr: "pipe", stdout: "pipe" })
		const [out, err] = await Promise.all([
			new Response(proc.stdout).text(),
			new Response(proc.stderr).text(),
		])
		if ((await proc.exited) !== 0) throw new Error(err || out)
		return out
	} finally {
		await Bun.file(path).delete()
	}
}

// Prints each value as hex, so the comparison doesn't depend on how luau prints control characters
const hexPrint = (expr: string): string =>
	`print((string.gsub(${expr}, ".", function(c) return string.format("%02x", string.byte(c)) end)))`
const hex = (value: string): string => `${Buffer.from(value).toString("hex")}\n`

const payloads = Object.freeze([
	"",
	"plain value 123",
	"a'b",
	'a"b',
	"x');print('pwned')--",
	'x");print("pwned")--',
	"back\\slash\\",
	String.raw`\'`,
	"]]print('pwned')--[[",
	"]==]",
	"line\nbreak\r\u0000\u0001\u007F",
	"--comment",
	"emoji 🙂 and é",
	"_SERVER_ADDRESS",
])

describe("luaString", () => {
	test("only leaves safe characters unescaped", () => {
		const escaped = luaString("a'\"\\\n]-[=b")

		expect(escaped).toBe(String.raw`"a\039\034\092\010\093-\091=b"`)
	})

	test("escapes multi-byte characters byte by byte", () => {
		expect(luaString("é")).toBe(String.raw`"\195\169"`)
	})

	test.skipIf(!luau).each(payloads)(
		"round-trips %j through Lua",
		async value => {
			expect(await runLua(hexPrint(luaString(value)))).toBe(hex(value))
		}
	)
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
		expect(script).not.toContain('"pwned"')
	})

	test("refuses a value with no placeholder", () => {
		expect(() =>
			buildLoadscript("print(_NAME)", { NAME: "x", OTHER: "y" })
		).toThrow("Loadscript value _OTHER has no placeholder")
	})

	test("refuses a value whose placeholder is only in a comment", () => {
		expect(() =>
			buildLoadscript("-- _NAME\nprint(1)", { NAME: "x" })
		).toThrow("Loadscript value _NAME has no placeholder")
	})

	test("escapes values inside single- and double-quoted strings", () => {
		const template = "j.Name='_USER_NAME' print \"at _SERVER_ADDRESS\""
		const script = buildLoadscript(template, {
			SERVER_ADDRESS: 'a"b',
			USER_NAME: "x');print('pwned')--",
		})

		expect(script).toBe(
			String.raw`j.Name='x\039\041\059print\040\039pwned\039\041--' print "at a\034b"`
		)
	})

	test("writes ids and numbers as content inside strings", () => {
		const script = buildLoadscript("print'place _PLACE_ID port _PORT'", {
			PLACE_ID: luaId(123),
			PORT: 53640,
		})

		expect(script).toBe("print'place 123 port 53640'")
	})

	test("only replaces whole identifiers", () => {
		const script = buildLoadscript("local FOO_BAR,_BAR=1,_BAR", {
			BAR: 2,
		})

		expect(script).toBe("local FOO_BAR,2=1,2")
	})

	test("keeps escapes in the template's strings intact", () => {
		const script = buildLoadscript(String.raw`print('it\'s _NAME')`, {
			NAME: "x",
		})

		expect(script).toBe(String.raw`print('it\'s x')`)
	})

	test("leaves comments and Lua globals alone", () => {
		const template =
			"-- uses _NOT_SET\nprint(_G, _VERSION) --[[ _ALSO_NOT_SET ]]"

		expect(buildLoadscript(template, {})).toBe(template)
	})

	test("refuses a placeholder inside a long string", () => {
		expect(() => buildLoadscript("print[[_NAME]]", { NAME: "x" })).toThrow(
			"long string"
		)
		expect(
			buildLoadscript("print[==[_OTHER]==] print(_NAME)", { NAME: "x" })
		).toBe('print[==[_OTHER]==] print("x")')
	})

	test("refuses placeholders with no value", () => {
		expect(() => buildLoadscript("print(_UNKNOWN)", {})).toThrow(
			"_UNKNOWN has no value"
		)
		expect(() => buildLoadscript("print'_UNKNOWN'", {})).toThrow(
			"_UNKNOWN has no value"
		)
	})

	test("refuses non-finite numbers and wraps negative ones", () => {
		expect(() => buildLoadscript("x=_N", { N: Number.NaN })).toThrow(
			"finite"
		)
		expect(buildLoadscript("x=-_N", { N: -1 })).toBe("x=-(-1)")
	})

	test("refuses unterminated strings", () => {
		expect(() => buildLoadscript("print('_NAME", { NAME: "x" })).toThrow(
			"Unterminated"
		)
	})

	test("leaves trusted names as source", () => {
		const script = buildLoadscript("local m=_MEMBERSHIP_TYPE", {
			MEMBERSHIP_TYPE: luaName("Enum.MembershipType.None"),
		})

		expect(script).toBe("local m=Enum.MembershipType.None")
	})

	test("refuses names and ids that could be source", () => {
		for (const name of [
			"",
			"Enum. MembershipType.None",
			"Enum.MembershipType.None; print(1)",
			'Enum.MembershipType["None"]',
			"1Name",
			"a.b-c",
		])
			expect(() => luaName(name)).toThrow("not a Lua identifier")

		for (const id of [-1, 1.5, Number.NaN, Number.POSITIVE_INFINITY])
			expect(() => luaId(id)).toThrow("non-negative safe integer")

		expect(luaId(0)).toEqual({ raw: "0" })
		expect(luaId(987654321)).toEqual({ raw: "987654321" })
	})

	test("fills the fixture template in every context", () => {
		for (const payload of payloads) {
			const script = buildLoadscript(fixture, { NAME: payload })
			const content = luaString(payload).slice(1, -1)

			// Code, single quotes and double quotes each get an escaped copy
			expect(script).toContain(
				`{${luaString(payload)}, '${content}', "${content}"}`
			)
			// Comments and long strings are left alone
			expect(script).toContain("-- _NAME stays as written in a comment.")
			expect(script).toContain("[==[_NOT_A_VALUE]==]")
		}
	})

	test.skipIf(!luau).each(payloads)(
		"runs the fixture with %j as data",
		async value => {
			const script = buildLoadscript(fixture, { NAME: value })

			expect(await runLua(script)).toBe(
				`${hex(value).repeat(3)}done true\n`
			)
		}
	)

	test.skipIf(!luau).each(payloads)(
		"keeps %j as data in every quoting style",
		async value => {
			const script = buildLoadscript(
				"local a,b,c=_V,'_V',\"_V\" -- _V\nlocal d=[==[x]==]",
				{ V: value }
			)
			const out = await runLua(
				`${script}\n${hexPrint("a")}\n${hexPrint("b")}\n${hexPrint("c")}`
			)
			expect(out).toBe(hex(value).repeat(3))
		}
	)

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
})
