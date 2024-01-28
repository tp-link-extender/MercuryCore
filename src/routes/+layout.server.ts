import fs from "fs"
import { query, surql } from "$lib/server/surreal"
import getNotifications from "./notifications"

let lines = "0"

// extract the line count from the stupid file that scc outputs
try {
	lines =
		fs
			.readFileSync("data/lines", "utf-8")
			.split("\n")
			.filter(l => l.startsWith("  n_lines"))[0]
			.split(" ")
			.pop() || "0"
} catch (e) {
	console.error(e)
}

export async function load({ request, locals }) {
	const { session, user } = locals
	// Not authorise function, as we don't want
	// to redirect to login page if not logged in

	const banners = await query<{
		body: string
		bgColour: string
		textLight: boolean
		id: string
	}>(surql`
		SELECT
			body,
			bgColour,
			textLight,
			meta::id(id) AS id
		OMIT deleted
		FROM banner
		WHERE deleted = false AND active = true`)

	return {
		banners,
		user,
		notifications: await getNotifications(session, user),
		url: request.url,
		lines, // footer thing
	}
}
