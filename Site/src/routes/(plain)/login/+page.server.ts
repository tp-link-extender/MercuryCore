import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import { verifyPassword } from "$lib/server/password"
import ratelimit, { ratelimitKey } from "$lib/server/ratelimit"
import { db, type RecordId } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import { usernameTest } from "$lib/typeTests"
import accountRegistered from "../accountRegistered"
import type { Actions } from "./$types"
import userQuery from "./user.surql"

const schema = type({
	password: "1 <= string <= 6969",
	username: usernameTest,
})

export const load = async () => ({
	descriptions: Object.entries(config.Branding.Descriptions),
	form: await superValidate(arktype(schema)),
	users: await accountRegistered(),
})

export const actions: Actions = {}
actions.default = async ({ cookies, getClientAddress, request }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { username, password } = form.data
	form.data.password = ""

	// Per address against guessing many accounts, and per account against guessing from many addresses
	const limit =
		ratelimit(form, "login", getClientAddress, 300, 10) ||
		ratelimitKey(form, "loginUser", username.toLowerCase(), 300, 10)
	if (limit) return limit

	const [[user]] = await db.query<
		{
			id: RecordId<"user">
			hashedPassword: string
		}[][]
	>(userQuery, { username })

	// Checked even when the user doesn't exist, so the response time doesn't reveal which usernames are registered
	const valid = await verifyPassword(password, user?.hashedPassword)
	// remove this statement and we'll end up like Mercury 1 💀
	if (!user || !valid)
		return formError(
			form,
			["username", "password"],
			[" ", "Incorrect username or password"] // Don't give any extra information which may be useful to attackers
		)

	cookies.set(cookieName, await createSession(user.id), cookieOptions)

	redirect(302, "/home")
}
