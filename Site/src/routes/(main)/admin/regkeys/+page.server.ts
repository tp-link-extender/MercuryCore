import { authorise } from "$lib/server/auth"
import config from "$lib/server/config.ts"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types.ts"
import createQuery from "./create.surql"
import disabledQuery from "./disabled.surql"
import regkeysQuery from "./regkeys.surql"

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

	const [regKeys] = await db.query<RegKey[][]>(regkeysQuery)
	return {
		form: await superValidate(zod(schema)),
		regKeys,
		prefix: config.RegistrationKeys.Prefix,
	}
}

async function getData({ locals, request }: RequestEvent) {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, zod(schema))

	return { user, form, error: !form.valid && formError(form) }
}

export const actions: import("./$types.ts").Actions = {}
actions.create = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

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

	const expiry = regKeyExpiry ? new Date(regKeyExpiry) : undefined

	if (!!enableRegKeyExpiry && (expiry?.getTime() || 0) < Date.now())
		return formError(form, ["regKeyExpiry"], ["Invalid date"])

	const limit = ratelimit(form, "createRegKey", e.getClientAddress, 30)
	if (limit) return limit

	const [result] = await db.queryRaw<unknown[]>(createQuery, {
		regKeyCustom,
		creator: Record("user", user.id),
		expiry,
		regKeyUses,
	})

	return result.status === "ERR"
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

	const [[key]] =
		await db.query<({ disabled: boolean } | null)[][]>(disabledQuery)
	if (key?.disabled)
		return message(
			form,
			"Registration key is already disabled or has already ran out of uses",
			{ status: 400 }
		)

	await db.query(
		`
			UPDATE $regKey SET usesLeft = 0;
			fn::auditLog("Administration", $msg, $user)`,
		{
			regKey: Record("regKey", id),
			msg: `Disable registration key ${id}`,
			user: Record("user", user.id),
		}
	)

	return message(form, "Registration key disabled successfully")
}
