import {
	type Query,
	Surreal,
	RecordId as SurrealRecordId,
	Table,
} from "surrealdb"
import { building } from "$app/environment"
import initQuery from "$lib/server/init.surql"
import logo from "$lib/server/logo" // because this is usually one of the first files loaded
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

export const db = new Surreal({
	codecOptions: {
		// SurrealDB dates would require custom serialisation/transformers, and we don't need the precision they provide
		useNativeDates: true,
	},
})

// Retry queries
const ogq = db.query.bind(db)
const retriable = "This transaction can be retried"

// oof
// also bad types but who cares
db.query = async <R extends unknown[]>(
	query: string,
	bindings?: Record<string, unknown>
): Query<R> => {
	try {
		return await ogq(query, bindings)
	} catch (err) {
		const e = err as Error
		if (!e.message.endsWith(retriable)) throw e
		console.log("Retrying query:", e.message)
	}
	return await db.query(query, bindings)
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
				authentication: {
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
	await db.query(initQuery)
	logo()
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
	place: number
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

export const Asset = new Table("asset")
export const AuditLog = new Table("auditLog")
export const Banner = new Table("banner")
export const Comment = new Table("comment")
export const Created = new Table("created")
export const CreatedAsset = new Table("createdAsset")
export const Dislikes = new Table("dislikes")
export const Follows = new Table("follows")
export const ForumCategory = new Table("forumCategory")
export const Friends = new Table("friends")
export const Group = new Table("group")
export const HasSession = new Table("hasSession")
export const ImageAsset = new Table("imageAsset")
export const In = new Table("in")
export const Likes = new Table("likes")
export const Moderation = new Table("moderation")
export const Notification = new Table("notification")
export const OwnsAsset = new Table("ownsAsset")
export const OwnsGroup = new Table("ownsGroup")
export const OwnsPlace = new Table("ownsPlace")
export const Place = new Table("place")
export const Playing = new Table("playing")
export const Posted = new Table("posted")
export const RecentlyWorn = new Table("recentlyWorn")
export const RegKey = new Table("regKey")
export const Render = new Table("render")
export const Report = new Table("report")
export const Request = new Table("request")
export const Session = new Table("session")
export const Stuff = new Table("stuff")
export const ThumbnailCache = new Table("thumbnailCache")
export const Used = new Table("used")
export const User = new Table("user")
export const Wearing = new Table("wearing")

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
