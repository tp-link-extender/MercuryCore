import { building } from "$app/environment"
import { Surreal } from "surrealdb.js"

const db = new Surreal()

async function reconnect() {
	await db.close()
	console.log("connecting")
	await db.connect("http://localhost:8000/rpc")
	console.log("connected")
	await db.signin({
		username: "root",
		password: "root",
	})

	await db.use({
		namespace: "main",
		database: "main",
	})

	console.log("reloaded surreal")
}

if (!building) await reconnect()

// Probably the most referenced function in Mercury
/**
 * Surreal template tag. No it's not injection-safe, we're not Next.js.
 * @param statement The statement to execute as a template literal.
 * @param substitutions The substitutions made into the template literal.
 * @returns The statement with the substitutions made.
 * @example
 * query(surql`SELECT * FROM user WHERE username = "Heliodex"`)
 */
export const surql = (
	statement: TemplateStringsArray,
	...substitutions: string[]
) =>
	statement.raw.reduce((query, part, index) => {
		// Add the current part of the statement to the query
		let newQuery = query + part

		// If there is a substitution at this index, add it
		if (index < substitutions.length) newQuery += substitutions[index]

		return newQuery
	}, "")

if (!building) await db.query((await import("./init.surql")).default)

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

type Param = string | number | boolean | null | object | Date | undefined // basically anything
type Input = string | Promise<{ default: string }>

const getInput = async (input: Input) =>
	typeof input === "string" ? input : (await input).default

/**
 * Executes a query in SurrealDB and returns its results.
 * @param input The surql query to execute.
 * @param params An object of parameters to pass to SurrealDB.
 * @returns The result of the first query given.
 * @example
 * await query<{ email: string }>(
 * 	surql`SELECT email FROM user WHERE username = $username`,
 * 	{ username: "Heliodex" }
 * ) // [{ email: heli@odex.cf }] - return an array for this query
 */
export const query = <T>(
	input: Input,
	params?: { [k: string]: Param }
): Promise<T[]> =>
	fixError(
		async () => (await db.query(await getInput(input), params))?.[0] as T[]
	)

/**
 * Executes a query in SurrealDB and returns the first item in its results.
 * @param input The surql query to execute.
 * @param params An object of parameters to pass to SurrealDB.
 * @returns The first item in the array returned by the first query.
 * @example
 * await squery<{ email: string }>(
 * 	surql`SELECT email FROM user WHERE username = $username`,
 * 	{ username: "Heliodex" }
 * ) // { email: heli@odex.cf } - returns an object for this query
 */
export const squery = <T>(input: Input, params?: { [k: string]: Param }) =>
	fixError(
		async () =>
			((await db.query(await getInput(input), params))?.[0] as T[])[0]
	)

/**
 * Executes multiple queries in SurrealDB and returns their results.
 * @param input The surql query to execute.
 * @param params An object of parameters to pass to SurrealDB.
 * @returns The result of all queries given.
 * @example
 * await mquery<{ email: string }>(
 * 	surql`
 * 		LET $username = "Heliodex";
 * 		SELECT email FROM user WHERE username = $username`
 * ) // [null, [{ email: heli@odex.cf }]] - returns an array with an element for each query
 */
export const mquery = <T>(input: Input, params?: { [k: string]: Param }) =>
	fixError(async () => (await db.query(await getInput(input), params)) as T)

/**
 * Finds whether a record exists in the database.
 * @param id The id of the record to find.
 * @returns Whether the record exists.
 * @example
 * await find("user:1")
 */
export const find = (id: string) =>
	query(surql`!!SELECT 1 FROM $id`, { id }) as unknown as Promise<boolean>

/**
 * Finds whether a record exists in the database matching a given condition.
 * @param table The table to search in.
 * @param where The condition to match.
 * @param params An object of parameters to pass to SurrealDB.
 * @returns Whether the record exists.
 * @example
 * await findWhere("user", surql`username = $username`, { username: "Heliodex" })
 */
export const findWhere = (
	table: string,
	where: string,
	params?: { [k: string]: Param }
) =>
	query(surql`!!SELECT 1 FROM type::table($table) WHERE ${where}`, {
		...params,
		table,
	}) as unknown as Promise<boolean>

export const listenLive = db.listenLive

export const failed = "The query was not executed due to a failed transaction"

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
		if (result === failed || res.length === 1)
			// Every other result will be `failed` if the query failed
			for (const result2 of res)
				if (typeof result2 === "string" && result2 !== failed)
					return result2.match(/An error occurred: (.*)/)?.[1]
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
	const qResult = await mquery<
		| string[]
		| {
				amountSent: number
				taxRate: number
				note: string
				link: string
				time: string
		  }[]
	>(import("./transaction.surql"), {
		...(sender?.number
			? { senderNumber: sender.number }
			: { senderId: `user:${sender.id}` }),
		...(receiver?.number
			? { receiverNumber: receiver.number }
			: { receiverId: `user:${receiver.id}` }),
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
	await query(import("./auditLog.surql"), {
		action,
		note,
		user: `user:${userId}`,
	})
}
