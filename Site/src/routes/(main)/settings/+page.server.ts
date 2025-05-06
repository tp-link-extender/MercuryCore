import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import { Record, db } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import passwordQuery from "./password.surql"
import updateProfileQuery from "./updateProfile.surql"

const profileSchema = z.object({
	description: z.string().max(1000).optional(),
	theme: z.enum(["0", ...config.Themes.map((_, i) => i.toString())]),
})
const passwordSchema = z.object({
	cpassword: z.string().min(1),
	npassword: z.string().min(1),
	cnpassword: z.string().min(1),
})
const stylingSchema = z.object({
	css: z.string().max(10000).optional(),
})

export const load = async () => ({
	profileForm: await superValidate(zod(profileSchema)),
	passwordForm: await superValidate(zod(passwordSchema)),
	stylingForm: await superValidate(zod(stylingSchema)),
	themes: config.Themes.map(t => t.Name),
})

export const actions: import("./$types").Actions = {}
actions.profile = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(profileSchema))
	if (!form.valid) return formError(form)

	const { description, theme } = form.data

	await db.query(updateProfileQuery, {
		user: Record("user", user.id),
		description,
		theme: +(theme || 0),
	})

	return message(form, "Profile updated successfully!")
}
actions.password = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(passwordSchema))
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
actions.styling = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(stylingSchema))
	if (!form.valid) return formError(form)

	const { css } = form.data
	if (css === "undefined") return message(form, "Styling already saved!")

	await db.merge(Record("user", user.id), { css })

	return message(form, "Styling updated successfully!")
}
