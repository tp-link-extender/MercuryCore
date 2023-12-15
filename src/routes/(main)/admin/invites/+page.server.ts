import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import surreal, { query, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types"

const schema = z.object({
	enableInviteCustom: z.boolean().optional(),
	inviteCustom: z.string().min(3).max(50).optional(),
	enableInviteExpiry: z.boolean().optional(),
	inviteExpiry: z.string().optional(),
	inviteUses: z.number().int().min(1).max(100).default(1),
})

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	const invites = await query<{
		id: string
		created: string
		usesLeft: number
		expiry: string
		creator?: {
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}
	}>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, status, username
				FROM <-created<-user)[0] AS creator
			FROM regKey ORDER BY creation DESC`,
	)

	return {
		form: await superValidate(schema),
		invites,
	}
}

async function getData(e: RequestEvent) {
	const { user } = await authorise(e.locals, 5),
		form = await superValidate(e.request, schema)

	return { user, form, error: !form.valid && formError(form) }
}

export const actions = {
	create: async e => {
		const { user, form, error } = await getData(e)

		console.log(error)
		if (error) return error
		const { getClientAddress } = e

		const limit = ratelimit(form, "createInvite", getClientAddress, 30)
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

		if (
			!!enableInviteExpiry &&
			(expiry?.getTime() || 0) < new Date().getTime()
		)
			return formError(form, ["inviteExpiry"], ["Invalid date"])

		const log = await query(
			surql`
				BEGIN TRANSACTION;
				LET $key = CREATE ${!!enableInviteCustom ? "$" : ""}regKey CONTENT {
					usesLeft: $inviteUses,
					expiry: $expiry,
					created: time::now(),
				};
				RELATE $user->created->$key;
				CREATE auditLog CONTENT {
					action: "Administration",
					note: string::concat("Created invite key ", meta::id($key[0].id)),
					user: $user,
					time: time::now()
				};
				COMMIT TRANSACTION;`,
			{
				user: `user:${user.id}`,
				inviteUses,
				expiry,
				regKey: `regKey:⟨${inviteCustom}⟩`,
			},
		)

		return typeof log == "string"
			? message(form, "This invite key already exists", { status: 400 })
			: message(
					form,
					"Invite created successfully! Check the Invites tab for your new key.",
				)
	},
	disable: async e => {
		const { user, form, error } = await getData(e)
		if (error) return error
		const id = e.url.searchParams.get("id")

		if (!id)
			return message(form, "Missing fields", {
				status: 400,
			})

		const key = (
			(await surreal.select(`regKey:⟨${id}⟩`)) as {
				usesLeft: number
			}[]
		)[0]

		if (key && key.usesLeft == 0)
			return message(form, "Invite key is already disabled", {
				status: 400,
			})

		await query(
			surql`
				UPDATE $key SET usesLeft = 0;
				CREATE auditLog CONTENT {
					action: "Administration",
					note: $note,
					user: $user,
					time: time::now()
				}`,
			{
				note: `Disable invite key ${id}`,
				user: `user:${user.id}`,
				key: `regKey:⟨${id}⟩`,
			},
		)

		return message(form, "Invite key disabled successfully")
	},
}
