import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { setPasswordOf } from "#lib/server/db/accounts.ts"
import { writeAuditLog } from "#lib/server/db/audit.ts"
import { hashPassword } from "#lib/server/password.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { Record } from "#lib/server/surreal.ts"
import { usernameTest } from "#lib/typeTests.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	_password: "16 <= string <= 6969",
	username: usernameTest,
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ username, _password }, issues) => {
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
			const ok = await setPasswordOf(
				username,
				await hashPassword(_password)
			)
			if (!ok) return issues("No user found with given username")
		} catch (e) {
			console.error(e)
			return issues("An error occurred")
		}

		await writeAuditLog(
			"Account",
			`Change account password for ${username}`,
			Record("user", user.id)
		)

		return { success: "Password changed successfully!" }
	}
)
