// Structured substitutions for the XML the Site serves to game clients.

const placeholder = /_([A-Z][A-Z0-9_]*)/g

const xmlEscapes: { [_: string]: string } = Object.freeze({
	"'": "&apos;",
	'"': "&quot;",
	"&": "&amp;",
	"<": "&lt;",
	">": "&gt;",
})

/** Escapes a value for XML text and attribute values, so it can't close an element or attribute. */
export const escapeXml = (value: string): string =>
	value.replaceAll(/[&<>"']/g, char => xmlEscapes[char] ?? char)

export interface XmlTemplateValues {
	[_: string]: boolean | number | string
}

/**
 * Fills `_NAME` placeholders in an XML template.
 * Every placeholder must have a value, and every value must be used exactly once, so a template and its values can't drift apart; values are XML-escaped and never rescanned.
 */
export function fillXmlTemplate(
	template: string,
	values: XmlTemplateValues
): string {
	const unused = new Set(Object.keys(values))
	const counts = new Map<string, number>()

	let out = ""
	let copied = 0
	for (const match of template.matchAll(placeholder)) {
		const name = match[1] ?? ""
		const value = values[name]
		if (value === undefined)
			throw new Error(`XML template placeholder ${match[0]} has no value`)

		counts.set(name, (counts.get(name) ?? 0) + 1)
		unused.delete(name)
		out += template.slice(copied, match.index) + escapeXml(String(value))
		copied = match.index + match[0].length
	}
	out += template.slice(copied)

	for (const name of Object.keys(values)) {
		const count = counts.get(name) ?? 0
		if (count === 0)
			throw new Error(`XML template value ${name} has no placeholder`)
		if (count > 1)
			throw new Error(
				`XML template value ${name} has ${count} placeholders`
			)
	}

	return out
}

// The host and path only, so any scheme in front of it stays. The lookbehind skips hostnames that merely end in roblox.com.
const robloxAssetUrl =
	/(?<![\w.-])(?:www\.)?roblox\.com\/asset(?=[/?#\s"'<]|$)/gi

/**
 * Points Roblox asset URLs in an XML asset at this Site, such as `http://www.roblox.com/asset?id=1`, keeping any scheme in front.
 * Other hostnames and paths are left alone, as is text with nothing URL-like around it.
 */
export const substituteRobloxAssetUrls = (
	xml: string,
	replacement: string
): string => xml.replaceAll(robloxAssetUrl, replacement)
