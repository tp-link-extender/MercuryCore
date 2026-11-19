import { describe, expect, test } from "bun:test"
import {
	escapeXml,
	fillXmlTemplate,
	substituteRobloxAssetUrls,
} from "./xmlTemplate"

describe("escapeXml", () => {
	test("escapes markup characters", () => {
		expect(escapeXml(`a&b<c>d"e'f`)).toBe("a&amp;b&lt;c&gt;d&quot;e&apos;f")
	})

	test("leaves ordinary text alone", () => {
		expect(escapeXml("Body Colors 123")).toBe("Body Colors 123")
	})
})

describe("fillXmlTemplate", () => {
	test("fills every placeholder with escaped text", () => {
		const xml = fillXmlTemplate(
			'<Item class="_CLASS"><string name="Name">_NAME</string><url>_URL</url></Item>',
			{
				CLASS: "BodyColors",
				NAME: `Tom & Jerry's "face"`,
				URL: "https://example.com/asset?id=1&size=large",
			}
		)

		expect(xml).toBe(
			'<Item class="BodyColors"><string name="Name">Tom &amp; Jerry&apos;s &quot;face&quot;</string><url>https://example.com/asset?id=1&amp;size=large</url></Item>'
		)
	})

	test("writes numbers as they are", () => {
		expect(fillXmlTemplate("<int>_N</int>", { N: 24 })).toBe(
			"<int>24</int>"
		)
		expect(fillXmlTemplate("<bool>_B</bool>", { B: false })).toBe(
			"<bool>false</bool>"
		)
	})

	test("does not rescan values", () => {
		expect(fillXmlTemplate("<a>_A</a><b>_B</b>", { A: "_B", B: "x" })).toBe(
			"<a>_B</a><b>x</b>"
		)
	})

	test("refuses placeholders with no value", () => {
		expect(() => fillXmlTemplate("<a>_A</a><b>_B</b>", { A: "x" })).toThrow(
			"_B has no value"
		)
	})

	test("refuses values with no placeholder", () => {
		expect(() => fillXmlTemplate("<a>_A</a>", { A: "x", B: "y" })).toThrow(
			"B has no placeholder"
		)
	})

	test("refuses a value used more than once", () => {
		expect(() => fillXmlTemplate("<a>_A</a><b>_A</b>", { A: "x" })).toThrow(
			"A has 2 placeholders"
		)
	})
})

describe("substituteRobloxAssetUrls", () => {
	const replacement = "mercs.dev/asset"

	test("rewrites Roblox asset URLs, keeping any scheme", () => {
		const cases: [string, string][] = [
			["http://www.roblox.com/asset?id=1", "http://mercs.dev/asset?id=1"],
			[
				"https://www.roblox.com/asset/?id=1",
				"https://mercs.dev/asset/?id=1",
			],
			["https://roblox.com/asset", "https://mercs.dev/asset"],
			["roblox.com/asset?id=1", "mercs.dev/asset?id=1"],
			["http://ROBLOX.com/asset?id=1", "http://mercs.dev/asset?id=1"],
		]

		for (const [url, expected] of cases)
			expect(substituteRobloxAssetUrls(url, replacement)).toBe(expected)
	})

	test("leaves other hostnames and paths alone", () => {
		for (const xml of [
			"http://notroblox.com/asset?id=1",
			"http://www.notroblox.com/asset?id=1",
			"http://roblox.com/assets?id=1",
			"http://roblox.com/asset-thing",
			"http://asset.roblox.com/asset?id=1",
			"http://roblox.com/game?id=1",
		])
			expect(substituteRobloxAssetUrls(xml, replacement)).toBe(xml)
	})

	test("uses the replacement literally, without $ patterns", () => {
		expect(
			substituteRobloxAssetUrls(
				"http://www.roblox.com/asset?id=1",
				"$&.$1$$"
			)
		).toBe("http://$&.$1$$?id=1")
	})

	test("rewrites bare references the way full URLs are rewritten", () => {
		const script =
			'<string name="Source">print("http://www.roblox.com/asset?id=1")</string>'
		expect(substituteRobloxAssetUrls(script, replacement)).toBe(
			'<string name="Source">print("http://mercs.dev/asset?id=1")</string>'
		)
	})
})

describe("the real XML templates", () => {
	test("fills body colours", async () => {
		const template = await Bun.file("xml/bodyColours.xml").text()
		const xml = fillXmlTemplate(template, {
			HEAD: 24,
			LEFT_ARM: 24,
			LEFT_LEG: 119,
			RIGHT_ARM: 24,
			RIGHT_LEG: 119,
			TORSO: 23,
		})

		expect(xml).toContain('<int name="HeadColor">24</int>')
		expect(xml).toContain('<int name="LeftLegColor">119</int>')
		expect(xml).not.toMatch(/_[A-Z]+/)
	})

	test("fills the graphic asset templates", async () => {
		const values = {
			ASSET_URL: "http://example.com/asset?id=123",
			CLASS: "ShirtGraphic",
			STRING_NAME: "Shirt Graphic",
		}

		const image = fillXmlTemplate(
			await Bun.file("xml/graphicAssetImage.xml").text(),
			values
		)
		expect(image).toContain('<Item class="ShirtGraphic"')
		expect(image).toContain(`<url>${values.ASSET_URL}</url>`)
		expect(image).toContain('<Content name="Texture">')
		expect(image).not.toMatch(/_[A-Z]+/)

		const other = fillXmlTemplate(
			await Bun.file("xml/graphicAssetOther.xml").text(),
			{ ...values, CONTENT_NAME: "Graphic" }
		)
		expect(other).toContain('<Item class="ShirtGraphic"')
		expect(other).toContain('<Content name="Graphic">')
		expect(other).not.toMatch(/_[A-Z]+/)
	})
})
