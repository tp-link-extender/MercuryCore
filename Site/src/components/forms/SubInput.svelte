<script lang="ts" generics="T extends RemoteFormInput">
		import type { ClientForm, ExtractId, InputAttributes } from "#lib/validate.ts"

	const {
		name,
		disabled = false,
		type,
		defaultValue,
		formData,
		...rest
	}: {
		// Imported into Input.svelte to prevent code duplication
		name: ExtractId<T>
		disabled: boolean
		defaultValue?: boolean | string
		type:
			| "text"
			| "number"
			| "color"
			| "date"
			| "checkbox"
			| "file"
			| "password"
			| "email"
		formData: Omit<ClientForm<T>, "for">
	} & InputAttributes = $props()

	type AsField = (
		type: string,
		value?: boolean | string
	) => InputAttributes

	const field = $derived(formData.fields[name])
	// as() takes a literal input type, and this component's type is a union, so the call is typed loosely here. Email fields are text to the form, and the type attribute is set below
	const attrs = $derived(
		(field.as as AsField).call(
			field,
			type === "email" ? "text" : type,
			defaultValue
		)
	)
</script>

{#if type === "checkbox"}
	<input
		{...attrs}
		{...rest}
		id={name}
		type="checkbox"
		{disabled} />
{:else}
	<input
		{...attrs}
		{...rest}
		id={name}
		{type}
		style={type === "number"
			? "width: 9rem"
			: type === "color"
				? "height: 2.5rem; border-radius: var(--rounding)"
				: type === "date"
					? "width: 11rem"
					: null}
		{disabled} />
{/if}
