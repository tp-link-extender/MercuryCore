import { redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { cookieName, cookieOptions, createSession } from "$lib/server/auth"
import formError from "$lib/server/formError"
import { db, type RecordId } from "$lib/server/surreal"
import findUserQuery from "./findUser.surql"

const schema = type({
	code: "6 <= string <= 6",
	npassword: "16 <= string <= 6969",
	cnpassword: "16 <= string <= 6969",
})

export const load = async () => ({ form: await superValidate(arktype(schema)) })

export const actions: import("./$types").Actions = {}
actions.default = async ({ cookies, request }) => {
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { code, npassword, cnpassword } = form.data
	form.data.npassword = form.data.cnpassword = ""

	if (npassword !== cnpassword)
		return formError(
			form,
			["npassword", "cnpassword"],
			[" ", "Passwords do not match"]
		)

	const [, userR] = await db.query<RecordId<"user">[]>(findUserQuery, {
		code,
	})
	if (!userR) return formError(form, ["code"], ["Invalid recovery code"])

	await db.merge(userR, { hashedPassword: Bun.password.hashSync(npassword) })
	cookies.set(cookieName, await createSession(userR), cookieOptions)

	redirect(302, "/home")
}
