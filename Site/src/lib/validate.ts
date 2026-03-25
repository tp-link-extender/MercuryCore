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

type Issue = ValidationError["issues"][number]

export type Issues = (message: string) => Issue

export type ClientForm<T extends RemoteFormInput> = RemoteForm<
	T,
	Issue | { success: string }
>

export type ExtractId<Input> = Input extends { id: infer Id }
	? Id extends string | number
		? Id
		: string | number
	: string | number
