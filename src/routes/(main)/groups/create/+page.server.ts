import { authorise } from "$lib/server/lucia"
import { query, squery, transaction, surql } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	name: z.string().min(3).max(40),
})

export const load = async () => ({
	form: await superValidate(schema),
})

export const actions = {
	default: async ({ request, locals }) => {
		const { user } = await authorise(locals),
			form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { name } = form.data

		if (name.toLowerCase() == "create")
			return formError(
				form,
				["name"],
				[
					Buffer.from(
						"RXJyb3IgMTY6IGR1bWIgbmlnZ2EgZGV0ZWN0ZWQ",
						"base64"
					).toString("ascii"),
				]
			)

		if (name.toLowerCase() == "changed")
			return formError(form, ["name"], ["Dickhead"])

		if (name.toLowerCase() == "wisely")
			return formError(
				form,
				["name"],
				["GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!"]
			)

		if (
			await squery(
				surql`
					SELECT * FROM group WHERE string::lowercase(name)
						= string::lowercase($name)`,
				{ name }
			)
		)
			return formError(
				form,
				["name"],
				["A group with this name already exists"]
			)

		try {
			await transaction({ number: user.number }, { number: 1 }, 10, {
				note: `Created group ${name}`,
				link: `/groups/${name}`,
			})
		} catch (e: any) {
			return formError(form, ["other"], [e.message])
		}

		await query(
			surql`
				LET $group = CREATE group CONTENT {
					name: $name,
					created: time::now(),
				};
				RELATE $user->owns->$group
					SET time = time::now();
				RELATE $user->member->$group
					SET time = time::now()`,
			{
				name,
				user: `user:${user.id}`,
			}
		)

		redirect(302, `/groups/${name}`)
	},
}
