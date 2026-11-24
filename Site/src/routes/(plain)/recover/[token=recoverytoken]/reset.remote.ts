import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions } from "#lib/server/auth.ts"
import { consumeRecoveryToken, resetPassword } from "#lib/server/db/accounts.ts"
import { createSession } from "#lib/server/db/sessions.ts"
import { hashPassword } from "#lib/server/password.ts"
import { hashRecoveryToken } from "#lib/server/recoveryToken.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"

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
		const user = await consumeRecoveryToken(hashRecoveryToken(token))
		if (!user)
			return issues(
				"This recovery link is invalid or has expired. Request a new one to try again."
			)

		await resetPassword(user, await hashPassword(_npassword))
		cookies.set(cookieName, await createSession(user), cookieOptions)

		redirect(302, "/home")
	}
)
