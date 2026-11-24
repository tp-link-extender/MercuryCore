import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions } from "#lib/server/auth.ts"
import { createSession } from "#lib/server/db/sessions.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { verifyPassword } from "#lib/server/password.ts"
import { ratelimitRemote, ratelimitRemoteKey } from "#lib/server/ratelimit.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import { usernameTest } from "#lib/typeTests.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import userQuery from "./user.surql"

const schema = type({
	_password: "1 <= string <= 6969",
	username: usernameTest,
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ username, _password }, issues) => {
		const { cookies, locals, getClientAddress } = getRequestEvent()
		if (locals.session) redirect(302, "/home")

		// Per address against guessing many accounts, and per account against guessing from many addresses
		const limit =
			ratelimitRemote(issues, "login", getClientAddress, 300, 10) ||
			ratelimitRemoteKey(
				issues,
				"loginUser",
				username.toLowerCase(),
				300,
				10
			)
		if (limit) return limit

		const [[user]] = await dbQuery<
			{
				id: RecordId<"user">
				hashedPassword: string
			}[][]
		>(userQuery, { username })

		// Checked even when the user doesn't exist, so the response time doesn't reveal which usernames are registered
		const valid = await verifyPassword(_password, user?.hashedPassword)
		// remove this statement and we'll end up like Mercury 1 💀
		if (!user || !valid)
			// Don't give any extra information which may be useful to attackers
			return issues("Incorrect username or password")

		cookies.set(cookieName, await createSession(user.id), cookieOptions)

		redirect(302, "/home")
	}
)
