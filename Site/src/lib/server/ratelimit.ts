// TODO: Possibly move this to the database instead of server state

import { fail } from "@sveltejs/kit"
import { message, type SuperValidated } from "$lib/server/validate"
import { FixedWindow } from "./fixedWindow"

const windows = new FixedWindow()

type Form = SuperValidated<
	{ [_: string]: unknown },
	unknown,
	{ [_: string]: unknown }
> | null

const limit = (form: Form) =>
	form
		? message(form, "Too many requests", { status: 429 })
		: fail(429, { msg: "Too many requests" })

/** Allows for a function to be ratelimited by a category, and returns a 429 failure if too many requests are sent.
 * @param form The superForm object sent by the client. Can be null, in which case a fail object is returned.
 * @param category The category to ratelimit by.
 * @param getClientAddress The client's IP address, set by the adapter. Behind a proxy this relies on ADDRESS_HEADER and XFF_DEPTH being set.
 * @param timeWindow The length of the time window in seconds. It starts at the first request, and the count resets when it ends.
 * @param maxRequests The maximum number of requests allowed in the time window.
 * @returns The form object with a "Too many requests" error, if the ratelimit is exceeded.
 * @example
 *	const limit = ratelimit(form, "comment", getClientAddress, 5)
 *	if (limit) return limit
 */
const ratelimit = (
	form: Form,
	category: string,
	getClientAddress: () => string,
	timeWindow: number,
	maxRequests = 1
) => {
	// Fails closed: when the address can't be determined (for example ADDRESS_HEADER is set but the request didn't come through the proxy), such requests share one bucket instead of going unlimited
	let address = "unknown"
	try {
		address = getClientAddress()
	} catch {}

	if (windows.hit(`${address}\0${category}`, timeWindow * 1000, maxRequests))
		return

	console.log(`Ratelimited ${category}`)
	return limit(form)
}

export default ratelimit
