import { auth, authoriseAdmin, authoriseUser } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"

// Make sure a user is an administrator before loading the page.
export async function load ({ locals }) {
	await authoriseAdmin(locals)
	
	return {
		banners: prisma.announcements.findMany({
			select: {
				body: true,
				bgColour: true,
				active: true,
				textLight: true,
				id: true,
				user: {
					select: {
						username: true,
						number: true,
					}
				}
			}
		})
	}
}

export const actions = {
	createBanner: async ({ request, locals, getClientAddress }) => {
		await authoriseAdmin(locals)

		const limit = ratelimit("createBanner", getClientAddress, 30)
		if (limit) return limit

		const user = (await authoriseUser(locals.validateUser)).user
		const data = await request.formData()

		const bannerText = data.get("bannerText") as string
		const bannerColour = data.get("bannerColour") as string
		const bannerTextLight = !!data.get("bannerTextLight")

		if (!bannerColour || !bannerText) return fail(400, { error: true, msg: "Missing fields" })
		if (bannerText.length > 100 || bannerText.length < 3) return fail(400, { error: true, msg: "Banner text too long" })

		const bannerActiveCount = await prisma.announcements.findMany({
			where: {active: true },
		})

		if(bannerActiveCount && bannerActiveCount.length > 2) return fail(400, { error: true, msg: "Too many active banners" })

		await prisma.announcements.create({
			data: {
				body: bannerText,
				bgColour: bannerColour,
				textLight: bannerTextLight,
				user: {
					connect: {
						id: user.userId
					}
				}
			},
		})

		return {
			error: false,
			bannersuccess: true,
			msg: "Banner created successfully!",
		}
	},

	bannerVisible: async ({ request, locals, getClientAddress }) => {
		await authoriseAdmin(locals)

		const limit = ratelimit("createBanner", getClientAddress, 30)
		if (limit) return limit

		const user = (await authoriseUser(locals.validateUser)).user
		
		const data = await request.formData()

		const bannerText = data.get("bannerText") as string
		const bannerColour = data.get("bannerColour") as string
		const bannerTextLight = !!data.get("bannerTextLight")

		if (!bannerColour || !bannerText) return fail(400, { error: true, msg: "Missing fields" })
		if (bannerText.length > 100 || bannerText.length < 3) return fail(400, { error: true, msg: "Banner text too long" })

		const bannerActiveCount = await prisma.announcements.findMany({
			where: {active: true },
		})

		if(bannerActiveCount && bannerActiveCount.length > 2) return fail(400, { error: true, msg: "Too many active banners" })

		await prisma.announcements.create({
			data: {
				body: bannerText,
				bgColour: bannerColour,
				textLight: bannerTextLight,
				user: {
					connect: {
						id: user.userId
					}
				}
			},
		})

		return {
			error: false,
			bannersuccess: true,
			msg: "Banner created successfully!",
		}
	},
}