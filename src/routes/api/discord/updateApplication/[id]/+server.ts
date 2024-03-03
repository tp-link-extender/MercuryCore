import { query, squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { verify } from "../../discord"

export async function POST({ request, url, params }) {
	verify(url)
	// Update user application
	const id = parseInt(params.id)
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
	if (!["Accepted", "Denied"].includes(status)) error(400, "Invalid status")

	if (status === "Accepted" && reason)
		error(400, "Reason for acceptance is not needed")
	if (status === "Denied" && !reason) error(400, "Missing reason for denial")

	if (
		!(await squery(
			surql`
				SELECT 1 FROM application WHERE discordId = $id
					AND deleted != true`,
			{ id }
		))
	)
		error(400, "User has no application")

	await query(
		surql`
			UPDATE application MERGE {
				status: $status,
				reason: $reason,
				reviewed: time::now()
			} WHERE discordId = $id`,
		{ id, status, reason }
	)

	return new Response()
}
