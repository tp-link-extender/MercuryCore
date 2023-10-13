import surql from "../surrealtag"
import { Surreal } from "surrealdb.js"

const db = new Surreal()

await db.connect("http://localhost:8000/rpc")
await db.signin({
	user: "root",
	pass: "root",
})

await db.use({
	ns: "main",
	db: "main",
})

console.log("loaded surreal")

export default db

await db.query(surql`
	DEFINE TABLE stuff SCHEMALESS;

	DEFINE TABLE user SCHEMALESS;
	DEFINE INDEX usernameI ON TABLE user COLUMNS username UNIQUE;
	DEFINE INDEX numberI ON TABLE user COLUMNS number UNIQUE;
	DEFINE INDEX emailI ON TABLE user COLUMNS email UNIQUE;

	DEFINE FUNCTION fn::id() {
		RETURN function((UPDATE ONLY stuff:increment SET ids += 1).ids) {
			return arguments[0].toString(36)
		}
	};
`)

/**
 * Executes a query in SurrealDB and returns its results.
 * @param input The surql query to execute.
 * @param params An array of variables to pass to SurrealDB.
 * @returns The result of the first query given.
 */
export const query = async <T>(input: string, params?: { [k: string]: any }) =>
	(await db.query(input, params))[0].result as T[]

/**
 * Executes a query in SurrealDB and returns the first item in its results.
 * @param input The surql query to execute.
 * @param params An array of variables to pass to SurrealDB.
 * @returns The first item in the array returned by the first query.
 */
export const squery = async <T>(input: string, params?: { [k: string]: any }) =>
	(await query<T>(input, params))[0]

/**
 * Executes multiple queries in SurrealDB and returns their results.
 * @param input The surql query to execute.
 * @param params An array of variables to pass to SurrealDB.
 * @returns The result of all queries given.
 */
export const mquery = async <T>(input: string, params?: { [k: string]: any }) =>
	(await db.query(input, params)).map(v => v.result) as T
