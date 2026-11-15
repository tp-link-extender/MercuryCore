import { isValidMapName } from "../mapName"

// Characters that can't end a string, comment or long bracket in any quoting style. Everything else is written as a \ddd byte escape.
const safeCharacter = /^[A-Za-z0-9 _./:?=&,-]$/
const encoder = new TextEncoder()

const escapeCharacter = (char: string): string =>
	safeCharacter.test(char)
		? char
		: Array.from(
				encoder.encode(char),
				byte => `\\${byte.toString().padStart(3, "0")}`
			).join("")

/** Escapes a value for use inside a Lua short string, quoted with either ' or ". */
const escapeContent = (value: string): string =>
	Array.from(value, escapeCharacter).join("")

/** Escapes a value as a quoted Lua string literal. */
export const luaString = (value: string): string => `"${escapeContent(value)}"`

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

export interface RawLua {
	raw: string
}
export type LoadscriptValue = string | number | RawLua
export interface LoadscriptValues {
	[_: string]: LoadscriptValue
}

/** Lua identifiers, optionally dotted, such as `Enum.MembershipType.None`. */
const luaNamePattern = /^[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*$/

/**
 * Marks a value as trusted Lua source rather than a string literal.
 * Only for names this codebase writes itself, never for anything a user can influence: the value is written as-is.
 */
export const luaName = (value: string): RawLua => {
	if (!luaNamePattern.test(value))
		throw new TypeError("Loadscript name is not a Lua identifier")
	return { raw: value }
}

/** Marks a numeric id as trusted Lua source rather than a string literal. */
export const luaId = (id: number): RawLua => {
	if (!Number.isSafeInteger(id) || id < 0)
		throw new TypeError("Loadscript id must be a non-negative safe integer")
	return { raw: id.toString() }
}

const placeholder = /^_([A-Z][A-Z0-9_]*)$/
const word = /[A-Za-z0-9_]+/y
const longBracket = /\[(=*)\[/y
// Lua's own globals that look like placeholders
const luaGlobals = Object.freeze(new Set(["G", "VERSION"]))

function numberSource(name: string, value: number): string {
	if (!Number.isFinite(value))
		throw new TypeError(`Loadscript value _${name} is not a finite number`)
	// Parenthesised so a template like `-_X` can't become a `--` comment
	return value < 0 ? `(${value})` : value.toString()
}

/** A value written where Lua expects an expression. */
function inCode(name: string, value: LoadscriptValue): string {
	if (typeof value === "string") return luaString(value)
	if (typeof value === "number") return numberSource(name, value)
	return value.raw
}

/** A value written inside a quoted string. Raw values are escaped too, as they become text there. */
function inString(value: LoadscriptValue): string {
	if (typeof value === "string") return escapeContent(value)
	if (typeof value === "number") return escapeContent(value.toString())
	return escapeContent(value.raw)
}

class LoadscriptBuilder {
	out = ""
	pos = 0
	constructor(
		readonly template: string,
		readonly values: LoadscriptValues
	) {}

	/** Copies the text up to `end` unchanged. */
	copyTo(end: number): void {
		this.out += this.template.slice(this.pos, end)
		this.pos = end
	}

	/** Copies a long bracket ([[...]], [==[...]==]) unchanged, as escapes don't work in long strings. */
	longBracket(level: string, isComment: boolean): void {
		const close = `]${level}]`
		const end = this.template.indexOf(close, this.pos)
		if (end === -1)
			throw new Error("Unterminated long bracket in loadscript")
		if (!isComment)
			for (const [text] of this.template
				.slice(this.pos, end)
				.matchAll(/[A-Za-z0-9_]+/g)) {
				const name = placeholder.exec(text)?.[1]
				if (name && this.values[name] !== undefined)
					throw new Error(
						`Loadscript placeholder ${text} is inside a long string, where it can't be escaped`
					)
			}
		this.copyTo(end + close.length)
	}

	/** Returns the placeholder's value, or undefined if the word isn't a placeholder. */
	lookup(text: string): { name: string; value: LoadscriptValue } | undefined {
		const name = placeholder.exec(text)?.[1]
		if (!name || luaGlobals.has(name)) return
		const value = this.values[name]
		if (value === undefined)
			throw new Error(`Loadscript placeholder _${name} has no value`)
		return { name, value }
	}

	/** Reads a word starting at pos, replacing it if it's a placeholder. */
	word(inQuotes: boolean): void {
		word.lastIndex = this.pos
		const text = word.exec(this.template)?.[0] ?? ""
		this.pos += text.length
		const found = this.lookup(text)
		if (!found) this.out += text
		else if (inQuotes) this.out += inString(found.value)
		else this.out += inCode(found.name, found.value)
	}

	shortString(quote: string): void {
		this.copyTo(this.pos + 1)
		for (;;) {
			const char = this.template[this.pos]
			if (char === undefined || char === "\n")
				throw new Error("Unterminated string in loadscript")
			if (char === quote) {
				this.copyTo(this.pos + 1)
				return
			}
			if (char === "\\") this.copyTo(this.pos + 2)
			else if (/[A-Za-z0-9_]/.test(char)) this.word(true)
			else this.copyTo(this.pos + 1)
		}
	}

	comment(): void {
		this.copyTo(this.pos + 2)
		longBracket.lastIndex = this.pos
		const long = longBracket.exec(this.template)
		if (long) {
			this.copyTo(this.pos + long[0].length)
			this.longBracket(long[1] ?? "", true)
			return
		}
		const end = this.template.indexOf("\n", this.pos)
		// Placeholders in a line comment are left alone, as nothing runs there
		this.copyTo(end === -1 ? this.template.length : end)
	}

	build(): string {
		while (this.pos < this.template.length) {
			const char = this.template[this.pos] ?? ""
			longBracket.lastIndex = this.pos
			const long = char === "[" ? longBracket.exec(this.template) : null
			if (long) {
				this.copyTo(this.pos + long[0].length)
				this.longBracket(long[1] ?? "", false)
			} else if (char === "-" && this.template[this.pos + 1] === "-")
				this.comment()
			else if (char === "'" || char === '"') this.shortString(char)
			else if (/[A-Za-z0-9_]/.test(char)) this.word(false)
			else this.copyTo(this.pos + 1)
		}
		return this.out
	}
}

/**
 * Replaces loadscript placeholders (`_NAME`) in one pass, following Lua's syntax so each value is escaped for where it appears.
 * In code, strings become quoted Lua literals, numbers stay as numbers and raw values stay as source. Inside a quoted string, every value is escaped as string content. Placeholders in comments are left alone.
 * Substituted values are never rescanned, and no value can end the string or comment it's in.
 * Throws if a placeholder in code or a string has no value, or a placeholder with a value is inside a long string, so a misspelt name fails instead of reaching the client.
 */
export const buildLoadscript = (
	template: string,
	values: LoadscriptValues
): string => new LoadscriptBuilder(template, values).build()
