import { authorise } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import { prisma } from "$lib/server/prisma"
import cuid2 from "@paralleldrive/cuid2"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 5)

	return {
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
	default: async ({ request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const { user } = await authorise(locals)

		const data = await formData(request)
		const action = data.action

		switch (action) {
			case "create":
				const limit = ratelimit("createInvite", getClientAddress, 30)
				if (limit) return limit

				const customInviteEnabled = !!data.enableInviteCustom
				const customInvite = data.inviteCustom
				const inviteExpiryEnabled = !!data.enableInviteExpiry
				const inviteExpiry = new Date(data.inviteExpiry)
				const inviteUses = parseInt(data.inviteUses)

				const now = new Date()

				if (!inviteUses)
					return fail(400, { area: "create", msg: "Missing fields" })
				if (
					(customInviteEnabled && !customInvite) ||
					(inviteExpiryEnabled && !inviteExpiry)
				)
					return fail(400, { area: "create", msg: "Missing fields" })

				if (inviteUses < 1 || inviteUses > 100)
					return fail(400, {
						area: "create",
						msg: "Invalid amount of uses",
					})

				if (
					(customInviteEnabled && customInvite.length > 50) ||
					(customInviteEnabled && customInvite.length < 3)
				)
					return fail(400, {
						area: "create",
						msg: "Custom invite is too short/too long",
					})

				if (
					inviteExpiryEnabled &&
					inviteExpiry.getTime() < new Date().getTime()
				)
					return fail(400, { area: "create", msg: "Invalid date" })

				await prisma.regkey.create({
					data: {
						key: customInviteEnabled
							? customInvite
							: cuid2.createId(),
						usesLeft: inviteUses,
						expiry: inviteExpiryEnabled ? inviteExpiry : null,
						creator: {
							connect: {
								id: user.id,
							},
						},
					},
				})

				return {
					success: true,
					msg: "Invite created successfully! Check the Invites tab for your new key.",
					area: "create",
				}
			case "disable":
				const inviteKey = data.id

				if (!inviteKey) return fail(400, { msg: "Missing fields" })

				await prisma.regkey.update({
					where: {
						key: inviteKey,
					},
					data: {
						usesLeft: 0,
					},
				})

				return
		}
	},
}
