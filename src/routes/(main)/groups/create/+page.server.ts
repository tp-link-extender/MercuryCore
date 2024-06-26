import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import { Record, equery, findWhere, transaction } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import createQuery from "./create.surql"

const schema = z.object({
	name: z.string().min(3).max(40),
})

export const load = async () => ({
	form: await superValidate(zod(schema)),
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const { name } = form.data

	if (name.toLowerCase() === "create")
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

	if (name.toLowerCase() === "changed")
		return formError(form, ["name"], ["Dickhead"])

	if (name.toLowerCase() === "wisely")
		return formError(
			form,
			["name"],
			["GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!"]
		)

	const foundGroup = await findWhere(
		"group",
		"string::lowercase(name) = string::lowercase($name)",
		{ name }
	)
	if (foundGroup)
		return formError(
			form,
			["name"],
			["A group with this name already exists"]
		)

	try {
		await transaction(user, { number: 1 }, 10, {
			note: `Created group ${name}`,
			link: `/groups/${name}`,
		})
	} catch (err) {
		const e = err as Error
		return formError(form, ["other"], [e.message])
	}

	await equery(createQuery, {
		name,
		user: Record("user", user.id),
	})

	redirect(302, `/groups/${name}`)
}
