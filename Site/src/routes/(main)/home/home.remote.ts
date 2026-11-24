import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { createComment } from "#lib/server/db/comments.ts"
import filter from "#lib/server/filter.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	status: "1 <= string <= 1000",
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ status }, issues) => {
		const { locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		const unfiltered = status.trim()
		if (!unfiltered) return issues.status("Status must have content")

		const limit = ratelimitRemote(issues, "comment", getClientAddress, 5)
		if (limit) return limit

		await createComment({
			content: filter(unfiltered),
			type: ["status"],
			user: Record("user", user.id),
		})
	}
)
