import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createGroup } from "economy/api"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import { getGroupPrice } from "$lib/server/economy"
import exclude from "$lib/server/exclude"
import formError from "$lib/server/formError"
import { db, findWhere, Record } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import createQuery from "./create.surql"

const schema = type({
	name: "3 <= string <= 40",
})

export async function load() {
	exclude("Groups")
	const price = getGroupPrice()
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
actions.default = async ({ fetch: f, locals, request }) => {
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

	const created = await createGroup(f, new Econ.User(user.id))
	if (!created.ok)
		return formError(form, ["other"], ["Failed to create group"])

	// The Economy service issues the group's ID, and the database record
	// uses it as its own ID so ownership can be resolved from the ledger.
	const groupId = created.value.ID

	await db.query(createQuery, {
		name,
		user: Record("user", user.id),
		economyId: groupId,
	})

	redirect(302, `/groups/${groupId}`)
}
