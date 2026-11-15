import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import { hashRecoveryToken } from "$lib/server/recoveryToken"
import { db, type RecordId } from "$lib/server/surreal"
import type { ClientForm } from "$lib/validate"
import consumeQuery from "./consume.surql"
import resetQuery from "./reset.surql"

const schema = type({
	cnpassword: "16 <= string <= 6969",
	npassword: "16 <= string <= 6969",
	token: "string >= 1",
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ token, npassword, cnpassword }, issues) => {
		const { cookies } = getRequestEvent()

		if (npassword !== cnpassword)
			return issues.cnpassword("Passwords do not match")

		// Use up the token before hashing the password, so requests without a valid token can't make the server do expensive work
		const [user] = await db.query<(RecordId<"user"> | undefined)[]>(
			consumeQuery,
			{ hash: hashRecoveryToken(token) }
		)
		if (!user)
			return issues(
				"This recovery link is invalid or has expired. Request a new one to try again."
			)

		await db.query(resetQuery, {
			hashedPassword: await Bun.password.hash(npassword),
			user,
		})
		cookies.set(cookieName, await createSession(user), cookieOptions)

		redirect(302, "/home")
	}
)
