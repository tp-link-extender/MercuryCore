import { building } from "$app/environment"
import initQuery from "$lib/server/init.surql"
import logo from "$lib/server/logo"
import { error } from "@sveltejs/kit"
import { RecordId, Surreal } from "surrealdb"
import idQuery from "./id.surql"

export const db = new Surreal()

export const version = db.version.bind(db)

const realUrl = new URL("ws://localhost:8000")

async function reconnect() {
	try {
		await db.close() // doesn't do anything if not connected
		console.log("connecting")
		await db.connect(realUrl, {
			namespace: "main",
			database: "main",
			auth: {
				username: "root",
				password: "root",
			},
		})
		console.log("reloaded", await version())
		logo()
	} catch (e) {
		console.error(e)
		error(500, "Failed to reconnect to database")
	}
}

export type { RecordId } from "surrealdb"

type RecordIdTypes = {
	asset: number
	assetCache: [number, number]
	assetComment: string
	auditLog: string
	banner: string
	created: string
	createdAsset: string
	dislikes: string
	follows: string
	forumCategory: string
	forumPost: string
	forumReply: string
	friends: string
	group: string
	hasSession: string
	imageAsset: string
	in: string
	likes: string
	moderation: string
	notification: string
	owns: string
	place: number
	playing: string
	posted: string
	recentlyWorn: string
	regKey: string
	render: string
	replyToAsset: string
	replyToComment: string
	replyToPost: string
	replyToReply: string
	report: string
	request: string
	session: string
	statusPost: string
	stuff: string
	thumbnailCache: number
	used: string
	user: string
	wearing: string
}

/**
 * Returns a record id object for a given table and id.
 * @param table The table to get the record id for.
 * @param id The id of the record.
 * @returns a Record object.
 */
export const Record = <T extends keyof RecordIdTypes>(
	table: T,
	id: RecordIdTypes[T]
) => new RecordId(table, id)

if (!building) {
	await reconnect()
	await db.query(initQuery)
}

/**
 * Finds whether a record exists in the database.
 * @param id The id of the record to find.
 * @returns Whether the record exists.
 * @example
 * await find("user:1")
 */
export async function find<T extends keyof RecordIdTypes>(
	table: T,
	id: RecordIdTypes[T]
) {
	const [result] = await db.query<boolean[]>("!!SELECT 1 FROM $thing", {
		thing: Record(table, id),
	})
	return result
}

/**
 * Finds whether a record exists in the database matching a given condition.
 * @param table The table to search in.
 * @param where The condition to match.
 * @param params An object of parameters to pass to SurrealDB.
 * @returns Whether the record exists.
 * @example
 * await findWhere("user", "username = $username", { username: "Heliodex" })
 */
export async function findWhere(
	table: keyof RecordIdTypes,
	where: string,
	params?: { [k: string]: unknown }
) {
	const [res] = await db.query<boolean[]>(
		`!!SELECT 1 FROM type::table($table) WHERE ${where}`,
		{ ...params, table }
	)
	return res
}

export async function incrementId() {
	const [id] = await db.query<number[]>(idQuery)
	return id.toString(36)
}
