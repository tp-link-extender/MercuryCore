import { type } from "arktype"
import like from "#lib/server/like/index.ts"
import { Record } from "#lib/server/surreal.ts"
import { form } from "$app/server"
import { findPlace, placeIdSchema } from "./findPlace.ts"

const schema = type({
	action: type.enumerated("like", "unlike", "dislike", "undislike"),
	id: placeIdSchema,
	privateTicket: "string",
})

export const likePlaceForm = form(
	schema,
	async ({ action, id, privateTicket }) => {
		const { placeR, user } = await findPlace(id, privateTicket)
		await like(Record("user", user.id), placeR, action)
	}
)
