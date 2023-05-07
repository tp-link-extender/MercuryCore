import render from "$lib/server/render"
import { fail } from "@sveltejs/kit"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

const brickColours = [
	1, 5, 9, 11, 18, 21, 23, 24, 26, 28, 29, 37, 38, 101, 102, 104, 105, 106,
	107, 119, 125, 135, 141, 151, 153, 192, 194, 199, 208, 217, 226, 1001, 1002,
	1003, 1004, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015,
	1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027,
	1028, 1029, 1030, 1031, 1032,
]

export const actions = {
	paint: async ({ locals, url }) => {
		const { user } = await authorise(locals)

		const bodyPart = url.searchParams.get("p")
		const bodyColour = url.searchParams.get("c")
		if (
			!bodyPart ||
			!bodyColour ||
			!brickColours.includes(parseInt(bodyColour))
		)
			return fail(400)

		const currentBodyColour = user.bodyColours
		currentBodyColour[bodyPart] = parseInt(bodyColour)

		await prisma.authUser.update({
			where: { id: user.id },
			data: { bodyColours: currentBodyColour },
		})

		render(user.username, currentBodyColour)
	},
}
