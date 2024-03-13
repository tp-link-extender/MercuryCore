import fs from "node:fs"
import { banner } from "$lib/server/orm"
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
	// Not authorise function, as we don't want to redirect to login page if not logged in

	const banners = await banner
		.where(["deleted = false", "active = true"])
		.select("body", "bgColour", "textLight", "metaId")

	const isStudio = request.headers
		.get("user-agent")
		?.includes("RobloxStudio/2013")

	return {
		banners,
		user,
		notifications: await getNotifications(session, user),
		url: request.url,
		lines, // footer thing
		...(isStudio && { isStudio }),
	}
}
