import { dbQuery } from "#lib/server/db/query.ts"
import accountRegisteredQuery from "./accountRegistered.surql"

const accountRegistered = async () => {
	const [registered] = await dbQuery<boolean[]>(accountRegisteredQuery)
	return registered
}

export default accountRegistered
