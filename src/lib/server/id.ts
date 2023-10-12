import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { customAlphabet } from "nanoid"

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

	while (
		(
			(await squery(surql`SELECT $id AS id FROM stuff:ids`, { id })) as {
				id: boolean
			}[]
		)[0].id
	) {
		id = nanoid()
		console.log("id collision!")
	}
	await squery(surql`UPDATE stuff:ids SET $id = true`, { id })

	return id
}

/**
 * Checks whether an ID is valid, i.e. it is 5 characters long and uses only valid characters.
 * @param id The ID to check whether it is valid or not.
 * @returns A boolean, true if the ID is valid and false if it isn't.
 * @example
 * if (!valid(id)) throw error(400, "Invalid reply id")
 */
export const valid = (id: string) =>
	id.length == 5 && /^[0-9a-zA-Z_]+$/.test(id)
