<script lang="ts">
	import type { HTMLInputTypeAttribute } from "svelte/elements"

	// Imported into Input.svelte to prevent code duplication
	export let name: string
	export let type: HTMLInputTypeAttribute

	export let formData: any
	const { form, errors, constraints } = formData
</script>

{#if type == "checkbox"}
	<input
		{...$$restProps}
		bind:checked={$form[name]}
		{name}
		id={name}
		type="checkbox" />
{:else}
	<input
		{...$$restProps}
		bind:value={$form[name]}
		{...$constraints[name]}
		{name}
		id={name}
		{...{ type /* lmfao */ }}
		class:is-invalid={$errors[name]}
		style={type == "number"
			? "width: 9rem"
			: type == "color"
				? "height: 2.5rem; border-radius: 0.375rem"
				: null} />
{/if}
