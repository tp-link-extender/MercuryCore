import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions, createSession } from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import { hashPassword } from "#lib/server/password.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { toRawId } from "#lib/server/recordId.ts"
import requestRender from "#lib/server/requestRender.ts"
import { db, findWhere, Record, type RecordId } from "#lib/server/surreal.ts"
import { usernameTest } from "#lib/typeTests.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import accountRegistered from "../accountRegistered"
import createUserQuery from "./createUser.surql"
import initialAccountQuery from "./initialAccount.surql"
import regkeyCheckQuery from "./regkeyCheck.surql"

const schemaInitial = type({
	cpassword: "16 <= string <= 6969",
	password: "16 <= string <= 6969",
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

export const register: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ username, email, password, cpassword, regkey }, issues) => {
		const {
			fetch: f,
			cookies,
			locals,
			getClientAddress,
		} = getRequestEvent()
		if (locals.session) return redirect(302, "/home")

		const limit = ratelimitRemote(
			issues,
			"register",
			getClientAddress,
			600,
			5
		)
		if (limit) return limit

		if (cpassword !== password) return issues("Passwords do not match")

		const userCheck = await findWhere(
			"user",
			"usernameLower = string::lowercase($username)",
			{ username }
		)
		if (userCheck) return issues.username("This username is already in use")

		if (config.Registration.Emails) {
			const emailCheck = await findWhere("user", "email = $email", {
				email,
			})
			if (emailCheck) return issues.email("This email is already in use")
		}

		let key: RecordId<"regKey"> | undefined
		if (config.Registration.Keys.Enabled) {
			// The prefix is plain config, so metacharacters in it must stay literal instead of being read as a pattern
			const keyId = regkey.startsWith(prefix)
				? regkey.slice(prefix.length)
				: ""
			if (!keyId) return issues.regkey("Registration key is invalid")

			key = Record("regKey", keyId)

			const [[regkeyCheck]] = await db.query<{ usesLeft: number }[][]>(
				regkeyCheckQuery,
				{ key }
			)
			if (!regkeyCheck)
				return issues.regkey(
					"Registration key is invalid or has expired"
				)
			if (regkeyCheck.usesLeft < 1)
				return issues.regkey(
					"This registration key has ran out of uses"
				)
		}

		const results = await db.query<RecordId<"user">[]>(createUserQuery, {
			bodyColours: config.DefaultBodyColors,
			email: email || "",
			// I still love scrypt, though argon2 is better supported
			hashedPassword: await hashPassword(password),
			key,
			permissionLevel: 1,
			username,
		})
		const user = results.at(-1)
		if (!user) {
			if (key)
				return issues.regkey(
					"Registration key is invalid or has expired"
				)
			throw new Error("Failed to create user")
		}

		try {
			await requestRender(f, "Avatar", toRawId(user.id), username)
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
		const hashedPassword = await hashPassword(password)
		let user: RecordId<"user"> | undefined
		try {
			const results = await db.query<RecordId<"user">[]>(
				initialAccountQuery,
				{
					bodyColours: config.DefaultBodyColors,
					hashedPassword,
					username,
				}
			)
			// The last result is COMMIT's, so the user is the one before it
			user = results.at(-2)
		} catch (err) {
			// Another request created the initial account first
			if (await accountRegistered())
				return issues("There's already an account registered")
			throw err
		}
		if (!user) throw new Error("Failed to create initial account")

		try {
			await requestRender(f, "Avatar", toRawId(user.id), username)
		} catch {}

		cookies.set(cookieName, await createSession(user), cookieOptions)

		redirect(302, "/home")
	}
)
