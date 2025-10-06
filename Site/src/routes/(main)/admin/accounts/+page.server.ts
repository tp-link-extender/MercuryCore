import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import { usernameTest } from "$lib/typeTests"
import updatePasswordQuery from "./updatePassword.surql"
import usersQuery from "./users.surql"

const schema = type({
	username: usernameTest,
	password: "1 <= string <= 6969",
})

export async function load({ locals }) {
	await authorise(locals, 5)

	const [users] = await db.query<BasicUser[][]>(usersQuery)

	return {
		form: await superValidate(arktype(schema)),
		users,
	}
}

export const actions: import("./$types").Actions = {}
actions.changePassword = async ({ locals, request, getClientAddress }) => {
	const { user } = await authorise(locals, 5)
	const form = await superValidate(request, arktype(schema))
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
