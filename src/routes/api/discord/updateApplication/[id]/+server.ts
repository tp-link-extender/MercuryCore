import { query, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { verify } from "../../discord"

export async function POST({ request, url, params }) {
	verify(url)
	// Update user application
	let data: {
		status: string
		reason?: string
	}
	try {
		data = await request.json()
	} catch {
		error(400, "Invalid JSON")
	}

	const { status, reason } = data
	if (!status) error(400, "Missing status")
	if (!["Accepted", "Denied", "Banned"].includes(status))
		error(400, "Invalid status")

	if (status === "Accepted" && reason)
		error(400, "Reason for acceptance is not needed")
	if (["Denied", "Banned"].includes(status) && !reason)
		error(400, "Missing reason")

	await query(
		surql`
			UPDATE (
				SELECT * FROM application WHERE discordId = $id
				ORDER BY created DESC LIMIT 1
			)[0] MERGE {
				status: $status,
				reason: $reason,
				reviewed: time::now()
			}`,
		{
			id: parseInt(params.id),
			status,
			reason,
		}
	)

	return new Response()
}
