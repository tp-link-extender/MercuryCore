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
