import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { dev } from "$app/environment"
import config from "$lib/server/config"
import { sendEmail } from "$lib/server/email"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
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

// don't await because if it blocks then a user could tell whether a given email is registered or not
const sendRecoveryEmail = (email: string, code: string) =>
	sendEmail(
		email,
		`${config.Name} - Account recovery`,
		`We received a request to recover your ${config.Name} account. Enter the recovery code below on https://${config.Domain}/recover/code to reset your password. This code is valid for 24 hours, or until you recover your account, whichever is sooner.

${code}

If you did not request this code, please ignore this email.

${config.Name}
https://${config.Domain}`
	)

export const load = async () => ({ form: await superValidate(arktype(schema)) })

export const actions: import("./$types").Actions = {}
actions.default = async ({ cookies, request, getClientAddress }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const limit = ratelimit(form, "recover", getClientAddress, 30)
	if (limit) return limit

	const { email } = form.data
	cookies.set("recoverEmail", email, cookieOptions)

	const [, id, code] = await db.query<string[]>(recoveryQuery, { email })
	if (id && code) sendRecoveryEmail(email, code)

	redirect(302, "/recover/code")
}
