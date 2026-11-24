import { describe, expect, test } from "bun:test"
import { generate, manifestPath, outputPath, parseManifest } from "./loadscripts.ts"

// The committed types have to match the committed manifest, so a change to the manifest can't go ungenerated.
describe("loadscripts", () => {
	test("the generated types are current", async () => {
		const manifest = parseManifest(await Bun.file(manifestPath).text())
		expect(await Bun.file(outputPath).text()).toBe(generate(manifest))
	})

	test("placeholders are sorted and each name becomes a required value", () => {
		const out = generate({ join: ["USERNAME", "PLACE_ID"] })
		expect(out).toContain("export type JoinValues = {\n\tPLACE_ID: LoadscriptValue\n\tUSERNAME: LoadscriptValue\n}")
	})

	test("a loadscript with no placeholders takes no values", () => {
		expect(generate({ studio: [] })).toContain("export type StudioValues = { [_: string]: never }")
	})

	test("the output doesn't depend on the order of the manifest", () => {
		expect(generate({ a: ["X", "Y"], b: [] })).toBe(generate({ b: [], a: ["Y", "X"] }))
	})

	test("names that aren't plain identifiers are refused", () => {
		expect(() => generate({ "my-script": [] })).toThrow("isn't a plain identifier")
	})

	test("a manifest that isn't a map of name to placeholder names is refused", () => {
		expect(() => parseManifest("[]")).toThrow("must be an object")
		expect(() => parseManifest('{"join": "USERNAME"}')).toThrow("must be a list")
		expect(() => parseManifest('{"join": [1]}')).toThrow("must be a list")
	})
})
