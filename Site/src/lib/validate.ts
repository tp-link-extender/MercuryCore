// biome-ignore-all lint/suspicious/noExplicitAny: form components are schema-agnostic, so their fields can't be typed ahead of use

// Types for the remote form functions used across the Site

import type { ValidationError } from "@sveltejs/kit"
import type { HTMLInputAttributes } from "svelte/elements"
import type { RemoteForm, RemoteFormInput } from "$app/server"

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

// A form's result is its success message or a validation issue, so only read success from a result that has one
export const successOf = (result: unknown): string | undefined =>
	typeof result === "object" &&
	result !== null &&
	"success" in result &&
	typeof result.success === "string"
		? result.success
		: undefined

// Svelte allows null in input attributes, which the input elements reject
export type InputAttributes = {
	[K in keyof Omit<HTMLInputAttributes, "children" | "size">]?: Exclude<
		HTMLInputAttributes[K],
		null
	>
}
