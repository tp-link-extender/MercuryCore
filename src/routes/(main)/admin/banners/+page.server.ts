import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import surreal, { query, squery } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	bannerText: z.string().max(100).optional(),
	bannerColour: z.string().optional(),
	bannerTextLight: z.boolean().optional(),
	bannerBody: z.string().optional(),
})

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		banners: query<{
			id: string
			active: boolean
			bgColour: string
			body: string
			creator: {
				number: number
				username: string
			}
			textLight: boolean
		}>(surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT
					creator.number,
					creator.username
				FROM $parent)[0].creator AS creator
			OMIT deleted
			FROM banner WHERE deleted = false
		`),
	}
}

export const actions = {
	default: async ({ url, request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const { user } = await authorise(locals),
			form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { bannerText, bannerColour, bannerBody, bannerTextLight } =
				form.data,
			id = url.searchParams.get("id"),
			action = url.searchParams.get("a"),
			bannerActiveCount = await squery<number>(surql`
				count(
					SELECT * FROM banner
					WHERE active = true AND deleted = false
				)
			`)

		console.log(bannerActiveCount)

		switch (action) {
			case "create": {
				const limit = ratelimit(
					form,
					"createBanner",
					getClientAddress,
					30,
				)
				if (limit) return limit

				if (!bannerText || !bannerColour)
					return message(form, "Missing fields", {
						status: 400,
					})

				if (bannerActiveCount >= 3)
					return message(form, "Too many active banners", {
						status: 400,
					})

				await Promise.all([
					surreal.create("banner", {
						active: true,
						deleted: false,
						body: bannerText,
						bgColour: bannerColour,
						textLight: !!bannerTextLight,
						creator: `user:${user.id}`,
					}),

					query(
						surql`
							CREATE auditLog CONTENT {
								action: "Administration",
								note: $note,
								user: $user,
								time: time::now()
							}`,
						{
							note: `Create banner "${bannerText}"`,
							user: `user:${user.id}`,
						},
					),
				])

				return message(form, "Banner created successfully!")
			}
			case "show":
			case "hide":
				if (!id)
					return message(form, "Missing fields", {
						status: 400,
					})

				if (action == "show" && bannerActiveCount >= 3)
					return message(form, "Too many active banners", {
						status: 400,
					})

				await surreal.merge(`banner:${id}`, {
					active: action == "show",
				})

				return
			case "delete":
				if (!id)
					return message(form, "Missing fields", {
						status: 400,
					})

				const deletedBanner = (
					await surreal.merge(`banner:${id}`, {
						deleted: true,
					})
				)[0] as {
					active: boolean
					bgColour: string
					body: string
					creator: string
					deleted: boolean
					id: string
					textLight: boolean
				}

				await query(
					surql`
						CREATE auditLog CONTENT {
							action: "Administration",
							note: $note,
							user: $user,
							time: time::now()
						}`,
					{
						note: `Delete banner "${deletedBanner.body}"`,
						user: `user:${user.id}`,
					},
				)

				return
			case "updateBody":
				if (!bannerBody || !id)
					return message(form, "Missing fields", {
						status: 400,
					})

				await surreal.merge(`banner:${id}`, {
					body: bannerBody,
				})

				return
			case "updateTextLight":
				if (bannerTextLight == null || !id)
					return message(form, "Missing fields", {
						status: 400,
					})

				await surreal.merge(`banner:${id}`, {
					textLight: bannerTextLight,
				})

				return
		}
	},
}
