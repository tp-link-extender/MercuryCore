import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions } from "#lib/server/auth.ts"
import { createSession } from "#lib/server/db/sessions.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { hashPassword } from "#lib/server/password.ts"
import { hashRecoveryToken } from "#lib/server/recoveryToken.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import consumeQuery from "./consume.surql"
import resetQuery from "./reset.surql"

const schema = type({
	_cnpassword: "16 <= string <= 6969",
	_npassword: "16 <= string <= 6969",
	token: "string >= 1",
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ token, _npassword, _cnpassword }, issues) => {
		const { cookies } = getRequestEvent()

		if (_npassword !== _cnpassword)
			return issues._cnpassword("Passwords do not match")

		// Use up the token before hashing the password, so requests without a valid token can't make the server do expensive work
		const [user] = await dbQuery<(RecordId<"user"> | undefined)[]>(
			consumeQuery,
			{ hash: hashRecoveryToken(token) }
		)
		if (!user)
			return issues(
				"This recovery link is invalid or has expired. Request a new one to try again."
			)

		await dbQuery(resetQuery, {
			hashedPassword: await hashPassword(_npassword),
			user,
		})
		cookies.set(cookieName, await createSession(user), cookieOptions)

		redirect(302, "/home")
	}
)
