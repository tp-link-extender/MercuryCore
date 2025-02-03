// Returns a custom error for a superForm

import { fail } from "@sveltejs/kit"
import type { SuperValidated } from "sveltekit-superforms"

/**
 * Returns a custom error for a superForm.
 * @param form A superForm validation object.
 * @param field An array of the names of fields that are incorrect.
 * @param message An array of error messages to display.
 * @returns A fail object with the modified superForm object.
 * @example
 * return formError(form, ["password"], ["Username or password is incorrect"])
 */
export default (
	form: SuperValidated<
		{ [k: string]: unknown },
		unknown,
		{ [k: string]: unknown }
	>,
	fields?: string[],
	messages?: string[]
) => {
	form.valid = false
	if (fields && messages && fields.length > 0 && messages.length > 0)
		// add field and message to the errors object
		for (let i = 0; i < fields.length; i++)
			form.errors[fields[i]] = [messages[i]]

	return fail(400, { form })
}
