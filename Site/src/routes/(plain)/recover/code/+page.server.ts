import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import formError from "$lib/server/formError"

const schema = type({
	code: "6 <= string <= 6",
})

export const load = async () => ({ form: await superValidate(arktype(schema)) })

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	// const { code } = form.data

	// if (user) {
	// }

	// redirect(302, "/recover/code")
}
