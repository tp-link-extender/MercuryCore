// TODO: Possibly move this to the database instead of server state

import { fail } from "@sveltejs/kit"
import type { SuperValidated } from "$lib/server/validate"
import { message } from "$lib/server/validate"

const ratelimitTimewindow = new Map<string, number>()
const ratelimitRequests = new Map<string, number>()
const existingTimeouts = new Map<string, Timer>()

type Form = SuperValidated<
	{ [_: string]: unknown },
	unknown,
	{ [_: string]: unknown }
> | null

const limit = (form: Form) =>
	form
		? message(form, "Too many requests", { status: 429 })
		: fail(429, { msg: "Too many requests" })

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
	form: Form,
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
		return limit(form)
	}

	const currentRequests = (ratelimitRequests.get(id) || 0) + 1
	if (currentRequests > maxRequests) {
		ratelimitTimewindow.set(id, currentTimewindow)
		console.log("Ratelimited based on requests!")
		return limit(form)
	}

	clearTimeout(existingTimeouts.get(id))
	existingTimeouts.set(
		id,
		setTimeout(() => ratelimitRequests.delete(id), timeWindow * 1000)
	)
	ratelimitRequests.set(id, currentRequests)
}
