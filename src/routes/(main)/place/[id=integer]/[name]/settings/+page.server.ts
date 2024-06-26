import fs from "node:fs"
import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import { error } from "@sveltejs/kit"
import sharp from "sharp"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types.d.ts"
import settingsQuery from "./settings.surql"
import updateSettingsQuery from "./updateSettings.surql"

const viewSchema = z.object({
	title: z.string().max(100),
	icon: z.any().optional(),
	description: z.string().max(1000).optional(),
})
const networkSchema = z.object({
	serverIP: z
		.string()
		.max(100)
		.regex(
			/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
		),
	serverPort: z.number().int().min(1024).max(65535),
	maxPlayers: z.number().int().min(1).max(100),
})
const ticketSchema = z.object({})
const privacySchema = z.object({
	privateServer: z.boolean(),
})
const privatelinkSchema = z.object({})

type Place = {
	created: string
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
	serverIP: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: string
}

async function placeQuery(id: number) {
	const [[place]] = await equery<Place[][]>(settingsQuery, {
		place: Record("place", id), // MAKE SURE ID IS A NUMBER
	})
	return place
}

export async function load({ locals, params }) {
	const getPlace = await placeQuery(+params.id)
	if (!getPlace) error(404, "Place not found")

	const { user } = await authorise(locals)

	if (user.number !== getPlace.owner.number && user.permissionLevel < 4)
		error(403, "You do not have permission to view this page.")

	return {
		...getPlace,
		slug: encode(getPlace.name),
		viewForm: await superValidate(zod(viewSchema)),
		networkForm: await superValidate(zod(networkSchema)),
		ticketForm: await superValidate(zod(ticketSchema)),
		privacyForm: await superValidate(zod(privacySchema)),
		privatelinkForm: await superValidate(zod(privatelinkSchema)),
	}
}

async function getData(e: RequestEvent) {
	const id = +e.params.id
	const { user } = await authorise(e.locals)
	const getPlace = await placeQuery(id)

	if (user.number !== getPlace.owner.number && user.permissionLevel < 4)
		error(403, "You do not have permission to update this page.")

	return id
}

export const actions: import("./$types").Actions = {}
actions.view = async e => {
	const id = await getData(e)
	const { request } = e

	const formData = await request.formData()
	const form = await superValidate(formData, zod(viewSchema))
	if (!form.valid) return formError(form)

	const icon = formData.get("icon") as File

	if (icon && icon.size > 0) {
		if (icon.size > 1e6)
			return formError(
				form,
				["icon"],
				["Icon must be less than 1MB in size"]
			)

		if (!fs.existsSync("data/icons")) fs.mkdirSync("data/icons")
		sharp(await icon.arrayBuffer())
			.resize(270, 270)
			.toFile(`data/icons/${id}.webp`)
			.catch(() => formError(form, ["icon"], ["Icon failed to upload"]))
	}

	const { title, description } = form.data

	await equery(updateSettingsQuery, {
		place: Record("place", id),
		title,
		description: description || "",
	})

	return message(form, "View settings updated successfully!")
}
actions.ticket = async e => {
	const id = await getData(e)
	const { request } = e

	await equery(surql`UPDATE $place SET serverTicket = rand::guid()`, {
		place: Record("place", id),
	})

	return message(
		await superValidate(request, zod(ticketSchema)),
		"Regenerated!"
	)
}
actions.network = async e => {
	const id = await getData(e)
	const { request } = e

	const form = await superValidate(request, zod(networkSchema))
	if (!form.valid) return formError(form)

	const { serverIP, serverPort, maxPlayers } = form.data

	await equery(
		surql`
			UPDATE ${Record("place", id)} MERGE {
				serverIP: ${serverIP},
				serverPort: ${serverPort},
				maxPlayers: ${maxPlayers},
			}`
	)

	return message(form, "Network settings updated successfully!")
}
actions.privacy = async e => {
	const id = await getData(e)
	const { request } = e

	const form = await superValidate(request, zod(privacySchema))
	if (!form.valid) return formError(form)

	const { privateServer } = form.data

	await equery(surql`UPDATE $place SET privateServer = ${privateServer}`, {
		place: Record("place", id),
	})

	return message(form, "Privacy settings updated successfully!")
}
actions.privatelink = async e => {
	const id = await getData(e)
	const { url, request } = e

	await equery(surql`UPDATE $place SET privateTicket = rand::guid()`, {
		place: Record("place", id),
	})

	return message(
		await superValidate(request, zod(privatelinkSchema)),
		"Regenerated!"
	)
}
