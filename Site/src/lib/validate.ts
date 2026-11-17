// biome-ignore-all lint/suspicious/noExplicitAny: form components are schema-agnostic, so their fields can't be typed ahead of use

// Types for the remote form functions used across the Site

import type { RemoteForm, RemoteFormInput } from "$app/server"
import type { ValidationError } from "@sveltejs/kit"

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
