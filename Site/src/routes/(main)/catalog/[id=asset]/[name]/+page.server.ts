import { error, redirect } from "@sveltejs/kit"
import { balance, countOwnersOne, ownsOne } from "economy/api"
import { Package as EconPackage, UnlimitedAsset, User } from "economy/types"
import type { Comment } from "$lib/comment"
import { authorise } from "$lib/server/auth"
import { assetOwner, economyConnFailed } from "$lib/server/economy"
import { type PackageItem, packageItems } from "$lib/server/packageItems"
import { db, Record } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import type { RequestEvent } from "./$types"
import assetQuery from "./asset.surql"

interface Asset {
	comments: Comment[]
	created: Date
	description: string
	forSale: boolean
	id: string
	items: PackageItem[]
	name: string
	owned: boolean
	price: number
	sold: number
	type: number
	visibility: string
}

const noTexts = Object.freeze([
	"Cancel",
	"No thanks",
	"I've reconsidered",
	"Not really",
	"Nevermind",
])
const failTexts = Object.freeze(["Bruh", "Okay", "Aight", "Rip", "Aw man..."])

export async function load({ fetch: f, locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const id = Number(params.id)
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
		user: Record("user", user.id),
	})
	if (!asset) error(404, "Not Found")

	// resolve the source's owner to the profile data the page uses
	const ownerResult = await assetOwner(f, id, asset.type)
	if (!ownerResult.ok) {
		console.error("asset owner lookup failed")
		error(500, economyConnFailed)
	}
	const owner = ownerResult.value
	const isOwner = owner?.id === user.id
	// Pending and moderated assets are only shown to their owner and to Catalog Managers and above, so their name and description stay private until approved
	if (asset.visibility !== "Visible" && !isOwner && user.permissionLevel < 3)
		error(404, "Not Found")

	const slug = encode(asset.name)
	if (!couldMatch(asset.name, params.name))
		redirect(302, `/catalog/${id}/${slug}`)

	const u = new User(user.id)
	const b = await balance(f, u)
	if (!b.ok) {
		console.error("balance failed")
		error(500, economyConnFailed)
	}

	// packages are a distinct type in the ledger, so they need their own item to ask about rather than the plain asset ones
	const isPackage = asset.type === 32
	const item = isPackage ? new EconPackage(id) : new UnlimitedAsset(id)

	const owned = await ownsOne(f, u, item)
	if (!owned.ok) {
		console.error("ownsOne failed")
		error(500, economyConnFailed)
	}

	const owners = await countOwnersOne(f, item)
	if (!owners.ok) {
		console.error("countOwnersOne for owners failed")
		error(500, economyConnFailed)
	}

	// what the buyer receives along with the package itself
	const items = isPackage ? await packageItems(f, id, user.id) : []

	return {
		asset: {
			...asset,
			forSale: asset.forSale && asset.type !== 1,
			isOwner,
			items,
			price: BigInt(asset.price),
		},
		balance: b.value,
		failText: failTexts[Math.floor(Math.random() * failTexts.length)],
		noText: noTexts[Math.floor(Math.random() * noTexts.length)],
		owned: owned.value,
		owner,
		slug,
		sold: owners.value,
	}
}
