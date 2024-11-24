import { db } from "$lib/server/surreal"
import accountRegisteredQuery from "./accountRegistered.surql"

export default async () => {
	const [registered] = await db.query<boolean[]>(accountRegisteredQuery)
	return registered
}
