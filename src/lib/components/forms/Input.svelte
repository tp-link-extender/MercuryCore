<script lang="ts">
	import type { HTMLInputTypeAttribute } from "svelte/elements"

	export let name: string
	export let label = ""
	export let help = ""
	export let type: HTMLInputTypeAttribute = "text"

	export let inline = false
	export let formData: any
	const { form, errors, constraints } = formData
</script>

<div class="flex flex-wrap {inline ? 'flex-1' : 'pb-8'}">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class="w-full {label ? 'md:w-3/4' : ''}">
		<!-- welp, boilerplate begets boilerplate -->
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
				class:rounded-r-0={inline}
				class="form-{type == 'checkbox'
					? 'check-input'
					: type == 'color'
						? ''
						: 'control'} {$errors[name] ? 'is-in' : ''}valid"
				style={type == "number"
					? "width: 9rem"
					: type == "color"
						? "height: 2.5rem; border-radius: 0.375rem"
						: null} />{/if}

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
