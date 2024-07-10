import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { Record, equery, surql } from "$lib/server/surreal"
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

const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
function randomInvite() {
	let key = ""
	for (let i = 0; i < 20; i++)
		key += chars[Math.floor(Math.random() * chars.length)]
	return key
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
		surql`
			CREATE ${Record("regKey", inviteCustom || randomInvite())} CONTENT {
				usesLeft: ${inviteUses},
				expiry: ${expiry},
				created: time::now(),
				creator: ${Record("user", user.id)},
			}`
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
		surql`SELECT usesLeft FROM ${Record("regKey", id)}`
	)

	if (key && key.usesLeft === 0)
		return message(
			form,
			"Invite key is already disabled or has already ran out of uses",
			{ status: 400 }
		)

	await equery(
		surql`
			UPDATE ${Record("regKey", id)} MERGE {
				usesLeft: 0
				disabledBy: ${Record("user", user.id)} # for logging for now
			}`
	)

	return message(form, "Invite key disabled successfully")
}
