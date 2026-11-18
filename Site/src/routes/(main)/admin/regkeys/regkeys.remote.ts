import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { AlreadyExistsError } from "surrealdb"
import { authorise } from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { db, Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import createQuery from "./create.surql"
import disabledQuery from "./disabled.surql"

const schema = type({
	"enableRegKeyCustom?": "boolean",
	"enableRegKeyExpiry?": "boolean",
	regKeyCustom: "(3 <= string <= 50 | undefined)?",
	"regKeyExpiry?": "string",
	regKeyUses: type("1 <= number.integer <= 100").default(1),
})

const restricted = () => {
	if (!config.Registration.Keys.Enabled) error(404, "Not Found")
}

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async (
		{
			enableRegKeyCustom,
			regKeyCustom,
			enableRegKeyExpiry,
			regKeyExpiry,
			regKeyUses,
		},
		issues
	) => {
		restricted()
		const { locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals, 5)

		if (
			(Boolean(enableRegKeyCustom) && !regKeyCustom) ||
			(Boolean(enableRegKeyExpiry) && !regKeyExpiry)
		)
			return issues("Missing fields")

		const expiry = regKeyExpiry ? new Date(regKeyExpiry) : undefined

		if (enableRegKeyExpiry && (expiry?.getTime() || 0) < Date.now())
			return issues.regKeyExpiry("Invalid date")

		const limit = ratelimitRemote(
			issues,
			"createRegKey",
			getClientAddress,
			30
		)
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
			return issues("This registration key already exists")
		}

		return {
			success:
				"Key created successfully! Check the Keys tab for your new key.",
		}
	}
)

const disableSchema = type({
	id: "string",
})

export const disableForm = form(disableSchema, async ({ id }, issues) => {
	restricted()
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals, 5)

	const regKey = Record("regKey", id)
	const [[key]] = await db.query<{ disabled: boolean }[][]>(disabledQuery, {
		regKey,
	})
	if (!key) return issues("Registration key not found")
	if (key.disabled)
		return issues(
			"Registration key is already disabled or has already ran out of uses"
		)

	await db.query(
		`
			UPDATE $regKey SET usesLeft = 0;
			fn::auditLog("Administration", $msg, $user)`,
		{
			msg: `Disable registration key ${id}`,
			regKey,
			user: Record("user", user.id),
		}
	)

	return { success: "Registration key disabled successfully" }
})
