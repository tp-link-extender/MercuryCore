import { isValidMapName } from "../mapName"

const escapeCharacter = (char: string): string => {
	const code = char.charCodeAt(0)
	if (code < 0x20 || code === 0x7f)
		return `\\${code.toString().padStart(3, "0")}`
	if (char === "\\") return "\\\\"
	if (char === '"') return '\\"'
	return char
}

/** Escapes a value as a quoted Lua string literal. */
export const luaString = (value: string): string =>
	`"${Array.from(value, escapeCharacter).join("")}"`

/**
 * Decodes the autopilot map parameter and returns a safe rbxasset URL.
 * An absent or empty value means no map, while null means the value was rejected.
 */
export const parseMapLocation = (encoded: string | null): string | null => {
	if (!encoded) return ""

	const name = Buffer.from(encoded, "base64").toString()
	if (!name) return ""
	if (!isValidMapName(name)) return null

	return `rbxasset://maps/${name}`
}

export type RawLua = { raw: string }
export type LoadscriptValue = string | number | RawLua
export type LoadscriptValues = { [_: string]: LoadscriptValue }

/** Marks a value as trusted Lua source rather than a string literal. */
export const luaRaw = (value: string): RawLua => ({ raw: value })

const token = /_([A-Z][A-Z0-9_]*)/g

/**
 * Replaces loadscript placeholders in one pass.
 * Strings become quoted Lua literals, raw values stay as source, and numbers stay raw, so substituted strings can never introduce new Lua code.
 */
export const buildLoadscript = (
	template: string,
	values: LoadscriptValues
): string =>
	template.replace(token, (match: string, name: string) => {
		const value = values[name]
		if (value === undefined) return match
		if (typeof value === "object") return value.raw
		return typeof value === "number" ? value.toString() : luaString(value)
	})
