import { error, redirect } from "@sveltejs/kit"
import { zod4 } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod/v4"
import { authorise } from "$lib/server/auth"
import { createPlace, getPlacePrice } from "$lib/server/economy"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { randomId } from "$lib/server/id"
import { db, Record } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import countQuery from "./count.surql"
import createQuery from "./create.surql"

const schema = z.object({
	name: z.string().min(3).max(50),
	description: z.string().max(1000),
	serverAddress: z
		.string()
		.regex(
			/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
		),
	// eh, works well enough and the built-in z.string().url() requires a protocol
	serverPort: z.number().int().min(1024).max(65535).default(53640),
	maxPlayers: z.number().int().min(1).max(99).default(10),
	privateServer: z.boolean().optional(),
})

async function placeCount(id: string) {
	const [[count]] = await db.query<number[][]>(countQuery, {
		user: Record("user", id),
	})
	return count
}

export async function load() {
	const price = await getPlacePrice()
	if (!price.ok) error(500, price.msg)
	return {
		form: await superValidate(zod4(schema)),
		// count: await placeCount((await authorise(locals)).user.id),
		price: price.value,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod4(schema))
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
	const id = randomId() // still, find a better way stat

	const created = await createPlace(user.id, id, name, slug)
	if (!created.ok) return formError(form, ["other"], [created.msg])

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
