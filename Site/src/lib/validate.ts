// client version of $lib/server/validate

import type {
	RemoteForm,
	RemoteFormInput,
	ValidationError,
} from "@sveltejs/kit"

export type { SuperForm } from "sveltekit-superforms/client"

type FormErrors<T> = { [K in keyof T]?: string[] }

type FormConstraints<T> = { [K in keyof T]?: { [_: string]: string } }

type BaseForm<T> = {
	constraints: FormConstraints<T>
	errors: FormErrors<T>
	message: string
	valid: boolean
}

export interface Form<T extends object> extends BaseForm<T> {
	data: T
}

// export interface ClientForm<T extends object> extends BaseForm<T> {
// 	form: T
// 	enhance: (e: HTMLFormElement) => unknown
// 	delayed: boolean
// 	capture: () => Form<T>
// 	restore: (v: Form<T>) => void
// }

export type ClientForm<T extends RemoteFormInput> = RemoteForm<
	T,
	ValidationError["issues"][number] | { success: string }
>

export type ExtractId<Input> = Input extends { id: infer Id }
	? Id extends string | number
		? Id
		: string | number
	: string | number

// const capture = <T extends RemoteFormInput>(form: ClientForm<T>): Form<T> => ({
// 	valid: form.valid,
// 	errors: form.errors,
// 	data: form.data,
// })

// export function superForm<T extends RemoteFormInput>(
// 	form: Form<T>
// ): ClientForm<T> {
// 	return {
// 		constraints: form.constraints,
// 		errors: form.errors,
// 		message: form.message,
// 		valid: form.valid,
// 		form: form.data,
// 		capture() {
// 			return capture(this)
// 		},
// 		restore(v: Form<T>) {
// 			this.data = v.data
// 			this.errors = v.errors
// 			this.message = v.message
// 			this.valid = v.valid
// 		},
// 	}
// }
