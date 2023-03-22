import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { auth } from "$lib/server/lucia"
import formData from "$lib/server/formData"
import { fail } from "@sveltejs/kit"

export const load = async ({ locals }) => {
	const { user } = await authorise(locals.validateUser)

	const getUser = await prisma.user.findUnique({
		where: {
			id: user.id,
		},
		select: {
			bio: {
				orderBy: {
					updated: "desc",
				},
				take: 1,
			},
		},
	})

	
	return {
		bio: getUser?.bio, // because can't get nested properties from lucia.ts I think
	}
}

export const actions = {
	profile: async ({ request, locals }) => {
		const { user } = await authorise(locals.validateUser)
		const data = await formData(request)

		let same
		for (let i in data)
			if (data[i] != (user as any)[i]) {
				same = false
				break
			}
		if (same) return fail(400)

		if (!["standard", "darken", "storm", "solar"].includes(data.theme))
			return fail(400, { area: "theme", msg: "Invalid theme" })

		await prisma.user.update({
			where: {
				number: user.number,
			},
			data: {
				bio: {
					create: {
						text: data.bio,
					},
				},
				theme: data.theme,
			},
		})

		return {
			profilesuccess: true,
		}
	},

	password: async ({ request, locals }) => {
		const { user } = await authorise(locals.validateUser)
		const data = await formData(request)

		if (data.npassword != data.cnpassword)
			return fail(400, {
				area: "cnpassword",
				msg: "Passwords do not match",
			})

		try {
			await auth.useKey(
				"username",
				user.username.toLowerCase(),
				data.cpassword
			)
		} catch {
			return fail(400, {
				area: "cpassword",
				msg: "Incorrect username or password",
			})
		}

		await auth.updateKeyPassword(
			"username",
			user.username.toLowerCase(),
			data.npassword
		)

		return {
			passwordsuccess: true,
		}
	},
}
