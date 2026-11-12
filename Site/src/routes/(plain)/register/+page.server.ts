import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import { toRawId } from "$lib/server/recordId"
import requestRender from "$lib/server/requestRender"
import { db, findWhere, Record, type RecordId } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import { usernameTest } from "$lib/typeTests"
import accountRegistered from "../accountRegistered"
import type { Actions } from "./$types"
import createUserQuery from "./createUser.surql"
import regkeyCheckQuery from "./regkeyCheck.surql"

const schemaInitial = type({
	cpassword: "1 <= string <= 6969",
	password: "1 <= string <= 6969",
	username: usernameTest,
})
const schema = type({
	username: usernameTest,
	...(config.Registration.Emails && {
		email: type(/^.+@.+$/).configure({
			problem: "must be a valid RFC-5321 email address",
		}),
	}), // https://youtu.be/mrGfahzt-4Q?t=1563
	cpassword: "16 <= string <= 6969",
	password: "16 <= string <= 6969",
	...(config.Registration.Keys.Enabled && {
		regkey: "1 <= string <= 6969",
	}),
})

const prefix = config.Registration.Keys.Prefix
const prefixRegex = new RegExp(`^${prefix}(.+)$`)

export const load = async () => ({
	emailsEnabled: config.Registration.Emails,
	form: await superValidate(arktype(schema)),
	prefix,
	regKeysEnabled: config.Registration.Keys.Enabled,
	users: await accountRegistered(),
})

export const actions: Actions = {}
actions.register = async ({ fetch: f, cookies, request }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { username, password, cpassword, email } = form.data
	form.data.password = ""
	form.data.cpassword = ""

	if (cpassword !== password)
		return formError(
			form,
			["password", "cpassword"],
			[" ", "Passwords do not match"]
		)

	const userCheck = await findWhere("user", "username = $username", {
		username,
	})
	if (userCheck)
		return formError(
			form,
			["username"],
			["This username is already in use"]
		)

	if (config.Registration.Emails) {
		const emailCheck = await findWhere("user", "email = $email", { email })
		if (emailCheck)
			return formError(form, ["email"], ["This email is already in use"])
	}

	let key: RecordId<"regKey"> | undefined
	if (config.Registration.Keys.Enabled) {
		const { regkey } = form.data
		const matched = regkey.match(prefixRegex)
		if (!matched)
			return formError(form, ["regkey"], ["Registration key is invalid"])

		key = Record("regKey", matched[1])

		const [[regkeyCheck]] = await db.query<{ usesLeft: number }[][]>(
			regkeyCheckQuery,
			{ key }
		)
		if (!regkeyCheck)
			return formError(
				form,
				["regkey"],
				["Registration key is invalid or has expired"]
			)
		if (regkeyCheck.usesLeft < 1)
			return formError(
				form,
				["regkey"],
				["This registration key has ran out of uses"]
			)
	}

	const results = await db.query<RecordId<"user">[]>(createUserQuery, {
		bodyColours: config.DefaultBodyColors,
		email: email || "",
		// I still love scrypt, though argon2 is better supported
		hashedPassword: Bun.password.hashSync(password),
		key,
		permissionLevel: 1,
		username,
	})
	const user = results.at(-1)
	if (!user) {
		if (key)
			return formError(
				form,
				["regkey"],
				["Registration key is invalid or has expired"]
			)
		throw new Error("Failed to create user")
	}

	try {
		await requestRender(f, "Avatar", toRawId(user.id), username)
	} catch {}

	cookies.set(cookieName, await createSession(user), cookieOptions)

	redirect(302, "/home")
}
// This is the initial account creation, which is only allowed if there are no existing users.
actions.initialAccount = async ({ fetch: f, cookies, request }) => {
	const form = await superValidate(request, arktype(schemaInitial))
	if (!form.valid) return formError(form)

	const { username, password, cpassword } = form.data
	form.data.password = ""
	form.data.cpassword = ""

	if (cpassword !== password)
		return formError(
			form,
			["password", "cpassword"],
			[" ", "The specified passwords do not match"]
		)
	if (await accountRegistered())
		return formError(
			form,
			["username"],
			["There's already an account registered"]
		)

	// This is the kind of stuff that always breaks due to never getting tested
	// Remember: untested === unworking
	const results = await db.query<RecordId<"user">[]>(createUserQuery, {
		bodyColours: config.DefaultBodyColors,
		email: "",
		hashedPassword: Bun.password.hashSync(password),
		permissionLevel: 5,
		username,
	})
	const user = results.at(-1)
	if (!user) throw new Error("Failed to create initial account")

	try {
		await requestRender(f, "Avatar", toRawId(user.id), username)
	} catch {}

	cookies.set(cookieName, await createSession(user), cookieOptions)

	redirect(302, "/home")
}
