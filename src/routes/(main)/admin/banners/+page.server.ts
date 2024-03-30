import { authorise } from "$lib/server/lucia"
import { query, squery, surql, auditLog, Action } from "$lib/server/surreal"
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
			creator: BasicUser
			textLight: boolean
		}>(surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, status, username
				FROM $parent.creator)[0] AS creator
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

	await query(surql`UPDATE $id SET active = $active`, {
		id: `banner:${id}`,
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
			query(surql`CREATE banner CONTENT $data`, {
				data: {
					active: true,
					deleted: false,
					body: bannerText,
					bgColour: bannerColour,
					textLight: !!bannerTextLight,
					creator: `user:${user.id}`,
				},
			}),
			auditLog(
				Action.Administration,
				`Create banner "${bannerText}"`,
				user.id
			),
		])

		return message(form, "Banner created successfully!")
	},
	delete: async e => {
		const { user, form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")

		if (!id) return message(form, "Missing fields", { status: 400 })

		// const deletedBanner = await banner.merge(id, { deleted: true })
		const deletedBanner = await squery<{
			body: string
			creator: string
		}>(surql`UPDATE $id SET deleted = true`, { id: `banner:${id}` })

		await auditLog(
			Action.Administration,
			`Delete banner "${deletedBanner.body}"`,
			user.id
		)
	},
	updateBody: async e => {
		const { form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")
		const { bannerBody } = form.data

		if (!bannerBody || !id)
			return message(form, "Missing fields", { status: 400 })

		// await banner.merge(id, { body: bannerBody })
		await query(surql`UPDATE $id SET body = $bannerBody`, {
			id: `banner:${id}`,
			bannerBody,
		})
	},
	updateTextLight: async e => {
		const { form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")
		const { bannerTextLight } = form.data

		if (!id) return message(form, "Missing fields", { status: 400 })

		// await banner.merge(id, { textLight: !!bannerTextLight })
		await query(surql`UPDATE $id SET textLight = $textLight`, {
			id: `banner:${id}`,
			textLight: !!bannerTextLight,
		})
	},
	show: showHide("show"),
	hide: showHide("hide"),
}
