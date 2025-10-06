import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
// import { createPlace, getPlacePrice } from "$lib/server/economy"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { randomAssetId } from "$lib/server/id"
import { db, Record } from "$lib/server/surreal"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "$lib/typeTests"
import { encode } from "$lib/urlName"
import countQuery from "./count.surql"
import createQuery from "./create.surql"

const schema = type({
	name: "3 <= string <= 50",
	description: "string <= 1000",
	serverAddress: serverAddressTest,
	// eh, works well enough and the built-in z.string().url() requires a protocol
	serverPort: serverPortTest.default(53640),
	maxPlayers: maxPlayersTest.default(10),
	privateServer: "boolean | undefined",
})

async function placeCount(id: string) {
	const [[count]] = await db.query<number[][]>(countQuery, {
		user: Record("user", id),
	})
	return count
}

export async function load() {
	// const price = getPlacePrice()
	return {
		form: await superValidate(arktype(schema)),
		// count: await placeCount((await authorise(locals)).user.id),
		// price,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { serverAddress, serverPort, maxPlayers, privateServer } = form.data

	const name = form.data.name.trim()
	if (!name) return formError(form, ["name"], ["Place must have a name"])
	const description = form.data.description.trim()
	if (!description)
		return formError(
			form,
			["description"],
			["Place must have a description"]
		)
	if ((await placeCount(user.id)) >= 2)
		return formError(
			form,
			["other"],
			["You can't have more than two places"]
		)

	const slug = encode(name)
	const id = randomAssetId() // listen, this still isn't great, but whatever atp

	// const created = await createPlace(user.id, id, name, slug)
	// if (!created.ok) return formError(form, ["other"], [created.msg])

	await db.query(createQuery, {
		id,
		user: Record("user", user.id),
		name: filter(name),
		description: filter(description),
		serverAddress,
		serverPort,
		privateServer,
		maxPlayers,
	})

	redirect(302, `/place/${id}/${slug}`)
}
