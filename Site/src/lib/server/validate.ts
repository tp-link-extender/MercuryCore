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

function typeToConstraints<T extends object>(schema: Type<T>) {
	const constraints: FormConstraints<T> = {}
	// console.log(schema["~standard"].types?.output)
	for (const key in schema) {
		const field = schema[key]
		// const fieldConstraints: { [_: string]: string } = {}
		if (field == null) continue

		// form.type
		// console.log("BEGIN", key)
		// console.log(field)
		// console.log("END", typeof field)
	}

	return {}
}

export async function superValidate<T extends object>(
	request: Request | null,
	schema: Type<T>
): Promise<Form<T>> {
	if (!request) {
		return {
			constraints: typeToConstraints(schema),
			errors: {},
			message: "",
			valid: true,
			data: {} as T,
		}
	}

	return {
		constraints: typeToConstraints(schema),
		errors: {},
		message: "",
		valid: false,
		data: {} as T,
	}
}
