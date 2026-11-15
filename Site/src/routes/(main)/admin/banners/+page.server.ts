import { type } from "arktype"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { Banner, db, Record } from "$lib/server/surreal"
import {
	arktype,
	errMessage,
	message,
	superValidate,
} from "$lib/server/validate"
import type { Actions, PageServerLoadEvent } from "./$types"
import type { RequestEvent } from "./$types.d"
import activeCountQuery from "./activeCount.surql"
import bannersQuery from "./banners.surql"
import updateQuery from "./update.surql"

const schema = type({
	bannerBody: "string | undefined",
	bannerColour: "string | undefined",
	bannerText: "(string <= 100) | undefined",
	bannerTextLight: "boolean | undefined",
})

interface BannerType {
	active: boolean
	bgColour: string
	body: string
	creator: BasicUser
	// bruce, it's been five years
	id: string
	textLight: boolean
}

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const [banners] = await db.query<BannerType[][]>(bannersQuery)
	return { banners, form: await superValidate(null, arktype(schema)) }
}

async function bannerActiveCount() {
	const [banners] = await db.query<number[]>(activeCountQuery)
	return banners
}

async function getData({ locals, request }: RequestEvent) {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, arktype(schema))

	return { error: !form.valid && formError(form), form, user }
}

async function updateBanner(
	user: { id: string },
	id: string,
	action: string,
	changes: { [_: string]: unknown },
	detail = ""
): Promise<boolean> {
	const results = await db.query<[null, null, boolean]>(updateQuery, {
		action,
		banner: Record("banner", id),
		changes,
		detail,
		user: Record("user", user.id),
	})
	// The last statement returns whether the banner was found
	return results[2]
}

const showHide = (action: string) => async (e: RequestEvent) => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	if (!id) return errMessage(form, "Missing fields")

	const active = action === "show"
	if (active && (await bannerActiveCount()) >= 3)
		return errMessage(form, "Too many active banners")

	const name = active ? "Show" : "Hide"
	if (!(await updateBanner(user, id, name, { active })))
		return errMessage(form, "Banner not found")
}

export const actions: Actions = {}
actions.create = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const { bannerText, bannerColour, bannerTextLight } = form.data
	if (!bannerText || !bannerColour) return errMessage(form, "Missing fields")
	if ((await bannerActiveCount()) >= 3)
		return errMessage(form, "Too many active banners")

	const limit = ratelimit(form, "createBanner", e.getClientAddress, 30)
	if (limit) return limit

	await db.insert(Banner, {
		bgColour: bannerColour,
		body: bannerText,
		creator: Record("user", user.id),
		deleted: false,
		textLight: Boolean(bannerTextLight),
	})

	return message(form, "Banner created successfully!")
}
actions.delete = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	if (!id) return errMessage(form, "Missing fields")

	if (!(await updateBanner(user, id, "Delete", { deleted: true })))
		return errMessage(form, "Banner not found")
}
actions.updateBody = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	const { bannerBody } = form.data
	if (!bannerBody || !id) return errMessage(form, "Missing fields")

	const changes = { body: bannerBody }
	const detail = ` text to "${bannerBody}"`
	if (!(await updateBanner(user, id, "Edit", changes, detail)))
		return errMessage(form, "Banner not found")
}
actions.updateTextLight = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const id = e.url.searchParams.get("id")
	const { bannerTextLight } = form.data
	if (!id) return errMessage(form, "Missing fields")

	const textLight = Boolean(bannerTextLight)
	const detail = ` text colour to ${textLight ? "light" : "dark"}`
	if (!(await updateBanner(user, id, "Edit", { textLight }, detail)))
		return errMessage(form, "Banner not found")
}
actions.show = showHide("show")
actions.hide = showHide("hide")
