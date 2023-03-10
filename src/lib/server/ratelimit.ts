// Allows for a function to be ratelimited by a category,
// and returns a 429 failure if too many requests are sent

import { fail } from "@sveltejs/kit"

const ratelimitTimewindow = new Map<string, number>()
const ratelimitRequests = new Map<string, number>()
const existingTimeouts = new Map<string, any>()

export default function (category: string, getClientAddress: () => string, timeWindow: number, maxRequests = 1) {
	const id = getClientAddress() + category

	const currentTimewindow = ratelimitTimewindow.get(id) || Date.now()
	if (currentTimewindow > Date.now() + timeWindow * 1000) return fail(429, { msg: "Too many requests" })

	const currentRequests = (ratelimitRequests.get(id) || 0) + 1

	if (currentRequests > maxRequests) {
		ratelimitTimewindow.set(id, currentTimewindow)
		return fail(429, { msg: "Too many requests" })
	} else {
		clearTimeout(existingTimeouts.get(id))
		existingTimeouts.set(
			id,
			setTimeout(() => {
				ratelimitRequests.delete(id)
			}, timeWindow * 1000)
		)
		ratelimitRequests.set(id, currentRequests)
	}
}
