import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import config from "$lib/server/config"
import requestRender from "$lib/server/requestRender"
import { db, findWhere, Record, type RecordId } from "$lib/server/surreal"
import { usernameTest } from "$lib/typeTests"
import type { ClientForm } from "$lib/validate"
import accountRegistered from "../accountRegistered"
import createUserQuery from "./createUser.surql"
import regkeyCheckQuery from "./regkeyCheck.surql"

const schemaInitial = type({
	username: usernameTest,
	password: "1 <= string <= 6969",
	cpassword: "1 <= string <= 6969",
})
const schema = type({
	username: usernameTest,
	...(config.Registration.Emails && {
		email: type(/^.+@.+$/).configure({
			problem: "must be a valid RFC-5321 email address",
		}),
	}), // https://youtu.be/mrGfahzt-4Q?t=1563
	password: "16 <= string <= 6969",
	cpassword: "16 <= string <= 6969",
	...(config.Registration.Keys.Enabled && {
		regkey: "1 <= string <= 6969",
	}),
})

const prefix = config.Registration.Keys.Prefix
const prefixRegex = new RegExp(`^${prefix}(.+)$`)

export const register: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ username, email, password, cpassword, regkey }, issues) => {
		const { fetch: f, cookies, locals } = getRequestEvent()
		if (locals.session) return redirect(302, "/home")

		if (cpassword !== password) return issues("Passwords do not match")

		const userCheck = await findWhere("user", "username = $username", {
			username,
		})
		if (userCheck) return issues.username("This username is already in use")

		if (config.Registration.Emails) {
			const emailCheck = await findWhere("user", "email = $email", {
				email,
			})
			if (emailCheck) return issues.email("This email is already in use")
		}

		let key: RecordId<"regKey"> | undefined
		if (config.Registration.Keys.Enabled) {
			const matched = regkey.match(prefixRegex)
			if (!matched) return issues.regkey("Registration key is invalid")

			key = Record("regKey", matched[1])

			const [[regkeyCheck]] = await db.query<{ usesLeft: number }[][]>(
				regkeyCheckQuery,
				{ key }
			)
			if (!regkeyCheck)
				return issues.regkey("Registration key is invalid")
			if (regkeyCheck.usesLeft < 1)
				return issues.regkey(
					"This registration key has ran out of uses"
				)
		}

		const [, user] = await db.query<RecordId<"user">[]>(createUserQuery, {
			username,
			email: email || "",
			// I still love scrypt, though argon2 is better supported
			hashedPassword: Bun.password.hashSync(password),
			permissionLevel: 1,
			bodyColours: config.DefaultBodyColors,
			key,
		})

		try {
			await requestRender(f, "Avatar", user.id.toString(), username)
		} catch {}

		cookies.set(cookieName, await createSession(user), cookieOptions)

		redirect(302, "/home")
	}
)
// This is the initial account creation, which is only allowed if there are no existing users.
export const initialAccount: ClientForm<typeof schemaInitial.infer> = form(
	schemaInitial,
	async ({ username, password, cpassword }, issues) => {
		const { fetch: f, cookies, locals } = getRequestEvent()
		if (locals.session) return redirect(302, "/home")

		if (cpassword !== password) return issues("Passwords do not match")
		if (await accountRegistered())
			return issues("There's already an account registered")

		// This is the kind of stuff that always breaks due to never getting tested
		// Remember: untested === unworking
		const [, user] = await db.query<RecordId<"user">[]>(createUserQuery, {
			username,
			email: "",
			hashedPassword: Bun.password.hashSync(password),
			permissionLevel: 5,
			bodyColours: config.DefaultBodyColors,
		})

		try {
			await requestRender(f, "Avatar", user.id.toString(), username)
		} catch {}

		cookies.set(cookieName, await createSession(user), cookieOptions)

		redirect(302, "/home")
	}
)
