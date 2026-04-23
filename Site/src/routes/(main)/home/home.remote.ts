import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import filter from "$lib/server/filter"
import { ratelimitRemote } from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import type { ClientForm } from "$lib/validate"

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

		await db.query(createCommentQuery, {
			content: filter(unfiltered),
			type: ["status"],
			user: Record("user", user.id),
		})
	}
)
