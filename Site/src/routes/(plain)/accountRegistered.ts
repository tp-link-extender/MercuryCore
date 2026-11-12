import { db } from "$lib/server/surreal"
import accountRegisteredQuery from "./accountRegistered.surql"

const accountRegistered = async () => {
	const [registered] = await db.query<boolean[]>(accountRegisteredQuery)
	return registered
}

export default accountRegistered
