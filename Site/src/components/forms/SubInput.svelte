<script lang="ts" generics="T extends RemoteFormInput">
	import type {
		HTMLInputAttributes,
		HTMLInputTypeAttribute
	} from "svelte/elements"
	import type { ClientForm, ExtractId } from "$lib/validate"

	const {
		name,
		disabled = false,
		type,
		formData,
		...rest
	}: {
		// Imported into Input.svelte to prevent code duplication
		name: ExtractId<T>
		disabled: boolean
		type: HTMLInputTypeAttribute
		formData: ClientForm<T>
	} & HTMLInputAttributes = $props()
</script>

{#if type === "checkbox"}
	<input
		{...formData.fields[name].as("checkbox")}
		{...rest}
		{name}
		id={name}
		type="checkbox"
		{disabled} />
{:else}
	<input
		{...formData.fields[name].as("text")}
		{...rest}
		{name}
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
