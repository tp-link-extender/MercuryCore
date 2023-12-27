<script lang="ts">
	import type { HTMLInputTypeAttribute } from "svelte/elements"

	export let name: string
	export let label: string
	export let help = ""
	export let placeholder = ""
	export let type: HTMLInputTypeAttribute = "text"

	export let formData: any
	const { form, errors, constraints } = formData
</script>

<div {...$$restProps} class="flex flex-wrap pb-8">
	<label for={name} class="w-full md:w-1/4">
		{label}
	</label>
	<div class="w-full md:w-3/4">
		<input
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{...{ type /* lmfao */ }}
			{placeholder}
			class="form-{type == 'checkbox'
				? 'check-input'
				: 'control'} {$errors[name] ? 'is-in' : ''}valid"
			style={type == "number"
				? "width: 9rem"
				: type == "checkbox"
					? "width: 1.5rem; height: 1.5rem"
					: null} />

		{#if help}
			<small class="grey-text">
				{help}
			</small>
		{/if}

		<small class="pb-4 text-danger">
			{$errors[name] || ""}
		</small>
	</div>
</div>
