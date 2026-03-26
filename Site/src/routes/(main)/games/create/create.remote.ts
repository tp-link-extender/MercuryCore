import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
// import { createPlace, getPlacePrice } from "$lib/server/economy"
import filter from "$lib/server/filter"
import { randomAssetId } from "$lib/server/id"
import { db, Record } from "$lib/server/surreal"
import {
	maxPlayersTest,
	serverAddressTest,
	serverPortTest,
} from "$lib/typeTests"
import { encode } from "$lib/urlName"
import type { ClientForm } from "$lib/validate"
import countQuery from "./count.surql"
import createQuery from "./create.surql"

const schema = type({
	name: "3 <= string <= 50",
	description: "string <= 1000",
	serverAddress: serverAddressTest,
	// eh, works well enough and the built-in z.string().url() requires a protocol
	serverPort: serverPortTest.default(53640),
	maxPlayers: maxPlayersTest.default(10),
	"privateServer?": "boolean",
})

async function placeCount(id: string) {
	const [[count]] = await db.query<number[][]>(countQuery, {
		user: Record("user", id),
	})
	return count
}

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async (
		{
			serverAddress,
			serverPort,
			maxPlayers,
			privateServer,
			name,
			description,
		},
		issues
	) => {
		const { locals } = getRequestEvent()
		const { user } = await authorise(locals)

		const nname = name.trim()
		if (!nname) return issues.name("Place must have a name")
		const ndescription = description.trim()
		if (!ndescription)
			return issues.description("Place must have a description")
		if ((await placeCount(user.id)) >= 2)
			return issues("You can't have more than two places")

		const slug = encode(nname)
		const id = randomAssetId() // listen, this still isn't great, but whatever atp

		// const created = await createPlace(f, user.id, id, name, slug)
		// if (!created.ok) return formError(form, ["other"], [created.msg])

		await db.query(createQuery, {
			id,
			user: Record("user", user.id),
			name: filter(nname),
			description: filter(description),
			serverAddress,
			serverPort,
			privateServer,
			maxPlayers,
		})

		redirect(302, `/place/${id}/${slug}`)
	}
)
