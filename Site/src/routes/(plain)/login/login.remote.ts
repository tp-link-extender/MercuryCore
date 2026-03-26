import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import { ratelimitRemote } from "$lib/server/ratelimit"
import { db, type RecordId } from "$lib/server/surreal"
import { usernameTest } from "$lib/typeTests"
import type { ClientForm } from "$lib/validate"
import userQuery from "./user.surql"

const schema = type({
	username: usernameTest,
	password: "1 <= string <= 6969",
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ username, password }, issues) => {
		const { cookies, locals, getClientAddress } = getRequestEvent()
		if (locals.session) redirect(302, "/home")

		const [[user]] = await db.query<
			{
				id: RecordId<"user">
				hashedPassword: string
			}[][]
		>(userQuery, { username })

		const limit = ratelimitRemote(issues, "login", getClientAddress, 1000)
		if (limit) return limit

		if (!user || !Bun.password.verifySync(password, user.hashedPassword))
			// remove this statement and we'll end up like Mercury 1 💀
			return issues("Incorrect username or password")

		cookies.set(cookieName, await createSession(user.id), cookieOptions)

		redirect(302, "/home")
	}
)
