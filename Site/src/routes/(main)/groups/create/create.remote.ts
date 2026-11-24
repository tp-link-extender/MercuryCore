import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createGroup } from "economy/api"
import { User } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { createGroupRecord } from "#lib/server/db/groups.ts"
import { findWhere } from "#lib/server/db/records.ts"
import exclude from "#lib/server/exclude.ts"
import { Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	name: "3 <= string <= 40",
})

const errors: { [_: string]: string } = Object.freeze({
	changed: "Dickhead",
	create: Buffer.from("ZHVtYiBuKiBkZXRlY3RlZA==", "base64").toString(),
	wisely: "GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!",
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ name }, issues) => {
		exclude("Groups")
		const { fetch: f, locals } = getRequestEvent()
		const { user } = await authorise(locals)

		const lowercaseName = name.toLowerCase()
		if (errors[lowercaseName]) return issues.name(errors[lowercaseName])

		const foundGroup = await findWhere(
			"group",
			"string::lowercase(name) = $lowercaseName",
			{ lowercaseName }
		)
		if (foundGroup)
			return issues.name("A group with this name already exists")

		const created = await createGroup(f, new User(user.id))
		if (!created.ok) return issues("Failed to create group")

		// The Economy service issues the group's ID, and the database record
		// uses it as its own ID so ownership can be resolved from the ledger.
		const groupId = created.value.ID

		await createGroupRecord(groupId, name, Record("user", user.id))

		redirect(302, `/groups/${groupId}`)
	}
)
