import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import types, { typeToNumber } from "$lib/assetTypes"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { randomAssetId } from "$lib/server/id"
import requestRender from "$lib/server/requestRender"
import { db, Record } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import { isXML } from "$lib/server/xml.js"
import createQuery from "./create.surql"
import createPackageQuery from "./createPackage.surql"

const schema = type({
	type: type
		.enumerated(...Object.values(types))
		.pipe.try(t => {
			const num = typeToNumber[t]
			if (!num) throw new Error("Invalid asset type")
			return num
		})
		.configure({
			problem: "must be a valid asset type",
		}),
	name: "3 <= string <= 50",
	description: "(string <= 1000) | undefined",
	price: "0 <= number.integer <= 999",
	asset: "File | undefined",
})

const packageSchema = type({
	name: "3 <= string <= 50",
	description: "(string <= 1000) | undefined",
	price: "0 <= number.integer <= 999",
})

// an equipped package replaces these slots, so a package can't fight itself
// (hats are the exception, with 3 slots)
const slotTypes = Object.freeze([2, 8, 11, 12, 18, 25, 26, 27, 28, 29, 30, 31])
const slotLimits = Object.freeze({
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

export async function load({ locals }) {
	await authorise(locals, 3)

	return {
		form: await superValidate(arktype(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ fetch: f, locals, request }) => {
	const { user } = await authorise(locals, 3)
	const formData = await request.formData()

	// packages are collections of assets, so they need special handling
	if (formData.get("type") === "Package") return createPackage(formData, user, f)

	const form = await superValidate(formData, arktype(schema))
	if (!form.valid) return formError(form)

	const { data } = form
	const { asset, description, name, price, type: assetType } = data
	form.data.asset = null as unknown as File // make sure to return as a POJO

	if (!(asset instanceof File) || asset.size === 0)
		return formError(form, ["asset"], ["You must upload an asset"])

	// to prevent faces being uploaded as images
	const buf = await asset.arrayBuffer()
	if (assetType === 18 && !isXML(buf))
		return formError(form, ["asset"], ["Face assets must be in XML format"])

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	const [, id] = await db.query<string[]>(createQuery, {
		description,
		name,
		price,
		assetType,
		user: Record("user", user.id),
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

type PackageChild = {
	id: number
	description: string
	name: string
	type: number
	file: File
}

async function createPackage(
	formData: FormData,
	user: User,
	f: typeof globalThis.fetch
) {
	const form = await superValidate(formData, arktype(packageSchema))
	const fail = (msg: string) => formError(form, ["other"], [msg])
	if (!form.valid) return formError(form)

	const { description, name, price } = form.data

	const names = (formData.getAll("childName") as FormDataEntryValue[]).map(
		String
	)
	const descriptions = (
		formData.getAll("childDescription") as FormDataEntryValue[]
	).map(String)
	const typeNames = (
		formData.getAll("childType") as FormDataEntryValue[]
	).map(String)
	const files = formData.getAll("childAsset") as File[]

	// every asset in a package needs a name, description, type and file
	if (names.length < 2)
		return fail("A package must contain at least 2 assets")
	if (
		names.length !== descriptions.length ||
		names.length !== typeNames.length ||
		names.length !== files.length
	)
		return fail("Package contents must be complete")

	const children: PackageChild[] = []
	for (const [num, name] of names.entries()) {
		if (name.length < 3 || name.length > 50)
			return fail(
				`Asset #${num + 1} name must be between 3 and 50 characters`
			)
		if ((descriptions[num] ?? "").length > 1000)
			return fail(
				`Asset #${num + 1} description must be 1000 characters or less`
			)
		const assetType = typeToNumber[typeNames[num]]
		if (!assetType)
			return fail(`Asset #${num + 1} must have a valid asset type`)

		const file = files[num]
		if (!(file instanceof File) || file.size === 0)
			return fail(`Asset #${num + 1} must have an upload`)
		if (file.size > 20e6)
			return fail(`Asset #${num + 1} must be less than 20MB in size`)

		// to prevent faces being uploaded as images
		const buf = await file.arrayBuffer()
		if (assetType === 18 && !isXML(buf))
			return fail("Face assets must be in XML format")

		children.push({
			id: randomAssetId(),
			description: descriptions[num] ?? "",
			name,
			type: assetType,
			file,
		})
	}

	// enforce the same slot rules that equipping a package will
	for (const slotType of slotTypes) {
		if (!children.some(c => c.type === slotType)) continue
		const count = children.filter(c => c.type === slotType).length
		if (count > slotLimits[slotType])
			return fail(
				`A package can only contain ${slotLimits[slotType]} ${
					types[slotType].toLowerCase() +
					(slotLimits[slotType] > 1 ? "s" : "")
				}`
			)
	}

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	const id = randomAssetId()
	await db.query(createPackageQuery, {
		childRecords: children.map(c => Record("asset", c.id)),
		childRows: children.map(c => ({
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
		pkgRecord: Record("asset", id),
		price,
		user: Record("user", user.id),
	})

	await Promise.all(
		children.map(c => Bun.write(`../data/assets/${c.id}`, c.file))
	)

	// only the package itself gets a render; it equips all its children
	// (via api/render/package), same as the manual rerender button
	try {
		await requestRender(f, "Package", id)
	} catch (e) {
		console.error(e)
	}

	redirect(302, `/catalog/${id}`)
}
