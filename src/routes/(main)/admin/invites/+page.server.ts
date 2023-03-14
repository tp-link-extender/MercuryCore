import { auth, authoriseAdmin, authoriseUser } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import { prisma } from "$lib/server/prisma"
import cuid2 from "@paralleldrive/cuid2"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAdmin(locals)

	return {
		invites: prisma.regkey.findMany({
			include: {
				creator: {
					select: {
						username: true,
						number: true,
					},
				},
			},
			orderBy: {
				creation: "asc",
			},
		}),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		await authoriseAdmin(locals)

		const { user } = await authoriseUser(locals.validateUser)

		const data = await request.formData()
		const action = data.get("action") as string

		switch (action) {
			case "create":
				const limit = ratelimit("createInvite", getClientAddress, 30)
				if (limit) return limit

				const customInviteEnabled = !!data.get("enableInviteCustom")
				const customInvite = data.get("inviteCustom") as string
				const inviteExpiryEnabled = !!data.get("enableInviteExpiry")
				const inviteExpiry = new Date(data.get("inviteExpiry") as string)
				const inviteUses = parseInt(data.get("inviteUses") as string)

				const now = new Date()

				if (!inviteUses) return fail(400, { area: "create", msg: "Missing fields" })
				if ((customInviteEnabled && !customInvite) || (inviteExpiryEnabled && !inviteExpiry)) return fail(400, { area: "create", msg: "Missing fields" })

				if (inviteUses < 1 || inviteUses > 100) return fail(400, { area: "create", msg: "Invalid amount of uses" })

				if ((customInviteEnabled && customInvite.length > 50) || (customInviteEnabled && customInvite.length < 3))
					return fail(400, { area: "create", msg: "Custom invite is too short/too long" })

				if (inviteExpiryEnabled && inviteExpiry.getTime() < now.getTime()) return fail(400, { area: "create", msg: "Invalid date" })

				await prisma.regkey.create({
					data: {
						key: customInviteEnabled ? customInvite : cuid2.createId(),
						usesLeft: inviteUses,
						expiry: inviteExpiryEnabled ? inviteExpiry : null,
						creatorId: user.number,
					},
				})

				return {
					success: true,
					msg: "Invite created successfully! Check the Invites tab for your new key.",
					area: "create",
				}
			case "disable":
				const inviteKey = data.get("id") as string

				if(!inviteKey) return fail(400, {msg: "Missing fields"})

				await prisma.regkey.update({
					where: {
						key: inviteKey,
					},
					data: {
						usesLeft: 0
					}
				})

				return
		}
	},
}
