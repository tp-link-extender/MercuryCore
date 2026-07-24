import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { createUnlimitedSource } from "economy/api"
import * as Econ from "economy/types"
import types, { typeToNumber } from "$lib/assetTypes"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { db } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import { isXML } from "$lib/server/xml"
import { encode } from "$lib/urlName"
import createQuery from "./create.surql"

const schema = type({
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
	name: "3 <= string <= 50",
	description: "(string <= 1000) | undefined",
	price: "0 <= number.integer <= 999",
	asset: "File",
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
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { data } = form
	const { asset, description, name, price, type: assetType } = data
	form.data.asset = null as unknown as File // make sure to return as a POJO

	// to prevent faces being uploaded as images
	const buf = await asset.arrayBuffer()
	if (assetType === 18 && !isXML(buf))
		return formError(form, ["asset"], ["Face assets must be in XML format"])

	// if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	// if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	const u = new Econ.User(user.id)
	// TODO: allow without requiring currency
	const created = await createUnlimitedSource(f, u)
	if (!created.ok)
		return formError(form, ["other"], ["Failed to create asset source"])

	const id = created.value.ID

	await db.query<string[]>(createQuery, {
		id,
		description,
		name,
		price,
		assetType,
	})

	await Bun.write(`../data/assets/${id}`, buf)

	// we'll just assume it's a model 4 now
	// await requestRender(f, "Model", id)

	redirect(302, `/catalog/${id}/${encode(name)}`)
}
