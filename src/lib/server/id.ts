import { customAlphabet } from "nanoid"
import { client } from "./redis"

const nanoid = customAlphabet(
	// Certain characters like ., ~, and - don't play nicely
	// with normal SurrealDB Ids
	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_",
	5,
)

/**
 * Generates a guaranteed unique ID.
 * @returns A unique 5-character ID.
 * @example
 * const postId = await id()
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

/**
 * Checks whether an ID is valid, i.e. it is 5 characters long and uses only valid characters.
 * @param id The ID to check whether it is valid or not.
 * @returns A boolean, true if the ID is valid and false if it isn't.
 * @example
 * if (!valid(id)) throw error(400, "Invalid reply id")
 */
export const valid = (id: string) =>
	id.length == 5 && /^[0-9a-zA-Z_]+$/.test(id)
