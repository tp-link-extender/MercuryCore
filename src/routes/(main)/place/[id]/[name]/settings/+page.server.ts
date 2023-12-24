import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { error } from "@sveltejs/kit"
import fs from "fs"
import sharp from "sharp"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"
import type { RequestEvent } from "./$types"

const schemas = {
	view: z.object({
		title: z.string().max(100),
		icon: z.any(),
		description: z.string().max(1000).optional(),
	}),
	network: z.object({
		serverIP: z
			.string()
			.max(100)
			.regex(
				/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
			),
		serverPort: z.number().int().min(1024).max(65535),
		maxPlayers: z.number().int().min(1).max(100),
	}),
	ticket: z.object({}),
	privacy: z.object({
		privateServer: z.boolean(),
	}),
	privatelink: z.object({}),
}

type Place = {
	created: string
	deleted: boolean
	description: {
		text: string
		updated: string
	}
	id: string
	maxPlayers: number
	name: string
	owner: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	privateServer: boolean
	privateTicket: string
	serverIP: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: string
}

const placeQuery = async (id: string | number) =>
	await squery<Place>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, status, username
				FROM <-owns<-user)[0] AS owner,
				(SELECT text, updated FROM $parent.description
				ORDER BY updated DESC)[0] AS description
			FROM $place`,
		{ place: `place:${id}` }
	)

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id)) error(400, `Invalid game id: ${params.id}`)

	const getPlace = await placeQuery(params.id)
	if (!getPlace) error(404, "Place not found")

	const { user } = await authorise(locals)

	if (user.number != getPlace.owner.number && user.permissionLevel < 4)
		error(403, "You do not have permission to view this page.")

	return {
		...getPlace,
		viewForm: await superValidate(schemas.view),
		networkForm: await superValidate(schemas.network),
		ticketForm: await superValidate(schemas.ticket),
		privacyForm: await superValidate(schemas.privacy),
		privatelinkForm: await superValidate(schemas.privatelink),
	}
}

async function getData(e: RequestEvent) {
	if (!/^\d+$/.test(e.params.id || ""))
		error(400, `Invalid game id: ${e.params.id}`)
	const id = parseInt(e.params.id || ""),
		{ user } = await authorise(e.locals),
		getPlace = await placeQuery(e.params.id)

	if (user.number != getPlace.owner.number && user.permissionLevel < 4)
		error(403, "You do not have permission to update this page.")

	return id
}

export const actions = {
	view: async e => {
		const id = await getData(e),
			{ request } = e

		const formData = await request.formData(),
			form = await superValidate(formData, schemas.view)
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
				.catch(() =>
					formError(form, ["icon"], ["Icon failed to upload"])
				)
		}

		const { title, description } = form.data

		await query(
			surql`
				LET $og = SELECT
					title,
					(SELECT text, updated FROM $parent.description
					ORDER BY updated DESC)[0] AS description
				FROM $place;

				UPDATE $place SET name = $title;

				IF $og.description.text != $description {
					UPDATE $place SET description += {
						text: $description,
						updated: time::now(),
					};
				}`,
			{
				place: `place:${id}`,
				title,
				description: description || "",
			}
		)

		return message(form, "View settings updated successfully!")
	},
	ticket: async e => {
		const id = await getData(e),
			{ request } = e

		await query(surql`UPDATE $place SET serverTicket = rand::guid()`, {
			place: `place:${id}`,
		})

		return message(
			await superValidate(request, schemas.ticket),
			"Regenerated!"
		)
	},
	network: async e => {
		const id = await getData(e),
			{ request } = e

		const form = await superValidate(request, schemas.network)
		if (!form.valid) return formError(form)

		const { serverIP, serverPort, maxPlayers } = form.data

		await query(
			surql`
				UPDATE $place MERGE {
					serverIP: $serverIP,
					serverPort: $serverPort,
					maxPlayers: $maxPlayers,
				}`,
			{
				place: `place:${id}`,
				serverIP,
				serverPort,
				maxPlayers,
			}
		)

		return message(form, "Network settings updated successfully!")
	},
	privacy: async e => {
		const id = await getData(e),
			{ request } = e

		const form = await superValidate(request, schemas.privacy)
		if (!form.valid) return formError(form)

		const { privateServer } = form.data

		await query(surql`UPDATE $place SET privateServer = $privateServer`, {
			place: `place:${id}`,
			privateServer,
		})

		return message(form, "Privacy settings updated successfully!")
	},
	privatelink: async e => {
		const id = await getData(e)
		const { url, request } = e

		await query(surql`UPDATE $place SET privateTicket = rand::guid()`, {
			place: `place:${id}`,
		})

		return message(
			await superValidate(request, schemas.privatelink),
			"Regenerated!"
		)
	},
}
