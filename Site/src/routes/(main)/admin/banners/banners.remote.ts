import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { Banner, db, Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import activeCountQuery from "./activeCount.surql"
import updateQuery from "./update.surql"

const createSchema = type({
	bannerColour: "string",
	bannerText: "string <= 100",
	"bannerTextLight?": "boolean",
})

const deleteSchema = type({
	id: "string",
})

const visibilitySchema = type({
	action: type.enumerated("show", "hide"),
	id: "string",
})

const bodySchema = type({
	bannerBody: "string <= 100",
	id: "string",
})

const textLightSchema = type({
	"bannerTextLight?": "boolean",
	id: "string",
})

async function bannerActiveCount() {
	const [banners] = await dbQuery<number[]>(activeCountQuery)
	return banners
}

async function updateBanner(
	user: { id: string },
	id: string,
	action: string,
	changes: { [_: string]: unknown },
	detail = ""
): Promise<boolean> {
	const results = await dbQuery<[null, null, boolean]>(updateQuery, {
		action,
		banner: Record("banner", id),
		changes,
		detail,
		user: Record("user", user.id),
	})
	// The last statement returns whether the banner was found
	return results[2]
}

export const formData: ClientForm<typeof createSchema.infer> = form(
	createSchema,
	async ({ bannerText, bannerColour, bannerTextLight }, issues) => {
		const { locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals, 5)

		if (!bannerText || !bannerColour) return issues("Missing fields")
		if ((await bannerActiveCount()) >= 3)
			return issues("Too many active banners")

		const limit = ratelimitRemote(
			issues,
			"createBanner",
			getClientAddress,
			30
		)
		if (limit) return limit

		await db.insert(Banner, {
			bgColour: bannerColour,
			body: bannerText,
			creator: Record("user", user.id),
			deleted: false,
			textLight: Boolean(bannerTextLight),
		})

		return { success: "Banner created successfully!" }
	}
)

export const deleteForm = form(deleteSchema, async ({ id }, issues) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals, 5)

	if (!(await updateBanner(user, id, "Delete", { deleted: true })))
		return issues("Banner not found")
})

export const visibilityForm = form(
	visibilitySchema,
	async ({ action, id }, issues) => {
		const { locals } = getRequestEvent()
		const { user } = await authorise(locals, 5)

		const active = action === "show"
		if (active && (await bannerActiveCount()) >= 3)
			return issues("Too many active banners")

		const name = active ? "Show" : "Hide"
		if (!(await updateBanner(user, id, name, { active })))
			return issues("Banner not found")
	}
)

export const bodyForm = form(bodySchema, async ({ bannerBody, id }, issues) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals, 5)

	if (!bannerBody) return issues("Missing fields")

	const changes = { body: bannerBody }
	const detail = ` text to "${bannerBody}"`
	if (!(await updateBanner(user, id, "Edit", changes, detail)))
		return issues("Banner not found")
})

export const textLightForm = form(
	textLightSchema,
	async ({ bannerTextLight, id }, issues) => {
		const { locals } = getRequestEvent()
		const { user } = await authorise(locals, 5)

		const textLight = Boolean(bannerTextLight)
		const detail = ` text colour to ${textLight ? "light" : "dark"}`
		if (!(await updateBanner(user, id, "Edit", { textLight }, detail)))
			return issues("Banner not found")
	}
)
