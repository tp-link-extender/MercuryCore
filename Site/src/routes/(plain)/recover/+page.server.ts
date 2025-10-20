import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { dev } from "$app/environment"
import config from "$lib/server/config"
import { sendEmail } from "$lib/server/email"
import formError from "$lib/server/formError"
import { db } from "$lib/server/surreal"
import recoveryQuery from "./recovery.surql"

const schema = type({
	// TODO: work when emails are turned off
	email: type(/^.+@.+$/).configure({
		problem: "must be a valid RFC-5321 email address",
	}),
})

const cookieOptions = Object.freeze({
	secure: !dev,
	maxAge: 24 * 60 * 60, // 1 day
	path: "", // only this route and /recover/code
})

function sendRecoveryEmail(email: string, code: string) {
	console.log(`Sending recovery email to ${email} with code ${code}`)

	// not awaited because if it blocks then a user could tell whether a given email is registered or not
	sendEmail(
		email,
		`${config.Name} - Account recovery`,
		`We received a request to recover your ${config.Name} account. Use the recovery code below to proceed:

${code}

If you did not request this code, please ignore this email.

${config.Name}
https://${config.Domain}`
	)
}

export const load = async () => ({ form: await superValidate(arktype(schema)) })

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, cookies }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { email } = form.data
	cookies.set("recoverEmail", email, cookieOptions)

	const [, id, code] = await db.query<string[]>(recoveryQuery, { email })
	if (id && code) sendRecoveryEmail(email, code)

	redirect(302, "/recover/code")
}
