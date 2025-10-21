import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import { db, type RecordId } from "$lib/server/surreal"
import { usernameTest } from "$lib/typeTests"
import accountRegistered from "../accountRegistered"
import userQuery from "./user.surql"

const schema = type({
	username: usernameTest,
	password: "1 <= string <= 6969",
})

export async function load() {
	return {
		form: await superValidate(arktype(schema)),
		users: await accountRegistered(),
		descriptions: Object.entries(config.Branding.Descriptions),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ cookies, request }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { username, password } = form.data
	form.data.password = ""

	const [[user]] = await db.query<
		{
			id: RecordId<"user">
			hashedPassword: string
		}[][]
	>(userQuery, { username })

	// remove this statement and we'll end up like Mercury 1 💀
	if (!user || !Bun.password.verifySync(password, user.hashedPassword))
		return formError(
			form,
			["username", "password"],
			[" ", "Incorrect username or password"] // Don't give any extra information which may be useful to attackers
		)

	cookies.set(cookieName, await createSession(user.id), cookieOptions)

	redirect(302, "/home")
}
