import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import exclude from "#lib/server/exclude.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { db } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import createQuery from "./create.surql"

const schema = type({
	description: "1 <= string <= 300",
	name: "1 <= string <= 50",
})

export const formData = form(schema, async ({ description, name }, issues) => {
	exclude("Forum")
	const { locals, getClientAddress } = getRequestEvent()
	await authorise(locals, 5)
	// Conflicts with /forum/create
	if (name.toLowerCase() === "create")
		return issues.name("Can't park there mate")

	const limit = ratelimitRemote(issues, "forumCategory", getClientAddress, 30)
	if (limit) return limit

	await db.query(createQuery, { description, name })

	redirect(302, `/forum/${name}`)
}) as ClientForm<typeof schema.infer>
