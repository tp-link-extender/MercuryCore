// Allows for a function to be ratelimited by a category,
// and returns a 429 failure if too many requests are sent

import { message } from "sveltekit-superforms/server"

const ratelimitTimewindow = new Map<string, number>()
const ratelimitRequests = new Map<string, number>()
const existingTimeouts = new Map<string, any>()

/** Ratelimit a function by a category.
 * @param form The superForm object sent by the client.
 * @param category The category to ratelimit by.
 * @param getClientAddress The client's IP address, set by the adapter.
 * @param timeWindow The time window in seconds. If there are no successful requests in this time, the ratelimit is reset.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns The form object with a "Too many requests" error, if the ratelimit is exceeded.
 * @example
 *	const limit = ratelimit(form, "statusPost", getClientAddress, 30)
 *	if (limit) return limit
 */
export default function (
	form: any,
	category: string,
	getClientAddress: () => string,
	timeWindow: number,
	maxRequests = 1,
) {
	const id = getClientAddress() + category

	const currentTimewindow = ratelimitTimewindow.get(id) || Date.now()
	if (currentTimewindow > Date.now() + timeWindow * 1000)
		return message(form, "Too many requests", { status: 429 })

	const currentRequests = (ratelimitRequests.get(id) || 0) + 1

	if (currentRequests > maxRequests) {
		ratelimitTimewindow.set(id, currentTimewindow)
		return message(form, "Too many requests", { status: 429 })
	} else {
		clearTimeout(existingTimeouts.get(id))
		existingTimeouts.set(
			id,
			setTimeout(() => ratelimitRequests.delete(id), timeWindow * 1000),
		)
		ratelimitRequests.set(id, currentRequests)
	}
}
