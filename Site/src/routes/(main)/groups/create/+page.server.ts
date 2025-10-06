import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import { createGroup, getGroupPrice } from "$lib/server/economy"
import exclude from "$lib/server/exclude"
import formError from "$lib/server/formError"
import { db, findWhere, Record } from "$lib/server/surreal"
import createQuery from "./create.surql"

const schema = type({
	name: "3 <= string <= 40",
})

export async function load() {
	exclude("Groups")
	const price = await getGroupPrice()
	return {
		form: await superValidate(arktype(schema)),
		price,
	}
}

const errors: { [_: string]: string } = Object.freeze({
	create: Buffer.from(
		"RXJyb3IgMTY6IGR1bWIgbmlnZ2EgZGV0ZWN0ZWQ",
		"base64"
	).toString(),
	changed: "Dickhead",
	wisely: "GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!",
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request }) => {
	exclude("Groups")
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { name } = form.data
	const lowercaseName = name.toLowerCase()
	if (errors[lowercaseName])
		return formError(form, ["name"], [errors[lowercaseName]])

	const foundGroup = await findWhere(
		"group",
		"string::lowercase(name) = $lowercaseName",
		{ lowercaseName }
	)
	if (foundGroup)
		return formError(
			form,
			["name"],
			["A group with this name already exists"]
		)

	const created = await createGroup(user.id, name)
	if (!created.ok) return formError(form, ["other"], [created.msg])

	await db.query(createQuery, {
		name,
		user: Record("user", user.id),
	})

	redirect(302, `/groups/${name}`)
}
