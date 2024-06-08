import { building } from "$app/environment"
import { type PreparedQuery, RecordId, Surreal, surql } from "surrealdb.js"
import auditLogQuery from "./auditLog.surql"
import initQuery from "./init.surql"
import CustomHttpEngine from "./surrealEngine.ts"
import transactionQuery from "./transaction.surql"

const db = new Surreal({ engines: { http: CustomHttpEngine } })

async function reconnect() {
	await db.close() // doesn't do anything if not connected
	console.log("connecting")
	await db.connect("http://localhost:8000", {
		// namespace and database are configured in the engine
		auth: { username: "root", password: "root" },
	})
	console.log("reloaded", await db.version())
}

export const failed = "The query was not executed due to a failed transaction"

export { surql, RecordId }

type Prepared = PreparedQuery<(result: unknown[]) => unknown>

const stupidError =
	"The query was not executed due to a failed transaction. There was a problem with a datastore transaction: Resource busy: "
const sessionError =
	"There was a problem with the database: The session has expired"

async function fixError<T>(q: () => Promise<T>) {
	// WORST
	// DATABASE
	// ISSUE
	// EVER
	for (let i = 1; i <= 3; i++) {
		try {
			return await q()
		} catch (err) {
			const e = err as Error
			if (e.message === sessionError) await reconnect()
			else if (e.message !== stupidError) throw new Error(e.message)
		}
		console.log(`retrying query ${i} time${i > 1 ? "s" : ""}`)
	}
	return undefined as unknown as T
}

/**
 * Executes a query in SurrealDB and returns its results. Errors if the query failed.
 * @param query The query to execute.
 * @param bindings An object of parameters to pass to SurrealDB.
 * @returns the result of the query. Errors if unsuccessful.
 */
export const equery = async <T>(
	query: string | Promise<string> | Prepared,
	bindings?: { [k: string]: unknown }
): Promise<T> =>
	await fixError(async () => {
		const result = await db.query_raw(await query, bindings)
		const final: unknown[] = []

		for (const res of result) {
			if (res.status === "ERR" && res.result !== failed)
				throw new Error(res.result)
			final.push(res.result)
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
export const find = (table: string, id: string | number) =>
	equery(
		surql`!!SELECT 1 FROM ${new RecordId(table, id)}`
	) as unknown as Promise<boolean>

/**
 * Finds whether a record exists in the database matching a given condition.
 * @param table The table to search in.
 * @param where The condition to match.
 * @param params An object of parameters to pass to SurrealDB.
 * @returns Whether the record exists.
 * @example
 * await findWhere("user", surql`username = $username`, { username: "Heliodex" })
 */
export const findWhere = async (
	table: string,
	where: string,
	params?: { [k: string]: unknown }
) =>
	(
		await equery<boolean[]>(
			`!!SELECT 1 FROM type::table($table) WHERE ${where}`,
			{ ...params, table }
		)
	)[0]

const errorRegex = /An error occurred: (.*)/
/**
 * Returns an error if the query failed.
 * @param qResult The result of a query.
 * @example
 * try {
 * 	result = await query(surql`SELECT * FROM user WHERE username = "Heliodex"`)
 * } catch (err) {
 * 	const e = err as Error
 * 	getError(e.message)
 * }
 */
export function getError(qResult: unknown) {
	let res: unknown[] = qResult as unknown[]
	if (!Array.isArray(res)) res = [qResult]

	for (const result of res)
		if (result === failed || length === 1)
			// Every other result will be `failed` if the query failed
			for (const result2 of res)
				if (typeof result2 === "string" && result2 !== failed)
					return result2.match(errorRegex)?.[1]
}

/**
 * Transfers currency from one user to another, and creates a transaction in the database.
 * @param sender An object containing the id or number of the user sending the currency.
 * @param receiver An object containing the id or number of the user receiving the currency.
 * @param amountSent The amount of currency to send.
 * @param notelink An object containing a note for the transaction, as well as a link to what the transaction was for if possible.
 * @example
 * await transaction(user, { number: 1 }, 10, {
 * 	note: `Bought item ${name}`,
 * 	link: `/avatarshop/${id}/${name}`,
 * })
 */
export async function transaction(
	sender: { id?: string; number?: number },
	receiver: { id?: string; number?: number },
	amountSent: number,
	{ note, link }: { note?: string; link?: string }
) {
	const qResult = await equery<
		| string[]
		| {
				amountSent: number
				taxRate: number
				note: string
				link: string
				time: string
		  }[]
	>(transactionQuery, {
		...(sender?.number
			? { senderNumber: sender.number }
			: sender?.id
				? { senderId: new RecordId("user", sender.id) }
				: {}),
		...(receiver?.number
			? { receiverNumber: receiver.number }
			: receiver?.id
				? { receiverId: new RecordId("user", receiver.id) }
				: {}),
		amountSent,
		note,
		link,
	})

	// todo test dis it might be broke
	const e = getError(qResult)
	if (e) throw new Error(e)
}

export enum Action {
	Account = "Account",
	Administration = "Administration",
	Moderation = "Moderation",
	Economy = "Economy",
}

/**
 * Creates a new audit log in the database.
 * @param action The category of the action that was taken
 * @param note The note to be added to the audit log
 * @param userId The id of the user who took the action
 */
export async function auditLog(action: Action, note: string, userId: string) {
	await equery(auditLogQuery, {
		action,
		note,
		user: new RecordId("user", userId),
	})
}
