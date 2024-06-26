import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { RecordId, auditLog, equery, surql } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types.d.ts"

const schema = z.object({
	bannerText: z.string().max(100).optional(),
	bannerColour: z.string().optional(),
	bannerTextLight: z.boolean().optional(),
	bannerBody: z.string().optional(),
})

type Banner = {
	// bruce, it's been five years
	id: string
	active: boolean
	bgColour: string
	body: string
	creator: BasicUser
	textLight: boolean
}

export async function load({ locals }) {
	await authorise(locals, 5)

	const [banners] = await equery<Banner[][]>(surql`
		SELECT
			*,
			meta::id(id) AS id,
			(SELECT number, status, username
			FROM $parent.creator)[0] AS creator
		OMIT deleted
		FROM banner WHERE deleted = false`)

	return {
		form: await superValidate(zod(schema)),
		banners,
	}
}

async function bannerActiveCount() {
	const [banners] = await equery<number[]>(surql`
		count(
			SELECT 1 FROM banner
			WHERE active = true AND deleted = false
		)`)

	return banners
}

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

	await equery(surql`UPDATE $id SET active = ${action === "show"}`, {
		id: new RecordId("banner", id),
	})
}

export const actions: import("./$types").Actions = {}
actions.create = async e => {
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
		equery(surql`CREATE banner CONTENT $data`, {
			data: {
				active: true,
				deleted: false,
				body: bannerText,
				bgColour: bannerColour,
				textLight: !!bannerTextLight,
				creator: new RecordId("user", user.id),
			},
		}),
		auditLog("Administration", `Create banner "${bannerText}"`, user.id),
	])

	return message(form, "Banner created successfully!")
}
actions.delete = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error
	const id = e.url.searchParams.get("id")

	if (!id) return message(form, "Missing fields", { status: 400 })

	const [[deletedBanner]] = await equery<
		{
			body: string
			creator: string
		}[][]
	>(surql`UPDATE ${new RecordId("banner", id)} SET deleted = true`)

	await auditLog(
		"Administration",
		`Delete banner "${deletedBanner.body}"`,
		user.id
	)
}
actions.updateBody = async e => {
	const { form, error } = await getData(e)
	if (error) return error
	const id = e.url.searchParams.get("id")
	const { bannerBody } = form.data

	if (!bannerBody || !id)
		return message(form, "Missing fields", { status: 400 })

	// await banner.merge(id, { body: bannerBody })
	await equery(surql`UPDATE $id SET body = ${bannerBody}`, {
		id: new RecordId("banner", id),
	})
}
actions.updateTextLight = async e => {
	const { form, error } = await getData(e)
	if (error) return error
	const id = e.url.searchParams.get("id")
	const { bannerTextLight } = form.data

	if (!id) return message(form, "Missing fields", { status: 400 })

	// await banner.merge(id, { textLight: !!bannerTextLight })
	await equery(surql`UPDATE $id SET textLight = ${!!bannerTextLight}`, {
		id: new RecordId("banner", id),
	})
}
actions.show = showHide("show")
actions.hide = showHide("hide")
