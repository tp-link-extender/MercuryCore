import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { Record, equery, surql } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types.ts"
import regKeysQuery from "./regKeys.surql"
import config from "$lib/server/config.ts"
import { error } from "@sveltejs/kit"

const schema = z.object({
	enableRegKeyCustom: z.boolean().optional(),
	regKeyCustom: z.string().min(3).max(50).optional(),
	enableRegKeyExpiry: z.boolean().optional(),
	regKeyExpiry: z.string().optional(),
	regKeyUses: z.number().int().min(1).max(100).default(1),
})

type RegKey = {
	id: string
	created: string
	usesLeft: number
	expiry: string
	creator?: BasicUser
}

export async function load({ locals }) {
	if (!config.RegistrationKeys.Enabled) error(404, "Not Found")
	await authorise(locals, 5)

	const [regKeys] = await equery<RegKey[][]>(regKeysQuery)
	return {
		form: await superValidate(zod(schema)),
		regKeys,
	}
}

async function getData(e: RequestEvent) {
	const { user } = await authorise(e.locals, 5)
	const form = await superValidate(e.request, zod(schema))

	return {
		user,
		form,
		error: !form.valid && formError(form),
	}
}

const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
function randomRegKey() {
	let key = ""
	for (let i = 0; i < 20; i++)
		key += chars[Math.floor(Math.random() * chars.length)]
	return key
}

export const actions: import("./$types.ts").Actions = {}
actions.create = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const limit = ratelimit(form, "createRegKey", e.getClientAddress, 30)
	if (limit) return limit

	const {
		enableRegKeyCustom,
		regKeyCustom,
		enableRegKeyExpiry,
		regKeyExpiry,
		regKeyUses,
	} = form.data

	if (
		!regKeyUses ||
		(!!enableRegKeyCustom && !regKeyCustom) ||
		(!!enableRegKeyExpiry && !regKeyExpiry)
	)
		return message(form, "Missing fields", { status: 400 })

	const expiry = regKeyExpiry ? new Date(regKeyExpiry) : null

	if (!!enableRegKeyExpiry && (expiry?.getTime() || 0) < Date.now())
		return formError(form, ["regKeyExpiry"], ["Invalid date"])

	const [log] = await equery<unknown[]>(
		surql`
			CREATE ${Record("regKey", regKeyCustom || randomRegKey())} CONTENT {
				usesLeft: ${regKeyUses},
				expiry: ${expiry},
				created: time::now(),
				creator: ${Record("user", user.id)},
			}`
	)

	return typeof log === "string"
		? message(form, "This registration key already exists", { status: 400 })
		: message(
				form,
				"Key created successfully! Check the Keys tab for your new key."
			)
}
actions.disable = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error
	const id = e.url.searchParams.get("id")

	if (!id) return message(form, "Missing fields", { status: 400 })

	const [[key]] = await equery<{ usesLeft: number }[][]>(surql`
		SELECT usesLeft FROM ${Record("regKey", id)}`)
	if (key && key.usesLeft === 0)
		return message(
			form,
			"Registration key is already disabled or has already ran out of uses",
			{ status: 400 }
		)

	await equery(
		surql`
			UPDATE ${Record("regKey", id)} MERGE {
				usesLeft: 0
				disabledBy: ${Record("user", user.id)} # for logging for now
			}`
	)

	return message(form, "Registration key disabled successfully")
}
