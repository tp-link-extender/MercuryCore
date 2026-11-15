import constantTimeEqual from "./constantTimeEqual"

export const minKeyLength = 16
// Values shipped in example files, which must never be accepted as real keys
const placeholderKeys = Object.freeze(new Set(["password", "change-me"]))
const warned = new Set<string>()

/** Whether a configured key is long enough and isn't an example value. */
export const isUsableKey = (key: string | undefined): key is string =>
	key !== undefined && key.length >= minKeyLength && !placeholderKeys.has(key)

/**
 * Checks a request's `Authorization: Bearer` header against a configured key in constant time.
 * Fails closed: if the key is unset, shorter than `minKeyLength` or an example value, every request is refused, and a warning is logged once naming the variable (never its value).
 * @param request The incoming request.
 * @param key The configured key.
 * @param name The environment variable the key comes from, for the warning.
 */
export function bearerMatches(
	request: Request,
	key: string | undefined,
	name: string
): boolean {
	if (!isUsableKey(key)) {
		if (!warned.has(name)) {
			warned.add(name)
			console.error(
				`${name} is unset, shorter than ${minKeyLength} characters or an example value, so requests that need it are refused. Generate one with \`openssl rand -hex 32\`.`
			)
		}
		return false
	}

	const auth = request.headers.get("Authorization")
	if (!auth?.startsWith("Bearer ")) return false
	return constantTimeEqual(auth.slice(7), key)
}
