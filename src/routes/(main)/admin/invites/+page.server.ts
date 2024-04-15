import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { query, squery, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import type { RequestEvent } from "./$types"
import auditLog from "$lib/server/auditLog.surql"

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

	return {
		form: await superValidate(zod(schema)),
		invites: await query<Invite>(import("./invites.surql")),
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
		return message(form, "Missing fields", {
			status: 400,
		})

	const expiry = inviteExpiry ? new Date(inviteExpiry) : null

	if (!!enableInviteExpiry && (expiry?.getTime() || 0) < new Date().getTime())
		return formError(form, ["inviteExpiry"], ["Invalid date"])

	const log = await query(
		surql`
			BEGIN TRANSACTION;
			LET $key = CREATE ${enableInviteCustom ? "$" : ""}regKey CONTENT {
				usesLeft: $inviteUses,
				expiry: $expiry,
				created: time::now()
			};
			RELATE $user->created->$key;
			LET $note = string::concat("Created invite key ", meta::id($key[0].id));
			${auditLog};
			COMMIT TRANSACTION`,
		{
			action: "Administration",
			user: `user:${user.id}`,
			inviteUses,
			expiry,
			regKey: `regKey:⟨${inviteCustom}⟩`,
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

	const key = await squery<{
		usesLeft: number
	}>(surql`SELECT usesLeft FROM $id`, { id: `regKey:⟨${id}⟩` })

	if (key && key.usesLeft === 0)
		return message(form, "Invite key is already disabled", {
			status: 400,
		})

	await query(surql`UPDATE $key SET usesLeft = 0; ${auditLog}`, {
		action: "Administration",
		note: `Disable invite key ${id}`,
		user: `user:${user.id}`,
		key: `regKey:⟨${id}⟩`,
	})

	return message(form, "Invite key disabled successfully")
}
