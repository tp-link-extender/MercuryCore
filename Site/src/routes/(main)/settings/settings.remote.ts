import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import {
	authorise,
	cookieName,
	cookieOptions,
	createSession,
	invalidateAllSessions,
} from "$lib/server/auth"
import config from "$lib/server/config"
import { hashPassword, verifyPassword } from "$lib/server/password"
import { ratelimitRemoteKey } from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import type { ClientForm } from "$lib/validate"
import changePasswordQuery from "./changePassword.surql"
import passwordQuery from "./password.surql"
import updateProfileQuery from "./updateProfile.surql"

const themeNames = config.Themes.map(t => t.Name)

const profileSchema = type({
	description: "(string <= 1000) | undefined",
	theme: type.enumerated(...themeNames).pipe.try(t => {
		const index = themeNames.indexOf(t)
		if (index === -1) throw new Error("must be a valid theme")
		return index
	}),
})
// The current password may predate the 16-character minimum, so only new passwords are held to it
const passwordSchema = type({
	cnpassword: "16 <= string <= 6969",
	cpassword: "1 <= string <= 6969",
	npassword: "16 <= string <= 6969",
})
const sessionSchema = type({
	password: "string >= 1",
})
const stylingSchema = type({
	css: "(string <= 10000) | undefined",
})

export const profileForm: ClientForm<typeof profileSchema.inferIn> = form(
	profileSchema,
	async ({ description, theme }) => {
		const { locals } = getRequestEvent()
		const { user } = await authorise(locals)

		await db.query(updateProfileQuery, {
			description,
			theme,
			user: Record("user", user.id),
		})

		return { success: "Profile updated successfully!" }
	}
)

export const passwordForm: ClientForm<typeof passwordSchema.infer> = form(
	passwordSchema,
	async ({ cpassword, npassword, cnpassword }, issues) => {
		const { cookies, locals } = getRequestEvent()
		const { user } = await authorise(locals)

		if (npassword !== cnpassword)
			return issues.cnpassword("Passwords do not match")
		if (npassword === cpassword)
			return issues.npassword(
				"New password cannot be the same as the current password"
			)

		// Counted per account, shared with the sessions form, so a stolen session can't be used to guess the password
		const limit = ratelimitRemoteKey(
			issues,
			"currentPassword",
			user.id,
			300,
			10
		)
		if (limit) return limit

		const userR = Record("user", user.id)
		const [[{ hashedPassword }]] = await db.query<
			{ hashedPassword: string }[][]
		>(passwordQuery, { user: userR })
		if (!(await verifyPassword(cpassword, hashedPassword)))
			return issues.cpassword("Incorrect password")

		await db.query(changePasswordQuery, {
			hashedPassword: await hashPassword(npassword),
			user: userR,
		})
		// All sessions, including this one, were just ended
		cookies.set(cookieName, await createSession(userR), cookieOptions)

		return { success: "Password updated successfully!" }
	}
)

export const sessionForm: ClientForm<typeof sessionSchema.infer> = form(
	sessionSchema,
	async ({ password }, issues) => {
		const { cookies, locals } = getRequestEvent()
		const { user } = await authorise(locals)

		const limit = ratelimitRemoteKey(
			issues,
			"currentPassword",
			user.id,
			300,
			10
		)
		if (limit) return limit

		const [[{ hashedPassword }]] = await db.query<
			{ hashedPassword: string }[][]
		>(passwordQuery, { user: Record("user", user.id) })
		if (!(await verifyPassword(password, hashedPassword)))
			return issues.password("Incorrect password")

		await invalidateAllSessions(user.id)
		cookies.delete(cookieName, { path: "/" })

		redirect(302, "/login")
	}
)

export const stylingForm: ClientForm<typeof stylingSchema.infer> = form(
	stylingSchema,
	async ({ css }) => {
		const { locals } = getRequestEvent()
		const { user } = await authorise(locals)

		if (css === "undefined") return { success: "Styling already saved!" }

		await db.update(Record("user", user.id)).merge({ css })

		return { success: "Styling updated successfully!" }
	}
)
