import { query, squery, surql } from "$lib/server/surreal"
import { error, json } from "@sveltejs/kit"
import { verify, canApply } from "../../discord"

export async function POST({ url, params }) {
	verify(url)
	// Create a new application for the user
	const id = parseInt(params.id)
	const ban = await squery<{ reason: string }>(
		surql`SELECT reason FROM type::thing("applicationBan", $id)`,
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

	await query(
		surql`
			CREATE application CONTENT {
				discordId: $id,
				status: "Pending",
				created: time::now()
			}`,
		{ id }
	)

	return new Response("OK")
}
