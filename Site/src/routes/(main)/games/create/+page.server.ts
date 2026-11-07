import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createPlace } from "economy/api"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { db } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "$lib/typeTests"
import { encode } from "$lib/urlName"
import clientVersions from "./clientVersions"
import createQuery from "./create.surql"

const schema = type({
	clientVersion: type.enumerated(...clientVersions).configure({
		problem: "must be a valid client version",
	}),
	description: "string <= 1000",
	maxPlayers: maxPlayersTest.default(10),
	name: "3 <= string <= 50",
	privateServer: "boolean | undefined",
	serverAddress: serverAddressTest,
	// eh, works well enough and the built-in z.string().url() requires a protocol
	serverPort: serverPortTest.default(53640),
})

export async function load() {
	return {
		form: await superValidate(arktype(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ fetch: f, locals, request }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const {
		serverAddress,
		serverPort,
		maxPlayers,
		clientVersion,
		privateServer,
	} = form.data

	const name = form.data.name.trim()
	if (!name) return formError(form, ["name"], ["Place must have a name"])
	const description = form.data.description.trim()
	if (!description)
		return formError(
			form,
			["description"],
			["Place must have a description"]
		)
	// if ((await placeCount(user.id)) >= 2)
	// 	return formError(
	// 		form,
	// 		["other"],
	// 		["You can't have more than two places"]
	// 	)

	const u = new Econ.User(user.id)
	const created = await createPlace(f, u)
	if (!created.ok)
		return formError(form, ["other"], ["failed to create place"])

	const id = created.value.ID

	await db.query(createQuery, {
		clientVersion: +clientVersion,
		description: filter(description),
		id,
		maxPlayers,
		name: filter(name),
		privateServer,
		serverAddress,
		serverPort,
	})

	redirect(302, `/place/${id}/${encode(name)}`)
}
