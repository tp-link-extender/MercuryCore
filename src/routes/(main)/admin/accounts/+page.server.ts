import { authorise } from "$lib/server/lucia"
import { query, surql, auditLog, Action } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { Scrypt } from "oslo/password"
import { z } from "zod"

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

	return {
		form: await superValidate(zod(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.changePassword = async ({ request, locals, getClientAddress }) => {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const limit = ratelimit(form, "resetPassword", getClientAddress, 30)
	if (limit) return limit

	const { username, password } = form.data

	try {
		await query(
			surql`
				UPDATE user SET hashedPassword = $npassword
				WHERE string::lowercase(username) = string::lowercase($username)`,
			{
				username,
				npassword: await new Scrypt().hash(password),
			}
		)
	} catch {
		return message(form, "Invalid credentials", {
			status: 400,
		})
	}

	await auditLog(
		Action.Account,
		`Change account password for ${username}`,
		user.id
	)

	return message(form, "Password changed successfully!")
}
