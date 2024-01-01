<script lang="ts">
	import type { HTMLInputTypeAttribute } from "svelte/elements"

	// Imported into Input.svelte to prevent code duplication
	export let name: string
	export let type: HTMLInputTypeAttribute

	export let inline = false
	export let formData: any
	const { form, errors, constraints } = formData
</script>

{#if type == "checkbox"}
	<input
		{...$$restProps}
		bind:checked={$form[name]}
		{name}
		id={name}
		type="checkbox"
		class="form-check-input valid"
		style="width: 1.5rem; height: 1.5rem" />
{:else}
	<input
		{...$$restProps}
		bind:value={$form[name]}
		{...$constraints[name]}
		{name}
		id={name}
		{...{ type /* lmfao */ }}
		class="form-{type == 'checkbox'
			? 'check-input'
			: type == 'color'
				? ''
				: 'control'} {$errors[name] ? 'is-in' : ''}valid {inline
			? 'rounded-r-0'
			: // idk y unocss isn't extracting from class: directives
				''}"
		style={type == "number"
			? "width: 9rem"
			: type == "color"
				? "height: 2.5rem; border-radius: 0.375rem"
				: null} />
{/if}
