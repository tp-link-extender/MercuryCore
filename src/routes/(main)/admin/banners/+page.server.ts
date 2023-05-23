import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	action: z.enum(["create", "show", "hide", "delete", "updateBody"]),
	id: z.string().optional(),
	bannerText: z.string().min(3).max(100).optional(),
	bannerColour: z.string().optional(),
	bannerTextLight: z.boolean().optional(),
	bannerBody: z.string().optional(),
})

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		banners: prisma.announcements.findMany({
			include: {
				user: true,
			},
			orderBy: {
				id: "asc",
			},
		}),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { action, id, bannerText, bannerColour, bannerBody } = form.data

		const bannerActiveCount = await prisma.announcements.findMany({
			where: { active: true },
		})

		switch (action) {
			case "create": {
				const limit = ratelimit(
					form,
					"createBanner",
					getClientAddress,
					30
				)
				if (limit) return limit

				if (!bannerText || !bannerColour)
					return message(form, "Missing fields", {
						status: 400,
					})

				const bannerTextLight = !!form.data.bannerTextLight

				if (bannerActiveCount && bannerActiveCount.length > 2)
					return message(form, "Too many active banners", {
						status: 400,
					})

				await prisma.announcements.create({
					data: {
						body: bannerText,
						bgColour: bannerColour,
						textLight: bannerTextLight,
						user: {
							connect: {
								id: user.id,
							},
						},
					},
				})

				return message(form, "Banner created successfully!")
			}
			case "show":
			case "hide":
				if (!id)
					return message(form, "Missing fields", {
						status: 400,
					})

				await prisma.announcements.update({
					where: {
						id,
					},
					data: {
						active: action == "show",
					},
				})

				return
			case "delete":
				if (!id)
					return message(form, "Missing fields", {
						status: 400,
					})

				await prisma.announcements.delete({
					where: {
						id,
					},
				})
				return
			case "updateBody":
				if (!bannerBody || !id)
					return message(form, "Missing fields", {
						status: 400,
					})

				await prisma.announcements.update({
					where: {
						id,
					},
					data: {
						body: bannerBody,
					},
				})
				return
		}
	},
}
