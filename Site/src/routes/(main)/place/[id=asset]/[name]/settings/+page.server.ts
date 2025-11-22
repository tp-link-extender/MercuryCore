import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import sharp from "sharp"
import { arktype } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { db, Record } from "$lib/server/surreal"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "$lib/typeTests"
import { encode } from "$lib/urlName"
import type { RequestEvent } from "./$types.d"
import privateTicketQuery from "./privateTicket.surql"
import serverTicketQuery from "./serverTicket.surql"
import settingsQuery from "./settings.surql"
import updateSettingsQuery from "./updateSettings.surql"

const viewSchema = type({
	name: "string <= 100",
	icon: "(File | undefined)?",
	description: "(string <= 1000) | undefined",
})
const networkSchema = type({
	dedicated: "boolean",
	serverAddress: serverAddressTest.optional(),
	serverPort: serverPortTest.optional(),
	maxPlayers: maxPlayersTest,
})
const ticketSchema = type({} as never) // I'm a genius
const privacySchema = type({
	privateServer: "boolean",
})
const privatelinkSchema = type({} as never)
const dataSchema = type({
	file: "File",
})

type Place = {
	created: string
	dedicated: boolean
	description: {
		text: string
		updated: string
	}
	id: string // graah
	maxPlayers: number
	name: string
	owner: BasicUser
	privateServer: boolean
	privateTicket: string
	serverAddress: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: string
}

async function placeQuery(id: number) {
	const [[place]] = await db.query<Place[][]>(settingsQuery, {
		place: Record("place", id),
	})
	return place
}

export async function load({ locals, params }) {
	const getPlace = await placeQuery(+params.id)
	if (!getPlace) error(404, "Place not found")

	const { user } = await authorise(locals)
	if (user.username !== getPlace.owner.username && user.permissionLevel < 4)
		error(403, "You do not have permission to view this page.")

	return {
		...getPlace,
		slug: encode(getPlace.name),
		viewForm: await superValidate(
			{ name: getPlace.name },
			arktype(viewSchema)
		),
		networkForm: await superValidate(arktype(networkSchema)),
		ticketForm: await superValidate(arktype(ticketSchema)), // lmaooo it works
		privacyForm: await superValidate(arktype(privacySchema)),
		privatelinkForm: await superValidate(arktype(privatelinkSchema)),
		dataForm: await superValidate(arktype(dataSchema)),
	}
}

async function getData({ locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const id = +params.id
	const getPlace = await placeQuery(id)
	if (user.username !== getPlace.owner.username && user.permissionLevel < 4)
		error(403, "You do not have permission to update this page.")

	return id
}

export const actions: import("./$types").Actions = {}
actions.view = async e => {
	const id = await getData(e)

	const formData = await e.request.formData()
	const form = await superValidate(formData, arktype(viewSchema))
	if (!form.valid) return formError(form)

	const { name, icon, description } = form.data
	form.data.icon = undefined // make sure files don't get returned (they can't be serialised)

	if (icon && icon.size > 0) {
		if (icon.size > 1e6)
			return formError(
				form,
				["icon"],
				["Icon must be less than 1MB in size"]
			)

		if (!fs.existsSync("../data/icons")) fs.mkdirSync("../data/icons")
		sharp(await icon.arrayBuffer())
			.resize(270, 270)
			.avif({ effort: 9 }) // not awaited, so this'll happen in the background (takes a sec or 2)
			.toFile(`../data/icons/${id}.avif`) // also errors aren't caught but whatever
	}

	await db.query(updateSettingsQuery, {
		place: Record("place", +id),
		name: filter(name),
		description: filter(description || ""),
	})
	return message(form, "View settings updated successfully!")
}
actions.ticket = async e => {
	const id = await getData(e)

	await db.query(serverTicketQuery, { place: Record("place", id) })
	return message(
		await superValidate(e.request, arktype(ticketSchema)),
		"Regenerated!"
	)
}
actions.network = async e => {
	const id = await getData(e)
	const form = await superValidate(e.request, arktype(networkSchema))
	if (!form.valid) return formError(form)

	await db.merge(Record("place", id), form.data)
	return message(form, "Network settings updated successfully!")
}
actions.privacy = async e => {
	const id = await getData(e)
	const form = await superValidate(e.request, arktype(privacySchema))
	if (!form.valid) return formError(form)

	const { privateServer } = form.data

	await db.merge(Record("place", id), { privateServer })
	return message(form, "Privacy settings updated successfully!")
}
actions.privatelink = async e => {
	const id = await getData(e)

	await db.query(privateTicketQuery, { place: Record("place", id) })
	return message(
		await superValidate(e.request, arktype(privatelinkSchema)),
		"Regenerated!"
	)
}
actions.data = async e => {
	const id = await getData(e)
	const formData = await e.request.formData()
	const form = await superValidate(formData, arktype(dataSchema))
	if (!form.valid) return formError(form)

	const { file } = form.data
	form.data.file = undefined as unknown as File
	if (file.size > 100e6)
		return formError(
			form,
			["file"],
			["File must be less than 100MB in size"]
		)

	await Bun.write(`../data/places/${id}`, file)
	return message(form, "Place data updated successfully!")
}
