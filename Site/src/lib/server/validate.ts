// I know barrel files suck but I'd like to wrap these functions in the near future

import type { ActionFailure } from "@sveltejs/kit"
import {
	type ErrorStatus,
	message as ogMessage,
	type SuperValidated,
} from "sveltekit-superforms"

export { arktype } from "sveltekit-superforms/adapters"
export {
	message,
	type SuperValidated,
	superValidate,
} from "sveltekit-superforms/server"

export function errMessage<
	M,
	T extends Record<string, unknown> = Record<string, unknown>,
	In extends Record<string, unknown> = Record<string, unknown>,
>(
	form: SuperValidated<T, M, In>,
	message: M,
	options?: {
		status?: ErrorStatus
		removeFiles?: boolean
	}
):
	| { form: SuperValidated<T, M, In> }
	| ActionFailure<{ form: SuperValidated<T, M, In> }> {
	form.valid = false
	return ogMessage(form, message, options)
}
