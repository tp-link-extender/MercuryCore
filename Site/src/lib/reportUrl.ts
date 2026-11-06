const sameSiteOrigin = "https://mercury.invalid"
const maxLength = 2048

const hasControlCharacter = (value: string): boolean => {
	for (const char of value) {
		const code = char.charCodeAt(0)
		if (code < 0x20 || code === 0x7f) return true
	}
	return false
}

/**
 * Returns a canonical same-site path, or null when the value is not one.
 * Absolute URLs, protocol-relative URLs and javascript:/data: values are rejected.
 */
export const reportPath = (value: string): string | null => {
	if (value.length === 0 || value.length > maxLength) return null
	if (!value.startsWith("/") || value.startsWith("//")) return null
	if (value.includes("\\") || hasControlCharacter(value)) return null

	let url: URL
	try {
		url = new URL(value, sameSiteOrigin)
	} catch {
		return null
	}

	if (url.origin !== sameSiteOrigin) return null
	// Dot segments can normalise a same-origin path back into a protocol-relative one.
	if (!url.pathname.startsWith("/") || url.pathname.startsWith("//"))
		return null

	return `${url.pathname}${url.search}${url.hash}`
}
