import { error } from "@sveltejs/kit"
import { inventory } from "economy/api"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import { toRecordIds } from "$lib/server/economy"
import { db, Record } from "$lib/server/surreal"
import inventoryQuery from "./inventory.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
}

type Inventory = {}

export async function load({ fetch: f, locals, url }) {
	const { user } = await authorise(locals)

	const u = new Econ.User(user.id)
	const inv = await inventory(f, u)
	if (!inv.ok) error(500, "Failed to fetch inventory")

	const invKVs = toRecordIds([...inv.value.One])

	const [assets] = await db.query<[Inventory]>(inventoryQuery, {
		user: Record("user", user.id),
		inv: invKVs,
	})

	return { assets }
}
