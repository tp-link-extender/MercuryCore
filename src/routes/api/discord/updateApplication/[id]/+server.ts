import { mquery, surql, getError } from "$lib/server/surreal"
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

	let response: {
		created: string
		expiry: null
		id: string
		usesLeft: number
	}[] = []

	try {
		response = await mquery(
			surql`
				LET $application = (
					SELECT * FROM application WHERE discordId = $id
					ORDER BY created DESC LIMIT 1
				)[0];
				IF !$application {
					THROW "Application not found"
				} ELSE IF $application.status != "Pending" {
					THROW "Application already reviewed"
				};
				BEGIN TRANSACTION;
				UPDATE $application MERGE {
					status: $status,
					reason: $reason,
					reviewed: time::now()
				};
				# If the response was accepted, create a new regKey to allow the user to register
				IF $status = "Accepted" {
					LET $key = (CREATE regKey CONTENT {
						usesLeft: 1,
						expiry: NONE,
						created: time::now(),
					})[0];
					RELATE $application->applicationKey->$key;
					RETURN $key
				};
				COMMIT TRANSACTION`,
			{
				id: params.id,
				status,
				reason,
			}
		)
	} catch (err) {
		const e = err as Error
		const gotError = getError(e.message)

		if (e) error(400, gotError)
		else error(500, "Internal Server Error")
	}

	return new Response(
		response?.[3]?.id
			? `mercurkey-${response[3].id.split(":")[1]}`
			: undefined
	)
}
