// biome-ignore-all lint/suspicious/noExplicitAny: form components are schema-agnostic, so their fields can't be typed ahead of use

// client version of $lib/server/validate

import type {
	RemoteForm,
	RemoteFormInput,
	ValidationError,
} from "@sveltejs/kit"
import type { SuperForm } from "sveltekit-superforms/client"

export type DynamicSuperForm =
	// oxlint-disable-next-line typescript/no-explicit-any
	SuperForm<any>

export type { SuperForm } from "sveltekit-superforms/client"
export { superForm } from "sveltekit-superforms/client"

type FormErrors<T> = { [K in keyof T]?: string[] }

type FormConstraints<T> = { [K in keyof T]?: { [_: string]: string } }

interface BaseForm<T> {
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
	// Issue | { success: string }
>

export type ExtractId<Input> = Input extends { id: infer Id }
	? Id extends string | number
		? Id
		: string | number
	: string | number
