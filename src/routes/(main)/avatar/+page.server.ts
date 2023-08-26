import render from "$lib/server/render"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"
import { fail } from "@sveltejs/kit"

const brickColours = [
	1, 5, 9, 11, 18, 21, 23, 24, 26, 28, 29, 37, 38, 101, 102, 104, 105, 106,
	107, 119, 125, 135, 141, 151, 153, 192, 194, 199, 208, 217, 226, 1001, 1002,
	1003, 1004, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015,
	1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027,
	1028, 1029, 1030, 1031, 1032,
]

export const actions = {
	paint: async ({ locals, url }) => {
		const { user } = await authorise(locals),
			bodyPartQuery = url.searchParams.get("p"),
			bodyColour = url.searchParams.get("c")

		if (
			!bodyPartQuery ||
			!bodyColour ||
			!brickColours.includes(parseInt(bodyColour)) ||
			![
				"Head",
				"Torso",
				"LeftArm",
				"RightArm",
				"LeftLeg",
				"RightLeg",
			].includes(bodyPartQuery)
		)
			return fail(400)

		const bodyPart = bodyPartQuery as keyof typeof user.bodyColours,
			currentBodyColour = user.bodyColours

		currentBodyColour[bodyPart] = parseInt(bodyColour)

		await prisma.authUser.update({
			where: { id: user.id },
			data: { bodyColours: currentBodyColour },
		})

		render(user.username, currentBodyColour)

		return {
			avatar: `${await render(
				user.username,
				currentBodyColour,
				true,
			)}?r=${Math.random()}`,
		}
	},

	regen: async ({ locals, getClientAddress }) => {
		const { user } = await authorise(locals)

		if (ratelimit({}, "regen", getClientAddress, 1))
			return fail(429, { msg: "Too many requests" })

		return {
			avatar: `${await render(
				user.username,
				user.bodyColours,
				true,
			)}?r=${Math.random()}`,
		}
	},
}
