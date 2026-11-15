import { type } from "arktype"
import config from "$lib/server/config"
import { sendEmail } from "$lib/server/email"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import {
	createRecoveryToken,
	hashRecoveryToken,
} from "$lib/server/recoveryToken"
import { db } from "$lib/server/surreal"
import { arktype, message, superValidate } from "$lib/server/validate"
import type { Actions } from "./$types"
import recoveryQuery from "./recovery.surql"

const schema = type({
	// TODO: work when emails are turned off
	email: type(/^.+@.+$/).configure({
		problem: "must be a valid RFC-5321 email address",
	}),
})

const sendRecoveryEmail = (email: string, token: string) =>
	sendEmail(
		email,
		`${config.Name} - Account recovery`,
		`We received a request to recover your ${config.Name} account. Open the link below to reset your password. This link is valid for 1 hour, and can only be used once.

https://${config.Domain}/recover/${token}

If you did not request this, please ignore this email. Your password will not be changed.

${config.Name}
https://${config.Domain}`
	)

// Nodemailer's error messages can include the recipient's address (for example "Recipient address rejected: ..."), so only the error codes are logged
function logSendError(err: unknown): void {
	const { code, responseCode } = (err ?? {}) as {
		code?: string
		responseCode?: number
	}
	console.error(
		`Failed to send recovery email (code ${code ?? "unknown"}, SMTP response ${responseCode ?? "none"})`
	)
}

export const load = async () => ({ form: await superValidate(arktype(schema)) })

export const actions: Actions = {}
actions.default = async ({ request, getClientAddress }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const limit = ratelimit(form, "recover", getClientAddress, 30)
	if (limit) return limit

	const { email } = form.data
	const token = createRecoveryToken()

	// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- query returns [let, if, exists]
	const [, , exists] = await db.query<boolean[]>(recoveryQuery, {
		email,
		hash: hashRecoveryToken(token),
	})

	// Not awaited, so the response time doesn't reveal whether an email address is registered
	if (exists) sendRecoveryEmail(email, token).catch(logSendError)

	return message(
		form,
		"If an account uses this email address, we've sent it a link to reset your password. The link is valid for 1 hour."
	)
}
