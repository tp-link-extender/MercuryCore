import {
	type Prettify,
	type QueryParameters,
	Surreal,
	RecordId as SurrealRecordId,
} from "surrealdb"
import { building } from "$app/environment"
import initQuery from "$lib/server/init.surql"
import logo from "$lib/server/logo"
import startEconomy from "$lib/server/process/economy"
import startSurreal from "$lib/server/process/surreal"

if (!building) {
	try {
		startSurreal()
	} catch (e) {
		console.log(e)
		console.error(
			"Failed to start SurrealDB. Make sure it is installed and accessible as `surreal`."
		)
		process.exit(1)
	}
	try {
		startEconomy()
	} catch (e) {
		console.log(e)
		console.error(
			"Failed to start the Economy service. Make sure it is built and accessible at Economy/Economy."
		)
		process.exit(1)
	}
}

await new Promise(resolve => setTimeout(resolve, 500))

export const db = new Surreal()

// Retry queries
const ogq = db.query.bind(db)
const retriable = "This transaction can be retried"

// oof
db.query = async <T extends unknown[]>(
	...args: QueryParameters
): Promise<Prettify<T>> => {
	try {
		return (await ogq(...args)) as Prettify<T>
	} catch (err) {
		const e = err as Error
		if (!e.message.endsWith(retriable)) throw e
		console.log("Retrying query:", e.message)
	}
	return await db.query(...args)
}

export const version = db.version.bind(db)

const url = "localhost:8000"
const realUrl = new URL(`ws://${url}`) // must be ws:// to prevent token expiration, http:// will expire after 1 hour by default

async function reconnect() {
	for (let attempt = 0; ; attempt++)
		try {
			await db.close() // doesn't do anything if not connected
			console.log("connecting to database")
			await db.connect(realUrl, {
				namespace: "main",
				database: "main",
				auth: {
					username: "root", // security B)
					password: "root",
				},
			})
			console.log("reloaded", await version())
			break
		} catch (err) {
			const e = err as Error
			console.error("Failed to connect to database:", e.message)
			if (attempt === 4)
				console.log(
					`Multiple connection attempts failed. Make sure the database is running, either locally or in a container, and is accessible at ${url}.`
				)
			console.log("Retrying connection in 1 second...")
			await new Promise(resolve => setTimeout(resolve, 1000))
		}
}

if (!building) {
	await reconnect()
	logo()
	await db.query(initQuery)
}

type RecordIdTypes = {
	asset: number
	auditLog: string
	banner: string
	comment: string
	created: string
	createdAsset: string
	dislikes: string
	follows: string
	forumCategory: string
	friends: string
	group: string
	hasSession: string
	imageAsset: string
	in: string
	likes: string
	moderation: string
	notification: string
	ownsAsset: string
	ownsGroup: string
	ownsPlace: string
	place: string
	playing: string
	posted: string
	recentlyWorn: string
	regKey: string
	render: string
	report: string
	request: string
	session: string
	stuff: string
	thumbnailCache: number
	used: string
	user: string
	wearing: string
}

// Ensure type safety when creating record ids
export type RecordId<T extends keyof RecordIdTypes> = SurrealRecordId<T>

/**
 * Returns a record id object for a given table and id.
 * @param table The table to get the record id for.
 * @param id The id of the record.
 * @returns a Record object.
 */
export const Record = <T extends keyof RecordIdTypes>(
	table: T,
	id: RecordIdTypes[T]
) => new SurrealRecordId(table, id)

/**
 * Finds whether a record exists in the database.
 * @param id The id of the record to find.
 * @returns Whether the record exists.
 * @example
 * await find("user", id)
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
	params?: { [_: string]: unknown }
) {
	const [res] = await db.query<boolean[]>(
		`!!SELECT 1 FROM type::table($table) WHERE ${where}`,
		{ ...params, table }
	)
	return res
}

/**
 * Runs a set of SurrealQL statements against the database.
 * Identical to db.query(), but provides an improved set of error messages for large queries.
 * @param query - Specifies the SurrealQL statements.
 * @param bindings - Assigns variables which can be used in the query.
 */
// export async function bigQuery<T extends unknown[]>(...args: QueryParameters) {
// 	const raw = await db.queryRaw<T>(...args)
// 	const errors = raw.filter(({ status }) => status === "ERR")
// 	if (errors.length > 0) {
// 		const errorMessages = errors
// 			.map(({ result }, i) => `[${i}]: ${result}`)
// 			.join("\n")
// 		throw new Error(`SurrealDB query error:\n${errorMessages}`)
// 	}

// 	return raw.map(({ result }) => result) as T
// }
