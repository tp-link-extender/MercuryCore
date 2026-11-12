import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { AlreadyExistsError } from "surrealdb"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import {
	arktype,
	errMessage,
	message,
	superValidate,
} from "$lib/server/validate"
import type { Actions, RequestEvent } from "./$types"
import createQuery from "./create.surql"
import disabledQuery from "./disabled.surql"
import regkeysQuery from "./regkeys.surql"

const schema = type({
	enableRegKeyCustom: "boolean | undefined",
	enableRegKeyExpiry: "boolean | undefined",
	regKeyCustom: "(3 <= string <= 50 | undefined)?",
	regKeyExpiry: "string | undefined",
	regKeyUses: type("1 <= number <= 100").default(1),
})

interface RegKey {
	created: string
	creator?: BasicUser
	expiry: Date | string | null
	id: string
	usesLeft: number
}

export async function load({ locals }: RequestEvent) {
	if (!config.Registration.Keys.Enabled) error(404, "Not Found")
	await authorise(locals, 5)

	const [regKeys] = await db.query<RegKey[][]>(regkeysQuery)
	return {
		form: await superValidate(arktype(schema)),
		prefix: config.Registration.Keys.Prefix,
		regKeys,
	}
}

async function getData({ locals, request }: RequestEvent) {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, arktype(schema))

	return { error: !form.valid && formError(form), form, user }
}

export const actions: Actions = {}
actions.create = async e => {
	const { user, form, error: dataError } = await getData(e)
	if (dataError) return dataError

	const {
		enableRegKeyCustom,
		regKeyCustom,
		enableRegKeyExpiry,
		regKeyExpiry,
		regKeyUses,
	} = form.data

	if (
		(Boolean(enableRegKeyCustom) && !regKeyCustom) ||
		(Boolean(enableRegKeyExpiry) && !regKeyExpiry)
	)
		return errMessage(form, "Missing fields")

	const expiry = regKeyExpiry ? new Date(regKeyExpiry) : undefined

	if (enableRegKeyExpiry && (expiry?.getTime() || 0) < Date.now())
		return formError(form, ["regKeyExpiry"], ["Invalid date"])

	const limit = ratelimit(form, "createRegKey", e.getClientAddress, 30)
	if (limit) return limit

	try {
		await db.query(createQuery, {
			creator: Record("user", user.id),
			expiry,
			regKeyCustom,
			regKeyUses,
		})
	} catch (err) {
		// honestly we should really use these error types more, idk if the only just got added or what idc
		if (!(err instanceof AlreadyExistsError)) throw err
		return errMessage(form, "This registration key already exists")
	}

	message(
		form,
		"Key created successfully! Check the Keys tab for your new key."
	)
}
actions.disable = async e => {
	const { user, form, error: dataError } = await getData(e)
	if (dataError) return dataError
	const id = e.url.searchParams.get("id")
	if (!id) return errMessage(form, "Missing fields")

	const [[key]] =
		await db.query<({ disabled: boolean } | null)[][]>(disabledQuery)
	if (key?.disabled)
		return errMessage(
			form,
			"Registration key is already disabled or has already ran out of uses"
		)

	await db.query(
		`
			UPDATE $regKey SET usesLeft = 0;
			fn::auditLog("Administration", $msg, $user)`,
		{
			msg: `Disable registration key ${id}`,
			regKey: Record("regKey", id),
			user: Record("user", user.id),
		}
	)

	return message(form, "Registration key disabled successfully")
}
