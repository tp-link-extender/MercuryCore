import { type } from "arktype"
import { ThrownError } from "surrealdb"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import {
	arktype,
	errMessage,
	message,
	superValidate,
} from "$lib/server/validate"
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
		form: await superValidate(null, arktype(schema)),
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
		const [, ok] = await db.query<boolean[]>(updatePasswordQuery, {
			npassword: Bun.password.hashSync(password),
			username: username,
		})
		if (!ok) return errMessage(form, "No user found with given username")
	} catch (e) {
		console.error(e)
		return errMessage(form, "An error occurred")
	}

	await db.run("fn::auditLog", [
		"Account",
		`Change account password for ${username}`,
		Record("user", user.id),
	])

	return message(form, "Password changed successfully!")
}
