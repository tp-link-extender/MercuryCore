import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import types, { typeToNumber } from "$lib/assetTypes"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { db, Record } from "$lib/server/surreal"
import createQuery from "./create.surql"

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
	asset: "File",
})

export async function load({ locals }) {
	await authorise(locals, 3)

	return {
		form: await superValidate(arktype(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request }) => {
	const { user } = await authorise(locals, 3)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { data } = form

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

	const { asset, description, name, price, type: assetType } = data
	form.data.asset = null as unknown as File// make sure to return as a POJO

	const [, id] = await db.query<string[]>(createQuery, {
		description,
		name,
		price,
		assetType,
		user: Record("user", user.id),
	})

	await Bun.write(`../data/assets/${id}`, await asset.arrayBuffer())

	// we'll just assume it's a model 4 now
	// await requestRender(f, "Model", id)

	redirect(302, `/catalog/${id}`)
}
