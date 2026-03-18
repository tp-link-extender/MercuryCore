// client version of $lib/server/validate

export type { SuperForm } from "sveltekit-superforms/client"

type FormErrors<T> = { [K in keyof T]?: string[] }

export type Form<T> = {
	valid: boolean
	errors: FormErrors<T>
	data: T
}

export type ClientForm<T> = {
	valid: boolean
	errors: FormErrors<T>
	data: T

	capture: () => Form<T>
	restore: (v: Form<T>) => void
}

const capture = <T>(form: ClientForm<T>): Form<T> => ({
	valid: form.valid,
	errors: form.errors,
	data: form.data,
})

export function superForm<T>(form: Form<T>): ClientForm<T> {
	return {
		...form,
		capture() {
			return capture(this)
		},
		restore(v: Form<T>) {
			this.valid = v.valid
			this.errors = v.errors
			this.data = v.data
		},
	}
}
