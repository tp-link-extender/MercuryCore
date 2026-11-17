import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { hashPassword } from "#lib/server/password.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { db, Record } from "#lib/server/surreal.ts"
import { usernameTest } from "#lib/typeTests.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import updatePasswordQuery from "./updatePassword.surql"

const schema = type({
	password: "16 <= string <= 6969",
	username: usernameTest,
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ username, password }, issues) => {
		const { locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals, 5)

		const limit = ratelimitRemote(
			issues,
			"changePassword",
			getClientAddress,
			30
		)
		if (limit) return limit

		try {
			// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- the query returns [result, loop result, ok]
			const [, , ok] = await db.query<boolean[]>(updatePasswordQuery, {
				npassword: await hashPassword(password),
				username,
			})
			if (!ok) return issues("No user found with given username")
		} catch (e) {
			console.error(e)
			return issues("An error occurred")
		}

		await db.run("fn::auditLog", [
			"Account",
			`Change account password for ${username}`,
			Record("user", user.id),
		])

		return { success: "Password changed successfully!" }
	}
)
