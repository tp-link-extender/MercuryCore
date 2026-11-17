import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import config from "#lib/server/config.ts"
import { sendEmail } from "#lib/server/email.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import {
	createRecoveryToken,
	hashRecoveryToken,
} from "#lib/server/recoveryToken.ts"
import { db } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
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

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ email }, issues) => {
		const { getClientAddress } = getRequestEvent()

		const limit = ratelimitRemote(issues, "recover", getClientAddress, 30)
		if (limit) return limit

		const token = createRecoveryToken()

		// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- query returns [let, if, exists]
		const [, , exists] = await db.query<boolean[]>(recoveryQuery, {
			email,
			hash: hashRecoveryToken(token),
		})

		// Not awaited, so the response time doesn't reveal whether an email address is registered
		if (exists) sendRecoveryEmail(email, token).catch(logSendError)

		return {
			success:
				"If an account uses this email address, we've sent it a link to reset your password. The link is valid for 1 hour.",
		}
	}
)
