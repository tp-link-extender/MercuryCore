// The friends, followers, and following pages for a user.

import { error } from "@sveltejs/kit"
import {
	type Relation,
	relationOf,
	userRecordOf,
} from "#lib/server/db/social.ts"
import type { PageServerLoadEvent } from "./$types"

const relations = new Set<string>(["followers", "following", "friends"])

// Checked against a list, as an object's own keys would also match inherited ones such as constructor
const isRelation = (type: string): type is Relation => relations.has(type)

export async function load({ params }: PageServerLoadEvent) {
	const type = params.f
	if (!isRelation(type)) error(404, "Not Found")
	const user = await userRecordOf(params.username)
	if (!user) error(404, "Not Found")

	const { count, users } = await relationOf(type, user)

	return {
		...params,
		count,
		f: type,
		users,
	}
}
