import { equery, surrealql } from "$lib/server/surreal"
import getNotifications from "./notifications.ts"

let lines = "0"

// extract the line count from the stupid file that scc outputs
try {
	const codes = (await Bun.file("data/lines").text()) // 月 moment
		.split("\n")
		.filter(l => l.startsWith("  code"))

	lines = codes[codes.length - 1].split(" ").pop() || "Unknown"
} catch (e) {
	console.error(e)
}

type Banner = {
	// bruce, it's- I'm not doing this again
	id: string
	bgColour: string
	body: string
	textLight: boolean
}

export async function load({ request, locals }) {
	const { user } = locals
	// No authorise() function call, as we don't want to redirect to login page if not logged in

	const [banners] = await equery<Banner[][]>(surrealql`
		SELECT
			body,
			bgColour,
			textLight,
			meta::id(id) AS id
		OMIT deleted
		FROM banner WHERE deleted = false AND active = true`)

	const isStudio = request.headers
		.get("user-agent")
		?.includes("RobloxStudio/2013")

	return {
		banners,
		user,
		notifications: await getNotifications(user),
		url: request.url,
		domain: process.env.DOMAIN as string,
		lines, // footer thing
		...(isStudio && { isStudio }),
	}
}
