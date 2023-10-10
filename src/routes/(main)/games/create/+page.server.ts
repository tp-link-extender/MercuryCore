import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { transaction } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	name: z.string().min(3).max(50),
	description: z.string().max(1000),
	serverIP: z
		.string()
		.regex(
			/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/,
		),
	serverPort: z.number().int().min(25565).max(65535).default(53640),
	maxPlayers: z.number().int().min(1).max(99).default(10),
	privateServer: z.boolean().optional(),
})

export const load = () => ({
	form: superValidate(schema),
})

export const actions = {
	default: async ({ request, locals }) => {
		const { user } = await authorise(locals),
			form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const {
				name,
				description,
				serverIP,
				serverPort,
				maxPlayers,
				privateServer,
			} = form.data,
			gameCount = (
				(await squery(
					surql`SELECT count(->owns->place) FROM user`,
				)) as {
					count: number
				}[]
			)[0].count

		if (gameCount >= 2)
			return formError(
				form,
				["other"],
				["You may only have 2 places at most"],
			)

		const id = (await squery(surql`stuff:increment.place`)) as number

		try {
			await transaction({ number: user.number }, { number: 1 }, 10, {
				note: `Created place ${name}`,
				link: `/place/${id + 1}`,
			})
		} catch (e: any) {
			console.log("error caught", e.message)
			return formError(form, ["other"], [e.message])
		}

		await squery(
			surql`
				LET $textContent = CREATE textContent CONTENT {
					text: $description,
					updated: time::now(),
				};
				RELATE $user->wrote->$textContent;

				LET $id = (UPDATE ONLY stuff:increment SET place += 1).place;
				LET $place = CREATE place CONTENT {
					id: $id,
					name: $name,
					description: $textContent,
					serverIP: $serverIP,
					serverPort: $serverPort,
					privateServer: $privateServer,
					serverTicket: rand::guid(),
					privateTicket: rand::guid(),
					serverPing: 0,
					maxPlayers: $maxPlayers,
					created: time::now(),
					updated: time::now(),
					deleted: false,
				};
				RELATE $user->owns->$place`,
			{
				user: `user:${user.id}`,
				name,
				description,
				serverIP,
				serverPort,
				privateServer,
				maxPlayers,
			},
		)

		throw redirect(302, `/place/${id + 1}/${name}`)
	},
}
