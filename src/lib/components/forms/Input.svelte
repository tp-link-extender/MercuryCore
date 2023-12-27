<script lang="ts">
	import type { HTMLInputTypeAttribute } from "svelte/elements"

	export let name: string
	export let description: string
	export let placeholder: string
	export let type: HTMLInputTypeAttribute = "text"

	export let formData: any
	const { form, errors, constraints } = formData
</script>

<div {...$$restProps} class="flex flex-wrap pb-4">
	<label for={name} class="w-full md:w-1/4">
		{description}
	</label>
	<div class="w-full md:w-3/4">
		<input
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{...{ type /* lmfao */ }}
			{placeholder}
			class="form-control {$errors[name] ? 'is-in' : ''}valid" />

		<small class="pb-4 text-danger">
			{$errors[name] || ""}
		</small>
	</div>
</div>
