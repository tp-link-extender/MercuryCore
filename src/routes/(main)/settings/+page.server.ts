import { authorise } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"
import { auth } from "$lib/server/lucia"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schemas = {
	profile: z.object({
		theme: z.enum(["standard", "darken", "storm", "solar"]),
		bio: z.string().max(1000).optional(),
	}),
	password: z.object({
		cpassword: z.string().min(1),
		npassword: z.string().min(1),
		cnpassword: z.string().min(1),
	}),
}

export const load = async () => ({
	profileForm: await superValidate(schemas.profile),
	passwordForm: await superValidate(schemas.password),
})

export const actions = {
	profile: async ({ request, locals }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schemas.profile)
		if (!form.valid) return formError(form)

		const { bio, theme } = form.data

		await query(
			surql`
				LET $og = SELECT
					(SELECT text, updated FROM $parent.bio
					ORDER BY updated DESC)[0] AS bio
				FROM $user;

				UPDATE $user SET theme = $theme;

				IF $og.bio.text != $bio {
					UPDATE $user SET bio += {
						text: $bio,
						updated: time::now(),
					}
				}`,
			{
				user: `user:${user.id}`,
				bio,
				theme,
			}
		)

		return message(form, "Profile updated successfully!")
	},
	password: async ({ request, locals }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schemas.password)
		if (!form.valid) return formError(form)

		const { cpassword, npassword, cnpassword } = form.data

		if (npassword != cnpassword)
			return formError(form, ["cnpassword"], ["Passwords do not match"])

		try {
			await auth.useKey(
				"username",
				user.username.toLowerCase(),
				cpassword
			)
		} catch {
			return formError(
				form,
				["cpassword"],
				["Incorrect username or password"]
			)
		}

		await auth.updateKeyPassword(
			"username",
			user.username.toLowerCase(),
			npassword
		)

		// Don't send the password back to the client
		form.data.cpassword = ""
		form.data.npassword = ""
		form.data.cnpassword = ""

		return message(form, "Password updated successfully!")
	},
}
