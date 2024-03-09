import { query, squery, surql } from "$lib/server/surreal"
import { error, json } from "@sveltejs/kit"
import { verify, canApply } from "../../discord"

export async function POST({ request, url, params }) {
	verify(url)
	// Create a new application for the user
	const id = +params.id
	let data: string[]
	try {
		data = await request.json()
	} catch {
		error(400, "Invalid JSON")
	}

	if (!Array.isArray(data)) error(400, "Body must be an array")

	const ban = await squery<{ reason: string }>(
		surql`
			SELECT reason, created FROM application
			WHERE discordId = $id AND status = "Banned"
			ORDER BY created DESC LIMIT 1`,
		{ id }
	)

	if (ban)
		// Can't error() with an object that has more than just a message
		return json(
			{
				message: "This user is banned",
				reason: ban.reason,
			},
			{ status: 400 }
		)
	if (!(await canApply(id))) error(400, "This user can't apply again")
	// if user already applied and has been accepted, error
	if (
		await squery(
			surql`
				SELECT 1 FROM application
				WHERE discordId = $id AND status = "Accepted"`,
			{ id }
		)
	)
		error(400, "This user has already been accepted")

	await query(
		surql`
			CREATE application CONTENT {
				discordId: $id,
				status: "Pending",
				created: time::now(),
				response: $data
			}`,
		{ id, data }
	)

	return new Response()
}
