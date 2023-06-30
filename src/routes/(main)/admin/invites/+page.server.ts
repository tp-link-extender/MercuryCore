import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { prisma } from "$lib/server/prisma"
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
		invites: prisma.regkey.findMany({
			include: {
				creator: true,
			},
			orderBy: {
				creation: "desc",
			},
		}),
	}
}

export const actions = {
	default: async ({ url, request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const {
			action,
			enableInviteCustom,
			inviteCustom,
			enableInviteExpiry,
			inviteExpiry,
			inviteUses,
		} = form.data
		const id = url.searchParams.get("id")

		switch (action) {
			case "create": {
				const limit = ratelimit(
					form,
					"createInvite",
					getClientAddress,
					30
				)
				if (limit) return limit

				const customInviteEnabled = !!enableInviteCustom
				const customInvite = inviteCustom
				const inviteExpiryEnabled = !!enableInviteExpiry

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

				await prisma.regkey.create({
					data: {
						key: customInviteEnabled ? customInvite : undefined,
						usesLeft: inviteUses,
						expiry: inviteExpiryEnabled ? expiry : null,
						creator: {
							connect: {
								id: user.id,
							},
						},
					},
				})

				return message(
					form,
					"Invite created successfully! Check the Invites tab for your new key."
				)
			}
			case "disable":
				if (!id)
					return message(form, "Missing fields", {
						status: 400,
					})

				await prisma.regkey.update({
					where: {
						key: id,
					},
					data: {
						usesLeft: 0,
					},
				})

				return
		}
	},
}
