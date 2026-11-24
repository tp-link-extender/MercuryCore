import { categoriesOf } from "#lib/server/db/forums.ts"
import exclude from "#lib/server/exclude.ts"

export async function load() {
	exclude("Forum")
	const categories = await categoriesOf()
	return { categories }
}
