import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import * as Econ from "economy/types"
import sharp from "sharp"
import { authorise } from "$lib/server/auth"
import { economyConnFailed, ownsItem } from "$lib/server/economy"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { closeGameserver } from "$lib/server/orbiter"
import { db, Record } from "$lib/server/surreal"
import { arktype, message, superValidate } from "$lib/server/validate"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "$lib/typeTests"
import { encode } from "$lib/urlName"
import clientVersions from "../../../../games/create/clientVersions"
import type { Actions, PageServerLoadEvent } from "./$types"
import type { RequestEvent } from "./$types.d"
import privateTicketQuery from "./privateTicket.surql"
import serverTicketQuery from "./serverTicket.surql"
import settingsQuery from "./settings.surql"
import updateSettingsQuery from "./updateSettings.surql"

const viewSchema = type({
	description: "(string <= 1000) | undefined",
	icon: "(File | undefined)?",
	name: "string <= 100",
})
const networkSchema = type({
	clientVersion: type
		.enumerated(...clientVersions)
		.pipe.try(Number)
		.configure({ problem: "must be a valid client version" }),
	dedicated: "boolean",
	maxPlayers: maxPlayersTest,
	serverAddress: serverAddressTest.optional(),
	serverPort: serverPortTest.optional(),
})
const ticketSchema = type({} as never) // I'm a genius
const privacySchema = type({
	privateServer: "boolean",
})
const privatelinkSchema = type({} as never)
const dataSchema = type({
	file: "File",
})

interface Place {
	created: string
	dedicated: boolean
	description: string
	id: string // graah
	maxPlayers: number
	name: string
	privateServer: boolean
	privateTicket: string
	clientVersion: number
	serverAddress: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: Date
}

async function placeQuery(id: number) {
	const [[place]] = await db.query<Place[][]>(settingsQuery, {
		place: Record("place", id),
	})
	return place
}

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const getPlace = await placeQuery(Number(params.id))
	if (!getPlace) error(404, "Place not found")

	const { user } = await authorise(locals)
	const owns = await ownsItem(f, user.id, new Econ.Place(Number(params.id)))
	if (!owns.ok) error(500, economyConnFailed)
	if (!owns.value && user.permissionLevel < 4)
		error(403, "You do not have permission to view this page.")

	return {
		...getPlace,
		clientVersions,
		dataForm: await superValidate(arktype(dataSchema)),
		networkForm: await superValidate(arktype(networkSchema)),
		privacyForm: await superValidate(arktype(privacySchema)),
		privatelinkForm: await superValidate(arktype(privatelinkSchema)),
		slug: encode(getPlace.name),
		ticketForm: await superValidate(arktype(ticketSchema)), // lmaooo it works
		viewForm: await superValidate(
			{ name: getPlace.name },
			arktype(viewSchema)
		),
	}
}

async function getData({ fetch: f, locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const id = Number(params.id)
	const getPlace = await placeQuery(id)
	if (!getPlace) error(404, "Place not found")

	const owns = await ownsItem(f, user.id, new Econ.Place(id))
	if (!owns.ok) error(500, economyConnFailed)
	if (!owns.value && user.permissionLevel < 4)
		error(403, "You do not have permission to update this page.")

	return id
}

export const actions: Actions = {}
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
		void sharp(await icon.arrayBuffer())
			.resize(270, 270)
			.avif({ effort: 9 }) // not awaited, so this'll happen in the background (takes a sec or 2)
			.toFile(`../data/icons/${id}.avif`) // also errors aren't caught but whatever
	}

	await db.query(updateSettingsQuery, {
		description: filter(description || ""),
		name: filter(name),
		place: Record("place", id),
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

	await db.update(Record("place", id)).merge(form.data)

	// engine / port settings changed, so any running server for this place is now
	// invalid (wrong 2013/2016 flow, wrong bind port etc.) - shut it down
	const res = await closeGameserver(e.fetch, id)
	if (!res.ok)
		console.error("Failed to close active server for place", id, res.msg)

	return message(form, "Network settings updated successfully!")
}
actions.privacy = async e => {
	const id = await getData(e)
	const form = await superValidate(e.request, arktype(privacySchema))
	if (!form.valid) return formError(form)

	const { privateServer } = form.data

	await db.update(Record("place", id)).merge({ privateServer })
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
