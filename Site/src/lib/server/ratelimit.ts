// TODO: Possibly move this to the database instead of server state

import { fail } from "@sveltejs/kit"
import type { Issues } from "$lib/validate"

const ratelimitTimewindow = new Map<string, number>()
const ratelimitRequests = new Map<string, number>()
const existingTimeouts = new Map<string, Timer>()

const msg = "Too many requests"
const limit = (issues?: Issues) => (issues ? issues(msg) : fail(429, { msg }))

const winlel =
	"Failed to ratelimit! Are you running Windows? Whoops, that sounds like a you problem!"

/** Allows for a function to be ratelimited by a category, and returns a 429 failure if too many requests are sent.
 * @param form The superForm object sent by the client. Can be null, in which case a fail object is returned.
 * @param category The category to ratelimit by.
 * @param getClientAddress The client's IP address, set by the adapter.
 * @param timeWindow The time window in seconds. If there are no successful requests in this time, the ratelimit is reset.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns The form object with a "Too many requests" error, if the ratelimit is exceeded.
 * @example
 *	const limit = ratelimit(form, "comment", getClientAddress, 5)
 *	if (limit) return limit
 */
export default (
	issues: Issues | undefined,
	category: string,
	getClientAddress: () => string,
	timeWindow: number,
	maxRequests = 1
) => {
	let id: string
	try {
		id = getClientAddress() + category
	} catch {
		console.log(winlel)
		return
	}
	const currentTimewindow = ratelimitTimewindow.get(id) || Date.now()

	if (currentTimewindow > Date.now() + timeWindow * 1000) {
		console.log("Ratelimited based on time window!")
		return limit(issues)
	}

	const currentRequests = (ratelimitRequests.get(id) || 0) + 1
	if (currentRequests > maxRequests) {
		ratelimitTimewindow.set(id, currentTimewindow)
		console.log("Ratelimited based on requests!")
		return limit(issues)
	}

	clearTimeout(existingTimeouts.get(id))
	existingTimeouts.set(
		id,
		setTimeout(() => ratelimitRequests.delete(id), timeWindow * 1000)
	)
	ratelimitRequests.set(id, currentRequests)
}
