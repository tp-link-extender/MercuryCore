<script lang="ts">
	import type {
		HTMLInputAttributes,
		HTMLInputTypeAttribute
	} from "svelte/elements"

	const {
		name,
		type,
		formData,
		...rest
	}: {
		// Imported into Input.svelte to prevent code duplication
		name: string
		type: HTMLInputTypeAttribute
		formData: import("sveltekit-superforms").SuperForm<any>
	} & HTMLInputAttributes = $props()
	const { form, errors, constraints } = formData
</script>

{#if type === "checkbox"}
	<input
		{...rest}
		bind:checked={$form[name]}
		{name}
		id={name}
		type="checkbox" />
{:else}
	<input
		{...rest}
		bind:value={$form[name]}
		{...$constraints[name]}
		{name}
		id={name}
		{type}
		class={{ "is-invalid": $errors[name] }}
		style={type === "number"
			? "width: 9rem"
			: type === "color"
				? "height: 2.5rem; border-radius: var(--rounding)"
				: type === "date"
					? "width: 11rem"
					: null} />
{/if}
