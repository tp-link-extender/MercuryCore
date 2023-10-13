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

export async function squery(query: string, params?: { [k: string]: any }) {
	return (await db.query(query, params))[0].result
}

// I'll rename this later I promise
export async function multiSquery(
	query: string,
	params?: { [k: string]: any },
) {
	const result = await db.query(query, params)
	return result.map(v => v.result)
}
