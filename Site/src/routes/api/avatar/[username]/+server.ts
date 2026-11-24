import { error } from "@sveltejs/kit"
import { dbQuery } from "#lib/server/db/query.ts"
import { toRawId } from "#lib/server/recordId.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import { waitForChange } from "#lib/server/waitForChange.ts"
import type { RequestEvent } from "./$types"

const timeout = 10 // seconds

export async function GET({ params, url }: RequestEvent) {
	let { username } = params
	if (!username) error(400, "Invalid Request")

	const wait = url.searchParams.has("wait")

	let shotType = "-head"
	if (username.endsWith("-body")) {
		username = username.slice(0, -"-body".length)
		shotType = "-body"
	}

	const [[user]] = await dbQuery<{ id: RecordId<"user"> }[][]>(
		"SELECT id FROM user WHERE username = $username",
		{ username }
	)
	if (!user) error(404, "User not found")

	const path = `../data/avatars/${toRawId(user.id)}${shotType}.png`

	try {
		if (wait)
			// If the file doesn't exist, this returns at once; if it does, wait for it to be modified, but not forever
			await waitForChange(path, timeout * 1000)

		// The file may still be missing after a wait, such as when it was never created, and reading it would fail
		if (!(await Bun.file(path).exists()))
			throw new Error("File does not exist")

		return new Response(Bun.file(path))
	} catch {
		return new Response(Bun.file("static/dots.png"))
	}
}
