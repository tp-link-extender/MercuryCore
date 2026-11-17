import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import type { RemoteFormInvalidField } from "$app/server"
import { type } from "arktype"
import { createPackageSource, createUnlimitedSource } from "economy/api"
import { User as EconUser, type UnlimitedSource } from "economy/types"
import { form, getRequestEvent } from "$app/server"
import types, { typeToNumber } from "#lib/assetTypes.ts"
import { authorise } from "#lib/server/auth.ts"
import { formFile } from "#lib/server/formFile.ts"
import requestRender from "#lib/server/requestRender.ts"
import { db } from "#lib/server/surreal.ts"
import { isXML } from "#lib/server/xml.ts"
import { encode } from "#lib/urlName.ts"
import type { ClientForm } from "#lib/validate.ts"
import createQuery from "./create.surql"
import createPackageQuery from "./createPackage.surql"

const packageChildSchema = type({
	"asset?": formFile,
	description: "string <= 1000",
	name: "3 <= string <= 50",
	type: type.enumerated(...Object.values(types)),
})

const schema = type({
	"asset?": formFile,
	"children?": packageChildSchema.array(),
	"description?": "string <= 1000",
	name: "3 <= string <= 50",
	price: "0 <= number.integer <= 999",
	type: type
		.enumerated(...Object.values(types))
		// TODO: compare with the other method in normal creation flow
		.pipe.try(t => {
			const num = typeToNumber[t]
			if (!num) throw new Error("Invalid asset type")
			return num
		})
		.configure({
			problem: "must be a valid asset type",
		}),
})

// an equipped package replaces these slots, so a package can't fight itself
// (hats are the exception, with 3 slots)
const slotTypes = Object.freeze([2, 8, 11, 12, 18, 25, 26, 27, 28, 29, 30, 31])
const slotLimits: Readonly<{ [_: number]: number }> = Object.freeze({
	2: 1,
	8: 3,
	11: 1,
	12: 1,
	18: 1,
	25: 1,
	26: 1,
	27: 1,
	28: 1,
	29: 1,
	30: 1,
	31: 1,
})

interface PackageChild {
	description: string
	file: File
	id: number
	name: string
	type: number
}

export const formData: ClientForm<typeof schema.inferIn> = form(
	schema,
	async (
		{ asset, children = [], description, name, price, type: assetType },
		issues
	) => {
		const { fetch: f, locals } = getRequestEvent()
		const { user } = await authorise(locals, 3)

		// packages are collections of assets, so they need special handling
		if (assetType === typeToNumber.Package)
			return createPackage(
				children,
				{ description, name, price },
				user,
				f,
				issues
			)

		if (!asset || asset.size === 0)
			return issues.asset("You must upload an asset")

		// to prevent faces being uploaded as images
		const buf = await asset.arrayBuffer()
		if (assetType === 18 && !isXML(buf))
			return issues.asset("Face assets must be in XML format")

		const u = new EconUser(user.id)
		// TODO: allow without requiring currency
		const created = await createUnlimitedSource(f, u)
		if (!created.ok) return issues("Failed to create asset source")

		const id = created.value.ID

		await db.query<string[]>(createQuery, {
			assetType,
			description,
			id,
			name,
			price,
		})

		await Bun.write(`../data/assets/${id}`, buf)

		// hats are the only type created here that needs an RCC render, and are
		// rendered as models (same as the manual rerender button)
		if (assetType === 8)
			try {
				await requestRender(f, "Model", id)
			} catch (e) {
				console.error(e)
			}

		redirect(302, `/catalog/${id}`)
	}
)

async function createPackage(
	children: {
		asset?: File
		description: string
		name: string
		type: string
	}[],
	{
		description,
		name,
		price,
	}: {
		description: string | undefined
		name: string
		price: number
	},
	user: { id: string },
	f: typeof globalThis.fetch,
	issues: RemoteFormInvalidField<typeof schema.inferIn>
) {
	const fail = (msg: string) => issues(msg)

	// every asset in a package needs a name, description, type and file
	if (children.length < 2)
		return fail("A package must contain at least 2 assets")

	const validChildren: PackageChild[] = []
	for (const [num, child] of children.entries()) {
		if ((child.description ?? "").length > 1000)
			return fail(
				`Asset #${num + 1} description must be 1000 characters or less`
			)
		const assetType = typeToNumber[child.type]
		if (!assetType)
			return fail(`Asset #${num + 1} must have a valid asset type`)

		const file = child.asset
		if (!file || file.size === 0)
			return fail(`Asset #${num + 1} must have an upload`)
		if (file.size > 20e6)
			return fail(`Asset #${num + 1} must be less than 20MB in size`)

		// to prevent faces being uploaded as images
		const buf = await file.arrayBuffer()
		if (assetType === 18 && !isXML(buf))
			return fail("Face assets must be in XML format")

		validChildren.push({
			description: child.description ?? "",
			file,
			id: 0, // assigned below, from the Economy service
			name: child.name,
			type: assetType,
		})
	}

	// enforce the same slot rules that equipping a package will
	for (const slotType of slotTypes) {
		if (!validChildren.some(c => c.type === slotType)) continue
		const count = validChildren.filter(c => c.type === slotType).length
		if (count > slotLimits[slotType])
			return fail(
				`A package can only contain ${slotLimits[slotType]} ${
					types[slotType].toLowerCase() +
					(slotLimits[slotType] > 1 ? "s" : "")
				}`
			)
	}

	// Asset ids come from the Economy service, so a package's contents are owned there and can only ever be sold as part of the bundle. Every child needs its own unlimited source, and the package needs a package source holding all of them.
	const u = new EconUser(user.id)
	const comps: UnlimitedSource[] = []
	for (const [num, child] of validChildren.entries()) {
		const created = await createUnlimitedSource(f, u)
		if (!created.ok)
			return fail(`Failed to create a source for asset #${num + 1}`)

		comps.push(created.value)
		child.id = created.value.ID
	}

	const createdPackage = await createPackageSource(f, u, comps)
	if (!createdPackage.ok)
		return fail("Failed to create a source for the package")

	const id = createdPackage.value.ID

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	await db.query(createPackageQuery, {
		childRows: validChildren.map(c => ({
			description: [{ text: c.description }],
			forSale: false, // package items are offsale by default
			id: c.id,
			name: c.name,
			price: 0,
			type: c.type,
			visibility: "Visible", // created by catalog managers, immediately visible
		})),
		description,
		id,
		name,
		price,
	})

	await Promise.all(
		validChildren.map(c => Bun.write(`../data/assets/${c.id}`, c.file))
	)

	// only the package itself gets a render; it equips all its children
	// (via api/render/package), same as the manual rerender button
	try {
		await requestRender(f, "Package", id)
	} catch (e) {
		console.error(e)
	}

	redirect(302, `/catalog/${id}/${encode(name)}`)
}
