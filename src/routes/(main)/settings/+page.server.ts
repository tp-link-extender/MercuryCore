import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { multiSquery, squery } from "$lib/server/surreal"
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

export const load = () => ({
	profileForm: superValidate(schemas.profile),
	passwordForm: superValidate(schemas.password),
})

export const actions = {
	default: async ({ request, locals, url }) => {
		const { user } = await authorise(locals),
			action = url.searchParams.get("a")

		console.log(action)

		switch (action) {
			case "profile": {
				const form = await superValidate(request, schemas.profile)
				if (!form.valid) return formError(form)

				const { bio, theme } = form.data

				await squery(
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
					},
				)

				return message(form, "Profile updated successfully!")
			}

			case "password": {
				const form = await superValidate(request, schemas.password)
				if (!form.valid) return formError(form)

				const { cpassword, npassword, cnpassword } = form.data

				if (npassword != cnpassword)
					return formError(
						form,
						["cnpassword"],
						["Passwords do not match"],
					)

				try {
					await auth.useKey(
						"username",
						user.username.toLowerCase(),
						cpassword,
					)
				} catch {
					return formError(
						form,
						["cpassword"],
						["Incorrect username or password"],
					)
				}

				await auth.updateKeyPassword(
					"username",
					user.username.toLowerCase(),
					npassword,
				)

				// Don't send the password back to the client
				form.data.cpassword = ""
				form.data.npassword = ""
				form.data.cnpassword = ""

				return message(form, "Password updated successfully!")
			}
		}
	},
}
