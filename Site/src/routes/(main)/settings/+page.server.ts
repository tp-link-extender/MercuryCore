import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { authorise, cookieName, invalidateAllSessions } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import { db, Record } from "$lib/server/surreal"
import passwordQuery from "./password.surql"
import updateProfileQuery from "./updateProfile.surql"

const profileSchema = type({
	description: "(string <= 1000) | undefined",
	theme: type.enumerated("0", ...config.Themes.map((_, i) => i.toString())),
})
const passwordSchema = type({
	cpassword: "string >= 1",
	npassword: "string >= 1",
	cnpassword: "string >= 1",
})
const sessionSchema = type({
	password: "string >= 1",
})
const stylingSchema = type({
	css: "(string <= 10000) | undefined",
})

export const load = async () => ({
	profileForm: await superValidate(arktype(profileSchema)),
	passwordForm: await superValidate(arktype(passwordSchema)),
	sessionForm: await superValidate(arktype(sessionSchema)),
	stylingForm: await superValidate(arktype(stylingSchema)),
	themes: config.Themes.map(t => t.Name),
})

export const actions: import("./$types").Actions = {}
actions.profile = async ({ locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(profileSchema))
	if (!form.valid) return formError(form)

	const { description, theme } = form.data

	await db.query(updateProfileQuery, {
		user: Record("user", user.id),
		description,
		theme: +(theme || 0),
	})

	return message(form, "Profile updated successfully!")
}
actions.password = async ({ locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(passwordSchema))
	if (!form.valid) return formError(form)

	const { cpassword, npassword, cnpassword } = form.data
	// Don't send the password back to the client
	form.data.cpassword = form.data.npassword = form.data.cnpassword = ""

	if (npassword !== cnpassword)
		return formError(form, ["cnpassword"], ["Passwords do not match"])
	if (npassword === cpassword)
		return formError(
			form,
			["npassword", "cnpassword"],
			["New password cannot be the same as the current password", ""]
		)

	const userR = Record("user", user.id)
	const [[{ hashedPassword }]] = await db.query<
		{ hashedPassword: string }[][]
	>(passwordQuery, { user: userR })
	if (!Bun.password.verifySync(cpassword, hashedPassword))
		return formError(form, ["cpassword"], ["Incorrect password"])

	await db.merge(userR, { hashedPassword: Bun.password.hashSync(npassword) })

	return message(form, "Password updated successfully!")
}
actions.sessions = async ({ cookies, locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(sessionSchema))
	if (!form.valid) return formError(form)

	const { password } = form.data
	form.data.password = "" // will only send back in the event of failure I think

	const [[{ hashedPassword }]] = await db.query<
		{ hashedPassword: string }[][]
	>(passwordQuery, { user: Record("user", user.id) })
	if (!Bun.password.verifySync(password, hashedPassword))
		return formError(form, ["password"], ["Incorrect password"])

	await invalidateAllSessions(user.id)
	cookies.delete(cookieName, { path: "/" })

	redirect(302, "/login")
}
actions.styling = async ({ locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(stylingSchema))
	if (!form.valid) return formError(form)

	const { css } = form.data
	if (css === "undefined") return message(form, "Styling already saved!")

	await db.merge(Record("user", user.id), { css })

	return message(form, "Styling updated successfully!")
}
