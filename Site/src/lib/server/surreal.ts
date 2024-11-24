import { building } from "$app/environment"
import initQuery from "$lib/server/init.surql"
import logo from "$lib/server/logo"
import { error } from "@sveltejs/kit"
import pc from "picocolors"
import {
	type PreparedQuery,
	type QueryResult,
	RecordId,
	Surreal,
} from "surrealdb"
import idQuery from "./id.surql"

const { green, red } = pc
export const db = new Surreal()

export const version = db.version.bind(db)

const realUrl = new URL("http://localhost:8000")

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

export const failed = "The query was not executed due to a failed transaction"
export const failedConn = "There is no connection available at this moment"

export { surql, RecordId } from "surrealdb"

export type RecordIdTypes = {
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

async function fixError<T>(q: () => Promise<T>) {
	try {
		return await q()
	} catch (err) {
		const e = err as Error
		if (
			!e.message.startsWith(failed) &&
			!e.message.startsWith(failedConn)
		) {
			console.error(e)
			await reconnect()
		}
	}
	return undefined as unknown as T
}

// Make the query error/return/watever more readable, so we can see which are errors and which statement of the query failed
const makeReadable = (r: QueryResult<unknown>) =>
	r.status === "ERR"
		? red(r.result)
		: green(JSON.stringify(r.result, null, 2))

/**
 * Executes a query in SurrealDB and returns its results. Errors if the query failed.
 * @param query The query to execute.
 * @param bindings An object of parameters to pass to SurrealDB.
 * @returns the result of the query. Errors if unsuccessful.
 */
export const equery = async <T>(
	query: string | Promise<string> | PreparedQuery,
	bindings?: { [k: string]: unknown }
): Promise<T> =>
	await fixError(async () => {
		const result = await db.queryRaw(await query, bindings)
		const final: unknown[] = []
		let hasErrors = false

		for (const res of result) {
			if (res.status === "ERR" && !res.result.startsWith(failed))
				hasErrors = true
			final.push(res.result)
		}
		if (hasErrors) {
			const qerrors = result
				// zero indexing booooo (whatevr)
				.map((r, i) => `${i}  ${makeReadable(r)}`)
				.join("\n")
			throw new Error(`Query errors occurred\n${qerrors}`)
		}

		return final as T
	})

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
