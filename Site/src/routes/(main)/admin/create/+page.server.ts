import fs from "node:fs"
import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { db, Record } from "$lib/server/surreal"
import createQuery from "./create.surql"

const schema = type({
	type: type.enumerated(1, 2, 3, 4, 5, 8, 10, 11, 12, 13, 16, 17, 18, 19, 24, 25, 26, 27, 28, 29, 30, 31, 32, 35, 37, 38, 42).configure({
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
	const {user} = await authorise(locals, 3)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { data } = form

	if (!fs.existsSync("../data/assets")) fs.mkdirSync("../data/assets")
	if (!fs.existsSync("../data/thumbnails")) fs.mkdirSync("../data/thumbnails")

		console.log(data)

	const { description, name, price, type: assetType } = data
	const [, id] = await db.query<string[]>(createQuery, {
		description,
		name,
		price,
		assetType,
		user: Record("user", user.id),
	})

	await Bun.write(`../data/assets/${id}`, await data.asset.arrayBuffer())

	// we'll just assume it's a model 4 now
	// await requestRender("Model", id)

	redirect(302, `/catalog/${id}`)
}
