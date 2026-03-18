import type { ActionFailure } from "@sveltejs/kit"
import type { Type } from "arktype"
import { message as ogMessage, type SuperValidated } from "sveltekit-superforms"
import type { Form } from "$lib/validate"

// export { arktype } from "sveltekit-superforms/adapters"
export {
	message,
	type SuperValidated,
	// superValidate,
} from "sveltekit-superforms/server"

export function errMessage<
	M,
	T extends Record<string, unknown> = Record<string, unknown>,
	In extends Record<string, unknown> = Record<string, unknown>,
>(
	form: SuperValidated<T, M, In>,
	message: M
):
	| { form: SuperValidated<T, M, In> }
	| ActionFailure<{ form: SuperValidated<T, M, In> }> {
	form.valid = false
	return ogMessage(form, message)
}

// lmao it gone
export function arktype<T>(schema: T) {
	return schema
}

export async function superValidate<T extends object>(
	request: Request | null,
	schema: Type<T>
): Promise<Form<T>> {
	if (!request) {
		return {
			valid: true,
			errors: {},
			data: schema as T,
		}
	}

	return {
		valid: false,
		errors: {},
		data: {} as T,
	}
}
