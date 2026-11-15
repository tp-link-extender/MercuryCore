// TODO: Possibly move this to the database instead of server state

import { fail } from "@sveltejs/kit"
import type { Issues } from "$lib/validate"
import { FixedWindow } from "./fixedWindow"

const windows = new FixedWindow()

const msg = "Too many requests"

// Fails closed: when the address can't be determined (for example ADDRESS_HEADER is set but the request didn't come through the proxy), such requests share one bucket instead of going unlimited
const address = (getClientAddress: () => string) => {
	try {
		return getClientAddress()
	} catch {
		return "unknown"
	}
}

/**
 * Counts a request under a key chosen by the caller, such as a username, instead of the client's address.
 * @param category The category to ratelimit by.
 * @param key What to count requests by within the category.
 * @param timeWindow The length of the time window in seconds.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns Whether the request is over the limit.
 */
function hit(
	category: string,
	key: string,
	timeWindow: number,
	maxRequests = 1
) {
	if (windows.hit(`${key}\0${category}`, timeWindow * 1000, maxRequests))
		return false

	console.log(`Ratelimited ${category}`)
	return true
}

/** Allows for a function to be ratelimited by a category, and returns a 429 failure if too many requests are sent.
 * @param category The category to ratelimit by.
 * @param getClientAddress The client's IP address, set by the adapter. Behind a proxy this relies on ADDRESS_HEADER and XFF_DEPTH being set.
 * @param timeWindow The length of the time window in seconds. It starts at the first request, and the count resets when it ends.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns A failure with a "Too many requests" message, if the ratelimit is exceeded.
 * @example
 *	const limit = ratelimit("comment", getClientAddress, 5)
 *	if (limit) return limit
 */
export function ratelimit(
	category: string,
	getClientAddress: () => string,
	timeWindow: number,
	maxRequests = 1
) {
	if (hit(category, address(getClientAddress), timeWindow, maxRequests))
		return fail(429, { msg })
}

/** Like `ratelimit`, but counts requests under a key chosen by the caller, such as a username, instead of the client's address.
 * @param category The category to ratelimit by.
 * @param key What to count requests by within the category.
 * @param timeWindow The length of the time window in seconds.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns A failure with a "Too many requests" message, if the ratelimit is exceeded.
 */
export function ratelimitKey(
	category: string,
	key: string,
	timeWindow: number,
	maxRequests = 1
) {
	if (hit(category, key, timeWindow, maxRequests)) return fail(429, { msg })
}

/** Allows for a remote form function to be ratelimited by a category, and returns a 429 issue if too many requests are sent.
 * @param issues The issues callback passed to a remote form function.
 * @param category The category to ratelimit by.
 * @param getClientAddress The client's IP address, set by the adapter. Behind a proxy this relies on ADDRESS_HEADER and XFF_DEPTH being set.
 * @param timeWindow The length of the time window in seconds. It starts at the first request, and the count resets when it ends.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns An issue with a "Too many requests" message, if the ratelimit is exceeded.
 * @example
 *	const limit = ratelimitRemote(issues, "comment", getClientAddress, 5)
 *	if (limit) return limit
 */
export function ratelimitRemote(
	issues: Issues,
	category: string,
	getClientAddress: () => string,
	timeWindow: number,
	maxRequests = 1
) {
	if (hit(category, address(getClientAddress), timeWindow, maxRequests))
		return issues(msg)
}

/** Like `ratelimitRemote`, but counts requests under a key chosen by the caller, such as a username, instead of the client's address.
 * @param issues The issues callback passed to a remote form function.
 * @param category The category to ratelimit by.
 * @param key What to count requests by within the category.
 * @param timeWindow The length of the time window in seconds.
 * @param maxRequests The maximum number of requests allowed in the time window.
 */
export function ratelimitRemoteKey(
	issues: Issues,
	category: string,
	key: string,
	timeWindow: number,
	maxRequests = 1
) {
	if (hit(category, key, timeWindow, maxRequests)) return issues(msg)
}
