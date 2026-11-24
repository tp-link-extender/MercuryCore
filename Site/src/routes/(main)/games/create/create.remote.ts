import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createPlace } from "economy/api"
import { User } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import filter from "#lib/server/filter.ts"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "#lib/typeTests.ts"
import { encode } from "#lib/urlName.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import clientVersions from "./clientVersions"
import createQuery from "./create.surql"

const schema = type({
	clientVersion: type.enumerated(...clientVersions).configure({
		problem: "must be a valid client version",
	}),
	description: "string <= 1000",
	maxPlayers: maxPlayersTest.default(10),
	name: "3 <= string <= 50",
	"privateServer?": "boolean",
	serverAddress: serverAddressTest,
	// eh, works well enough and the built-in z.string().url() requires a protocol
	serverPort: serverPortTest.default(53640),
})

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async (
		{
			serverAddress,
			serverPort,
			maxPlayers,
			clientVersion,
			privateServer,
			name,
			description,
		},
		issues
	) => {
		const { fetch: f, locals } = getRequestEvent()
		const { user } = await authorise(locals)

		const nname = name.trim()
		if (!nname) return issues.name("Place must have a name")
		const ndescription = description.trim()
		if (!ndescription)
			return issues.description("Place must have a description")

		const u = new User(user.id)
		const created = await createPlace(f, u)
		if (!created.ok) return issues("failed to create place")

		const id = created.value.ID

		await dbQuery(createQuery, {
			clientVersion: Number(clientVersion),
			description: filter(description),
			id,
			maxPlayers,
			name: filter(nname),
			privateServer,
			serverAddress,
			serverPort,
		})

		redirect(302, `/place/${id}/${encode(nname)}`)
	}
)
