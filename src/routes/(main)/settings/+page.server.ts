import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { auth } from "$lib/server/lucia"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals)

	const getUser = await prisma.authUser.findUnique({
		where: {
			id: user.id,
		},
		include: {
			bio: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
		},
	})

	return {
		bio: getUser?.bio, // because can't get nested properties from lucia.ts I think
		theme: getUser?.theme,
		form: superValidate(
			z.object({
				theme: z.enum(["standard", "darken", "storm", "solar"]),
				bio: z.string().max(1000),
				cpassword: z.string().min(1),
				npassword: z.string().min(1),
				cnpassword: z.string().min(1),
			}),
		),
	}
}

export const actions = {
	default: async ({ request, locals, url }) => {
		const { user } = await authorise(locals)

		const action = url.searchParams.get("a")

		console.log(action)

		let form
		switch (action) {
			case "profile": {
				form = await superValidate(
					request,
					z.object({
						theme: z.enum(["standard", "darken", "storm", "solar"]),
						bio: z.string().max(1000),
					}),
				)
				if (!form.valid) return formError(form)
				const { bio, theme } = form.data

				await prisma.authUser.update({
					where: {
						number: user.number,
					},
					data: {
						bio: {
							create: {
								text: bio,
							},
						},
						theme,
					},
				})

				return message(form, "Profile updated successfully!")
			}

			case "password": {
				form = await superValidate(
					request,
					z.object({
						cpassword: z.string().min(1),
						npassword: z.string().min(1),
						cnpassword: z.string().min(1),
					}),
				)
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

				form.data.cpassword = ""
				form.data.npassword = ""
				form.data.cnpassword = ""
				return message(form, "Password updated successfully!")
			}
		}
	},
}
