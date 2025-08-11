import { zod4 } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod/v4"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import updatePasswordQuery from "./updatePassword.surql"

const schema = z.object({
	username: z
		.string()
		.min(3)
		.max(21)
		.regex(/^[A-Za-z0-9_]+$/),
	password: z.string().min(1).max(6969),
})

export async function load({ locals }) {
	await authorise(locals, 5)

	return { form: await superValidate(zod4(schema)) }
}

export const actions: import("./$types").Actions = {}
actions.changePassword = async ({ locals, request, getClientAddress }) => {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, zod4(schema))
	if (!form.valid) return formError(form)

	const limit = ratelimit(form, "changePassword", getClientAddress, 30)
	if (limit) return limit

	const { username, password } = form.data
	form.data.password = ""

	try {
		await db.query(updatePasswordQuery, {
			npassword: Bun.password.hashSync(password),
			username: username,
		})
	} catch {
		return message(form, "Invalid credentials", {
			status: 400,
		})
	}

	await db.run("fn::auditLog", [
		"Account",
		`Change account password for ${username}`,
		Record("user", user.id),
	])

	return message(form, "Password changed successfully!")
}
