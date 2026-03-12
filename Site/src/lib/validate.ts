// client version of $lib/server/validate

export { type SuperForm, superForm } from "sveltekit-superforms/client"

type FormErrors<T> = { [K in keyof T]?: string[] }

export type Form<T> = {
	valid: boolean
	errors: FormErrors<T>
	data: T
}
