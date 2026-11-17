import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { Place as EconPlace } from "economy/types"
import sharp from "sharp"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "#lib/server/auth.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import filter from "#lib/server/filter.ts"
import { formFile } from "#lib/server/formFile.ts"
import { closeGameserver } from "#lib/server/orbiter.ts"
import { db, Record } from "#lib/server/surreal.ts"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "#lib/typeTests.ts"
import type { ClientForm } from "#lib/validate.ts"
import clientVersions from "../../../../games/create/clientVersions"
import privacyQuery from "./privacy.surql"
import privateTicketQuery from "./privateTicket.surql"
import serverTicketQuery from "./serverTicket.surql"
import settingsQuery from "./settings.surql"
import updateSettingsQuery from "./updateSettings.surql"

interface Place {
	clientVersion: number
	created: string
	dedicated: boolean
	description: string
	id: string // graah
	maxPlayers: number
	name: string
	privateServer: boolean
	privateTicket: string
	serverAddress: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: Date
}

// Place ids are numbers, so `.for()` instances send a number and the form data has to take it as one
const placeIdSchema = type("string | number").pipe(String)

const viewSchema = type({
	"description?": "string <= 1000",
	"icon?": formFile,
	id: placeIdSchema,
	name: "string <= 100",
})
const networkSchema = type({
	clientVersion: type
		.enumerated(...clientVersions)
		.pipe.try(Number)
		.configure({ problem: "must be a valid client version" }),
	"dedicated?": "boolean",
	id: placeIdSchema,
	maxPlayers: maxPlayersTest,
	serverAddress: serverAddressTest.optional(),
	serverPort: serverPortTest.optional(),
})
const ticketSchema = type({
	id: placeIdSchema,
})
const privacySchema = type({
	id: placeIdSchema,
	"privateServer?": "boolean",
})
const dataSchema = type({
	file: formFile,
	id: placeIdSchema,
})

async function placeQuery(id: number) {
	const [[place]] = await db.query<Place[][]>(settingsQuery, {
		place: Record("place", id),
	})
	return place
}

async function getData(id: string) {
	const { fetch: f, locals } = getRequestEvent()
	const { user } = await authorise(locals)
	const placeId = Number(id)
	const getPlace = await placeQuery(placeId)
	if (!getPlace) error(404, "Place not found")

	const owns = await ownsItem(f, user.id, new EconPlace(placeId))
	if (!owns.ok) error(500, economyConnFailed)
	if (!owns.value && user.permissionLevel < 4)
		error(403, "You do not have permission to update this page.")

	return placeId
}

export const viewForm: ClientForm<typeof viewSchema.inferIn> = form(
	viewSchema,
	async ({ id, name, icon, description }, issues) => {
		const placeId = await getData(id)

		if (icon && icon.size > 0) {
			if (icon.size > 1e6)
				return issues.icon("Icon must be less than 1MB in size")

			if (!fs.existsSync("../data/icons")) fs.mkdirSync("../data/icons")
			void sharp(await icon.arrayBuffer())
				.resize(270, 270)
				.avif({ effort: 9 }) // not awaited, so this'll happen in the background (takes a sec or 2)
				.toFile(`../data/icons/${placeId}.avif`) // also errors aren't caught but whatever
		}

		await db.query(updateSettingsQuery, {
			description: filter(description || ""),
			name: filter(name),
			place: Record("place", placeId),
		})
		return { success: "View settings updated successfully!" }
	}
)

export const ticketForm: ClientForm<typeof ticketSchema.inferIn> = form(
	ticketSchema,
	async ({ id }) => {
		const ticketPlaceId = await getData(id)

		await db.query(serverTicketQuery, {
			place: Record("place", ticketPlaceId),
		})
		return { success: "Regenerated!" }
	}
)

export const networkForm: ClientForm<typeof networkSchema.inferIn> = form(
	networkSchema,
	async ({
		id,
		clientVersion,
		dedicated,
		maxPlayers,
		serverAddress,
		serverPort,
	}) => {
		const placeId = await getData(id)

		await db.update(Record("place", placeId)).merge({
			clientVersion,
			dedicated: Boolean(dedicated),
			maxPlayers,
			serverAddress,
			serverPort,
		})

		// engine / port settings changed, so any running server for this place is now
		// invalid (wrong 2013/2016 flow, wrong bind port etc.) - shut it down
		const { fetch: f } = getRequestEvent()
		const res = await closeGameserver(f, placeId)
		if (!res.ok)
			console.error(
				"Failed to close active server for place",
				placeId,
				res.msg
			)

		return { success: "Network settings updated successfully!" }
	}
)

export const privacyForm: ClientForm<typeof privacySchema.inferIn> = form(
	privacySchema,
	async ({ id, privateServer }) => {
		const placeId = await getData(id)

		await db.query(privacyQuery, {
			place: Record("place", placeId),
			privateServer: Boolean(privateServer),
		})
		return { success: "Privacy settings updated successfully!" }
	}
)

export const privatelinkForm: ClientForm<typeof ticketSchema.inferIn> = form(
	ticketSchema,
	async ({ id }) => {
		const linkPlaceId = await getData(id)

		await db.query(privateTicketQuery, {
			place: Record("place", linkPlaceId),
		})
		return { success: "Regenerated!" }
	}
)

export const dataForm: ClientForm<typeof dataSchema.inferIn> = form(
	dataSchema,
	async ({ id, file }, issues) => {
		const dataPlaceId = await getData(id)

		if (file.size > 100e6)
			return issues.file("File must be less than 100MB in size")

		await Bun.write(`../data/places/${dataPlaceId}`, file)
		return { success: "Place data updated successfully!" }
	}
)
