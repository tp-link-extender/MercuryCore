import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import { ratelimitRemote } from "$lib/server/ratelimit"
import { db } from "$lib/server/surreal"
import type { ClientForm } from "$lib/validate"
import createQuery from "./create.surql"

const schema = type({
	name: "1 <= string <= 50",
	description: "1 <= string <= 300",
})

export const formData = form(schema, async ({ description, name }, issues) => {
	exclude("Forum")
	const { locals, getClientAddress } = getRequestEvent()
	await authorise(locals, 5)
	// Conflicts with /forum/create
	if (name.toLowerCase() === "create")
		// return formError(form, ["name"], ["Can't park there mate"])
		return issues.name("Can't park there mate")

	const limit = ratelimitRemote(issues, "forumCategory", getClientAddress, 30)
	if (limit) return limit

	await db.query(createQuery, { description, name })

	redirect(302, `/forum/${name}`)
}) as ClientForm<typeof schema.infer>
