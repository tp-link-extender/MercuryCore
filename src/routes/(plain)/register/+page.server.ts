import { auth } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import formError from "$lib/server/formError"
import { redirect, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	username: z
		.string()
		.min(3)
		.max(21)
		.regex(/^[A-Za-z0-9_]+$/),
	email: z.string().email(),
	password: z.string().min(1).max(6969),
	cpassword: z.string().min(1).max(6969),
	regkey: z.string().min(1).max(6969),
})

export const load = async (
	event
	// removing parentheses breaks things
) => ({
	form: superValidate(event, schema),
})

export const actions = {
	default: async event => {
		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		let { username, email, password, cpassword, regkey } = form.data

		email = email.toLowerCase() || ""
		regkey = regkey.split("-")[1] || ""

		if (cpassword != password)
			return formError(
				form,
				["cpassword"],
				["The specified passwords do not match"]
			)

		try {
			if (
				(
					await prisma.authUser.findMany({
						where: {
							username: {
								equals: username,
								// Insensitive search cannot be used on findUnique for some reason
								mode: "insensitive",
							},
						},
					})
				)[0]
			)
				return formError(
					form,
					["username"],
					["This username is already in use"]
				)

			if (
				(
					await prisma.authUser.findMany({
						where: {
							email: {
								equals: email,
								mode: "insensitive",
							},
						},
					})
				)[0]
			)
				return formError(
					form,
					["email"],
					["This email is already being used"]
				)

			const regkeyCheck = await prisma.regkey.findUnique({
				where: {
					key: regkey,
				},
			})
			if (!regkeyCheck)
				return formError(
					form,
					["regkey"],
					["Registration key is invalid"]
				)
			if (regkeyCheck.usesLeft < 1)
				return formError(
					form,
					["regkey"],
					["This registration key has ran out of uses"]
				)

			const user = await auth.createUser({
				primaryKey: {
					providerId: "username",
					providerUserId: username.toLowerCase(),
					password,
				},
				attributes: {
					username,
					email,
					usedRegkey: {
						connect: {
							key: regkey,
						},
					},
					image: "https://tr.rbxcdn.com/54d17964492b5e0af66797942fcce26c/150/150/AvatarHeadshot/Png",
				},
			})

			const session = await auth.createSession(user.id)
			event.locals.setSession(session)

			await prisma.regkey.update({
				where: {
					key: regkey,
				},
				data: {
					usesLeft: {
						decrement: 1,
					},
				},
			})
		} catch (e) {
			const error = e as Error
			if (error.message == "AUTH_DUPLICATE_PROVIDER_ID")
				return formError(
					form,
					["username"],
					["This username is already in use"]
				)

			console.error("Registration error:", error)
			return fail(500) // idk
		}

		throw redirect(302, "/home")
	},
}
