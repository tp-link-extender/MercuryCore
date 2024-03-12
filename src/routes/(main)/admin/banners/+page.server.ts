import { authorise } from "$lib/server/lucia"
import surreal, { query, squery, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import type { RequestEvent } from "./$types"

const schema = z.object({
	bannerText: z.string().max(100).optional(),
	bannerColour: z.string().optional(),
	bannerTextLight: z.boolean().optional(),
	bannerBody: z.string().optional(),
})

export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		form: await superValidate(zod(schema)),
		banners: await query<{
			id: string
			active: boolean
			bgColour: string
			body: string
			creator: {
				number: number
				status: "Playing" | "Online" | "Offline"
				username: string
			}
			textLight: boolean
		}>(surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT
					creator.number,
					creator.status,
					creator.username
				FROM $parent)[0].creator AS creator
			OMIT deleted
			FROM banner WHERE deleted = false`),
	}
}

const bannerActiveCount = () =>
	squery<number>(surql`
		count(
			SELECT * FROM banner
			WHERE active = true AND deleted = false
		)`)

async function getData({ request, locals }: RequestEvent) {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, zod(schema))

	return {
		user,
		form,
		error: !form.valid && formError(form),
	}
}

const showHide = (action: string) => async (e: RequestEvent) => {
	const { form, error } = await getData(e)
	if (error) return error
	const id = e.url.searchParams.get("id")

	if (!id) return message(form, "Missing fields", { status: 400 })
	if (action === "show" && (await bannerActiveCount()) >= 3)
		return message(form, "Too many active banners", { status: 400 })

	await surreal.merge(`banner:${id}`, {
		active: action === "show",
	})
}
export const actions = {
	create: async e => {
		const { user, form, error } = await getData(e)
		if (error) return error
		const { getClientAddress } = e

		const limit = ratelimit(form, "createBanner", getClientAddress, 30)
		if (limit) return limit
		const { bannerText, bannerColour, bannerTextLight } = form.data

		if (!bannerText || !bannerColour)
			return message(form, "Missing fields", { status: 400 })

		if ((await bannerActiveCount()) >= 3)
			return message(form, "Too many active banners", { status: 400 })

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
				}
			),
		])

		return message(form, "Banner created successfully!")
	},
	delete: async e => {
		const { user, form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")

		if (!id) return message(form, "Missing fields", { status: 400 })

		const deletedBanner = (
			await surreal.merge<{
				body: string
				deleted: boolean
			}>(`banner:${id}`, {
				deleted: true,
			})
		)[0]

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
			}
		)
	},
	updateBody: async e => {
		const { form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")
		const { bannerBody } = form.data

		if (!bannerBody || !id)
			return message(form, "Missing fields", { status: 400 })

		await surreal.merge(`banner:${id}`, { body: bannerBody })
	},
	updateTextLight: async e => {
		const { form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")
		const { bannerTextLight } = form.data

		if (!id) return message(form, "Missing fields", { status: 400 })

		await surreal.merge(`banner:${id}`, { textLight: !!bannerTextLight })
	},
	show: showHide("show"),
	hide: showHide("hide"),
}
