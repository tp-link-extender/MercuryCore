import auditLogQuery from "$lib/server/auditLog.surql"
import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { RecordId, equery, surrealql } from "$lib/server/surreal"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types.d.ts"
import invitesQuery from "./invites.surql"

const schema = z.object({
	enableInviteCustom: z.boolean().optional(),
	inviteCustom: z.string().min(3).max(50).optional(),
	enableInviteExpiry: z.boolean().optional(),
	inviteExpiry: z.string().optional(),
	inviteUses: z.number().int().min(1).max(100).default(1),
})

type Invite = {
	id: string
	created: string
	usesLeft: number
	expiry: string
	creator?: BasicUser
}

export async function load({ locals }) {
	await authorise(locals, 5)

	const [invites] = await equery<Invite[][]>(invitesQuery)

	return {
		form: await superValidate(zod(schema)),
		invites,
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

export const actions: import("./$types").Actions = {}
actions.create = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error

	const limit = ratelimit(form, "createInvite", e.getClientAddress, 30)
	if (limit) return limit

	const {
		enableInviteCustom,
		inviteCustom,
		enableInviteExpiry,
		inviteExpiry,
		inviteUses,
	} = form.data

	if (
		!inviteUses ||
		(!!enableInviteCustom && !inviteCustom) ||
		(!!enableInviteExpiry && !inviteExpiry)
	)
		return message(form, "Missing fields", { status: 400 })

	const expiry = inviteExpiry ? new Date(inviteExpiry) : null

	if (!!enableInviteExpiry && (expiry?.getTime() || 0) < Date.now())
		return formError(form, ["inviteExpiry"], ["Invalid date"])

	const [log] = await equery<unknown[]>(
		`
			BEGIN TRANSACTION;
			LET $key = CREATE ${enableInviteCustom ? "$" : ""}regKey CONTENT {
				usesLeft: $inviteUses,
				expiry: $expiry,
				created: time::now()
			};
			RELATE $user->created->$key;
			LET $note = string::concat("Created invite key ", meta::id($key[0].id));
			${auditLogQuery};
			COMMIT TRANSACTION`,
		{
			action: "Administration",
			user: new RecordId("user", user.id),
			inviteUses,
			expiry,
			regKey: new RecordId("regKey", inviteCustom || ""),
		}
	)

	return typeof log === "string"
		? message(form, "This invite key already exists", { status: 400 })
		: message(
				form,
				"Invite created successfully! Check the Invites tab for your new key."
			)
}
actions.disable = async e => {
	const { user, form, error } = await getData(e)
	if (error) return error
	const id = e.url.searchParams.get("id")

	if (!id) return message(form, "Missing fields", { status: 400 })

	const [[key]] = await equery<{ usesLeft: number }[][]>(
		surrealql`SELECT usesLeft FROM ${new RecordId("regKey", id)}`
	)

	if (key && key.usesLeft === 0)
		return message(form, "Invite key is already disabled", { status: 400 })

	await equery(`UPDATE $key SET usesLeft = 0; ${auditLogQuery}`, {
		action: "Administration",
		note: `Disable invite key ${id}`,
		user: new RecordId("user", user.id),
		key: new RecordId("regKey", id),
	})

	return message(form, "Invite key disabled successfully")
}
