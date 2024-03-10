import { building } from "$app/environment"
import { Surreal } from "surrealdb.js"

const db = new Surreal()

if (!building) {
	await db.connect("http://localhost:8000/rpc")
	await db.signin({
		username: "root",
		password: "root",
	})

	await db.use({
		namespace: "main",
		database: "main",
	})

	console.log("loaded surreal")
}

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

if (!building)
	await db.query(surql`
		DEFINE TABLE stuff SCHEMALESS;

		DEFINE TABLE user SCHEMALESS;
		DEFINE INDEX usernameI ON TABLE user COLUMNS username UNIQUE;
		DEFINE INDEX numberI ON TABLE user COLUMNS number UNIQUE;
		DEFINE INDEX emailI ON TABLE user COLUMNS email UNIQUE;

		DEFINE FUNCTION fn::id() {
			RETURN function((UPDATE ONLY stuff:increment SET ids += 1).ids) {
				return arguments[0].toString(36) // jar var script in muh dayta bayse
			}
		}`)

const stupidError =
	"The query was not executed due to a failed transaction. There was a problem with a datastore transaction: Resource busy: "

type Param = string | number | boolean | null | object | Date | undefined // basically anything

/**
 * Executes a query in SurrealDB and returns its results.
 * @param input The surql query to execute.
 * @param params An array of variables to pass to SurrealDB.
 * @returns The result of the first query given.
 * @example
 * await query<{ email: string }>(
 * 	surql`SELECT email FROM user WHERE username = $username`,
 * 	{ username: "Heliodex" }
 * ) // [{ email: heli@odex.cf }] - return an array for this query
 */
export const query = async <T>(
	input: string,
	params?: { [k: string]: Param }
): Promise<T[]> => {
	// WORST
	// DATABASE
	// ISSUE
	// EVER
	for (let i = 1; i <= 3; i++) {
		try {
			return (await db.query(input, params))?.[0] as T[]
		} catch (err) {
			const e = err as Error
			if (e.message !== stupidError) throw new Error(e.message)
		}
		console.log(`retrying query ${i} time${i > 1 ? "s" : ""}`)
	}
	return undefined as unknown as T[]
}
/**
 * Executes a query in SurrealDB and returns the first item in its results.
 * @param input The surql query to execute.
 * @param params An array of variables to pass to SurrealDB.
 * @returns The first item in the array returned by the first query.
 * @example
 * await squery<{ email: string }>(
 * 	surql`SELECT email FROM user WHERE username = $username`,
 * 	{ username: "Heliodex" }
 * ) // { email: heli@odex.cf } - returns an object for this query
 */
export const squery = async <T>(
	input: string,
	params?: { [k: string]: Param }
) => ((await db.query(input, params))?.[0] as T[])[0]

/**
 * Executes multiple queries in SurrealDB and returns their results.
 * @param input The surql query to execute.
 * @param params An array of variables to pass to SurrealDB.
 * @returns The result of all queries given.
 * @example
 * await mquery<{ email: string }>(
 * 	surql`
 * 		LET $username = "Heliodex";
 * 		SELECT email FROM user WHERE username = $username`
 * ) // [null, [{ email: heli@odex.cf }]] - returns an array with an element for each query
 */
export const mquery = async <T>(
	input: string,
	params?: { [k: string]: Param }
) => (await db.query(input, params)) as T

const failed = "The query was not executed due to a failed transaction"
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
	>(
		surql`
			BEGIN TRANSACTION; # lmfao

			LET $taxRate = stuff:economy.taxRate OR 30;

			LET $sender = (SELECT id, currency, number FROM user
			WHERE number = $senderNumber OR id = $senderId)[0];
			IF !$sender {
				THROW "Sender not found"
			};

			LET $receiver = (SELECT id, currency, number FROM user
			WHERE number = $receiverNumber OR id = $receiverId)[0];
			IF !$receiver {
				THROW "Receiver not found"
			};

			LET $senderAdmin = $sender.number == 1;
			LET $receiverAdmin = $receiver.number == 1;

			IF $amountSent > 0 {
				IF !$senderAdmin AND $sender.currency < $amountSent {
					THROW string::concat("Insufficient funds: You need ", $amountSent - $sender.currency, " more to buy this")
				};

				LET $finalAmount = math::round($amountSent * (1 - $taxRate / 100));

				UPDATE $sender SET currency -=
					IF $senderAdmin THEN 0 ELSE $amountSent END;

				UPDATE $receiver SET currency +=
					IF $receiverAdmin THEN 0 ELSE $finalAmount END;
			};

			RELATE $sender->transaction->$receiver CONTENT {
				amountSent: $amountSent,
				taxRate: $taxRate,
				note: $note,
				link: $link,
				time: time::now(),
			};

			COMMIT TRANSACTION`,
		{
			...(sender?.number
				? { senderNumber: sender.number }
				: { senderId: `user:${sender.id}` }),
			...(receiver?.number
				? { receiverNumber: receiver.number }
				: { receiverId: `user:${receiver.id}` }),
			amountSent,
			note,
			link,
		}
	)

	for (const result of qResult)
		if (result === failed)
			for (const result2 of qResult)
				if (typeof result2 === "string" && result2 !== failed)
					throw new Error(
						result2.match(/An error occurred: (.*)/)?.[1]
					)
}
