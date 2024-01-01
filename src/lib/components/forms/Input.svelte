<script lang="ts">
	import type { HTMLInputTypeAttribute } from "svelte/elements"
	import SubInput from "./SubInput.svelte"

	export let name: string
	export let label = ""
	export let help = ""
	export let after = ""
	export let type: HTMLInputTypeAttribute = "text"

	export let inline = false
	export let formData: any
	const { form, errors, constraints } = formData
</script>

<div
	class="{inline ? 'inline' : 'flex'} flex-wrap {inline ? 'flex-1' : 'pb-8'}">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class="w-max {label ? 'md:w-3/4' : ''} {$$restProps.mainclass || ''}">
		<!-- welp, boilerplate begets boilerplate -->
		{#if after}
			<div class="flex items-center">
				<SubInput {...$$restProps} {name} {type} {inline} {formData} />
				{@html after}
			</div>
		{:else}
			<SubInput {...$$restProps} {name} {type} {inline} {formData} />
		{/if}

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
