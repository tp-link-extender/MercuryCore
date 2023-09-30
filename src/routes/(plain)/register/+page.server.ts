import { auth } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import surreal from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { redirect, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schemaInitial = z.object({
		username: z
			.string()
			.min(3)
			.max(21)
			.regex(/^[A-Za-z0-9_]+$/),
		password: z.string().min(1).max(6969),
		cpassword: z.string().min(1).max(6969),
	}),
	schema = z.object({
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

export const load = async () => ({
	form: superValidate(schema),
	users: (await prisma.authUser.count()) > 0,
})

export const actions = {
	register: async ({ request, locals }) => {
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		let { username, email, password, cpassword, regkey } = form.data

		email = email.toLowerCase() || ""
		regkey = regkey.split("-")[1] || ""

		if (cpassword != password)
			return formError(
				form,
				["password", "cpassword"],
				[" ", "The specified passwords do not match"],
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
					["This username is already in use"],
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
					["This email is already being used"],
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
					["Registration key is invalid"],
				)
			if (regkeyCheck.usesLeft < 1)
				return formError(
					form,
					["regkey"],
					["This registration key has ran out of uses"],
				)

			const user = await auth.createUser({
					key: {
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
					} as any,
				}),
				session = await auth.createSession({
					userId: user.id,
					attributes: {},
				})

			locals.auth.setSession(session)

			const getUser = await prisma.authUser.findUnique({
				where: {
					id: user.id,
				},
			})

			await surreal.create(`user:${getUser?.id}`, {
				username,
				number: getUser?.number,
				email,
				permissionLevel: 1,
				bio: [],
			})

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
					["This username is already in use"],
				)

			console.error("Registration error:", error)
			return fail(500) // idk
		}

		throw redirect(302, "/home")
	},
	initialAccount: async ({ request, locals }) => {
		// This is the initial account creation, which is
		// only allowed if there are no existing users.

		const form = await superValidate(request, schemaInitial)
		if (!form.valid) return formError(form)

		let { username, password, cpassword } = form.data

		if (cpassword != password)
			return formError(
				form,
				["password", "cpassword"],
				[" ", "The specified passwords do not match"],
			)

		try {
			if ((await prisma.authUser.count()) > 0)
				return formError(
					form,
					["username"],
					["There's already an account registered"],
				)

			const user = await auth.createUser({
					key: {
						providerId: "username",
						providerUserId: username.toLowerCase(),
						password,
					},
					attributes: {
						username,
						email: "",
						permissionLevel: 5,
						usedRegkey: {
							create: {
								key: "",
								usesLeft: 0,
							},
						},
					} as any,
				}),
				session = await auth.createSession({
					userId: user.id,
					attributes: {},
				})

			locals.auth.setSession(session)

			const getUser = await prisma.authUser.findUnique({
				where: {
					id: user.id,
				},
			})

			await surreal.create(`user:${getUser?.id}`, {
				username,
				number: getUser?.number,
				email: "",
				permissionLevel: 5,
				bio: [],
			})
		} catch (e) {
			const error = e as Error
			if (error.message == "AUTH_DUPLICATE_PROVIDER_ID")
				return formError(
					form,
					["username"],
					["This username is already in use"],
				)

			console.error("Registration error:", error)
			return fail(500) // idk
		}

		throw redirect(302, "/home")
	},
}
