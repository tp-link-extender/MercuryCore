import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types.d"
import activeCountQuery from "./activeCount.surql"
import bannersQuery from "./banners.surql"

const schema = type({
	bannerText: "(string <= 100) | undefined",
	bannerColour: "string | undefined",
	bannerTextLight: "boolean | undefined",
	bannerBody: "string | undefined",
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

	const [banners] = await db.query<Banner[][]>(bannersQuery)
	return { banners, form: await superValidate(arktype(schema)) }
}

async function bannerActiveCount() {
	const [banners] = await db.query<number[]>(activeCountQuery)
	return banners
}

async function getData({ locals, request }: RequestEvent) {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, arktype(schema))

	return { user, form, error: !form.valid && formError(form) }
}

const showHide = (action: string) => async (e: RequestEvent) => {
	const { form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	if (!id) return message(form, "Missing fields", { status: 400 })

	const active = action === "show"
	if (active && (await bannerActiveCount()) >= 3)
		return message(form, "Too many active banners", { status: 400 })

	await db.merge(Record("banner", id), { active })
}

export const actions: import("./$types").Actions = {}
actions.create = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const { bannerText, bannerColour, bannerTextLight } = form.data
	if (!bannerText || !bannerColour)
		return message(form, "Missing fields", { status: 400 })
	if ((await bannerActiveCount()) >= 3)
		return message(form, "Too many active banners", { status: 400 })

	const limit = ratelimit(form, "createBanner", e.getClientAddress, 30)
	if (limit) return limit

	await db.insert("banner", {
		active: true,
		deleted: false,
		body: bannerText,
		bgColour: bannerColour,
		textLight: !!bannerTextLight,
		creator: Record("user", user.id),
	})

	return message(form, "Banner created successfully!")
}
actions.delete = async e => {
	const { form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	if (!id) return message(form, "Missing fields", { status: 400 })

	await db.merge(Record("banner", id), { deleted: true })
}
actions.updateBody = async e => {
	const { form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	const { bannerBody } = form.data
	if (!bannerBody || !id)
		return message(form, "Missing fields", { status: 400 })

	await db.merge(Record("banner", id), { body: bannerBody })
}
actions.updateTextLight = async e => {
	const { form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	const { bannerTextLight } = form.data
	if (!id) return message(form, "Missing fields", { status: 400 })

	await db.merge(Record("banner", id), { textLight: !!bannerTextLight })
}
actions.show = showHide("show")
actions.hide = showHide("hide")
