import { customAlphabet } from "nanoid"
import { client } from "./redis"

const nanoid = customAlphabet(
	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_.~",
	5,
)

/**
 * Generates a guaranteed unique ID.
 * @returns A unique 5-character ID.
 * @example
 * const postId = id()
 */
export default async function () {
	let id = nanoid()

	while (await client.hExists("usedIds", id)) {
		id = nanoid()
		console.log("id collision!")
	}
	await client.hSet("usedIds", id, 1)

	return id
}

export const rollback = async (id: string) => await client.hDel("usedIds", id)
