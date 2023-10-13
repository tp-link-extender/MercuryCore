import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import surreal, { squery } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	action: z.enum(["create", "disable"]),
	enableInviteCustom: z.boolean().optional(),
	inviteCustom: z.string().min(3).max(50).optional(),
	enableInviteExpiry: z.boolean().optional(),
	inviteExpiry: z.string().optional(),
	inviteUses: z.number().int().min(1).max(100).default(1),
})

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		invites: (await squery(
			surql`
				SELECT
					*,
					meta::id(id) AS id,
					(SELECT
						number,
						username
					FROM <-created<-user)[0] AS creator
				FROM regKey
				ORDER BY creation DESC`,
		)) as {
			id: string
			created: string
			usesLeft: number
			expiry: string
			creator?: {
				number: number
				username: string
			}
		}[],
	}
}

export const actions = {
	default: async ({ url, request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const { user } = await authorise(locals),
			form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const {
				action,
				enableInviteCustom,
				inviteCustom,
				enableInviteExpiry,
				inviteExpiry,
				inviteUses,
			} = form.data,
			id = url.searchParams.get("id")

		switch (action) {
			case "create": {
				const limit = ratelimit(
					form,
					"createInvite",
					getClientAddress,
					30,
				)
				if (limit) return limit

				const customInviteEnabled = !!enableInviteCustom,
					customInvite = inviteCustom,
					inviteExpiryEnabled = !!enableInviteExpiry

				if (
					!inviteUses ||
					(customInviteEnabled && !customInvite) ||
					(inviteExpiryEnabled && !inviteExpiry)
				)
					return message(form, "Missing fields", {
						status: 400,
					})

				const expiry = inviteExpiry ? new Date(inviteExpiry) : null

				if (
					inviteExpiryEnabled &&
					(expiry?.getTime() || 0) < new Date().getTime()
				)
					return formError(form, ["inviteExpiry"], ["Invalid date"])

				await squery(
					surql`
						LET $key = CREATE regKey CONTENT {
							usesLeft: $inviteUses,
							expiry: $expiry,
							created: time::now(),
						};
						RELATE $user->created->$key;
						CREATE auditLog CONTENT {
							action: "Administration",
							note: string::concat("Created invite key ", meta::id($key)),
							user: $user,
							time: time::now()
						}`,
					{
						user: `user:${user.id}`,
						inviteUses,
						expiry,
					},
				)

				return message(
					form,
					"Invite created successfully! Check the Invites tab for your new key.",
				)
			}
			case "disable":
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

				await squery(
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
		}
	},
}
