import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { hashRecoveryToken } from "$lib/server/recoveryToken"
import { db, type RecordId } from "$lib/server/surreal"
import { arktype, message, superValidate } from "$lib/server/validate"
import type { Actions, PageServerLoadEvent } from "./$types"
import checkQuery from "./check.surql"
import consumeQuery from "./consume.surql"
import resetQuery from "./reset.surql"

const schema = type({
	cnpassword: "16 <= string <= 6969",
	npassword: "16 <= string <= 6969",
})

// The token is in the URL, so keep it out of caches and Referer headers
const headers = Object.freeze({
	"Cache-Control": "no-store",
	"Referrer-Policy": "no-referrer",
})

// Only checks the token, without using it up, as email link scanners and previews will open the link before the user does
export async function load({ params, setHeaders }: PageServerLoadEvent) {
	setHeaders(headers)

	const [valid] = await db.query<boolean[]>(checkQuery, {
		hash: hashRecoveryToken(params.token),
	})

	return { form: await superValidate(arktype(schema)), valid }
}

export const actions: Actions = {}
actions.default = async ({ cookies, params, request, setHeaders }) => {
	setHeaders(headers)

	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { npassword, cnpassword } = form.data
	form.data.npassword = ""
	form.data.cnpassword = ""

	if (npassword !== cnpassword)
		return formError(
			form,
			["npassword", "cnpassword"],
			[" ", "Passwords do not match"]
		)

	// Use up the token before hashing the password, so requests without a valid token can't make the server do expensive work
	const [user] = await db.query<(RecordId<"user"> | undefined)[]>(
		consumeQuery,
		{ hash: hashRecoveryToken(params.token) }
	)
	if (!user)
		return message(
			form,
			"This recovery link is invalid or has expired. Request a new one to try again.",
			{ status: 400 }
		)

	await db.query(resetQuery, {
		hashedPassword: await Bun.password.hash(npassword),
		user,
	})
	cookies.set(cookieName, await createSession(user), cookieOptions)

	redirect(302, "/home")
}
