<script lang="ts">
	import type {
		HTMLInputAttributes,
		HTMLInputTypeAttribute
	} from "svelte/elements"

	const {
		name,
		disabled = false,
		type,
		formData,
		...rest
	}: {
		// Imported into Input.svelte to prevent code duplication
		name: string
		disabled: boolean
		type: HTMLInputTypeAttribute
		formData: import("$lib/validate").SuperForm<any>
	} & HTMLInputAttributes = $props()

	let { form, errors, constraints } = $derived(formData)
</script>

{#if type === "checkbox"}
	<input
		{...rest}
		bind:checked={$form[name]}
		{name}
		id={name}
		type="checkbox"
		{disabled} />
{:else}
	<input
		{...rest}
		bind:value={$form[name]}
		{...$constraints[name]}
		{name}
		id={name}
		{type}
		class={[rest.class, { "is-invalid": $errors[name] }]}
		style={type === "number"
			? "width: 9rem"
			: type === "color"
				? "height: 2.5rem; border-radius: var(--rounding)"
				: type === "date"
					? "width: 11rem"
					: null}
		{disabled} />
{/if}
