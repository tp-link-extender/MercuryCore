<script lang="ts" generics="T extends RemoteFormInput">
	import type {
		HTMLInputAttributes,
		HTMLInputTypeAttribute
	} from "svelte/elements"
	import SubInput from "$components/forms/SubInput.svelte"
	import type { ClientForm, ExtractId } from "$lib/validate"

	const {
		name,
		label = "",
		help = "",
		after = "",
		type = "text",
		inline = false,
		column = false,
		disabled = false,
		formData,
		...rest
	}: {
		name: ExtractId<T>
		label?: string
		help?: string
		after?: string
		type?: HTMLInputTypeAttribute
		inline?: boolean
		column?: boolean
		disabled?: boolean
		formData: ClientForm<T>
	} & HTMLInputAttributes = $props()

	let issues = $derived(formData.fields[name]?.issues() || [])
</script>

{#snippet subinput()}
	<SubInput {name} {type} {disabled} {formData} {...rest} />
{/snippet}

<div class="flex flex-wrap {inline ? 'flex-1' : 'pb-8'}">
	{#if label}
		<label for={name} class={["w-full", { "md:w-1/4": !column }]}>
			{label}
		</label>
	{/if}
	<div class={["w-full", { "md:w-3/4": label && !column }]}>
		<!-- welp, boilerplate begets boilerplate -->
		{#if after}
			<div class="flex items-center">
				{@render subinput()}
				{@html after}
			</div>
		{:else}
			{@render subinput()}
		{/if}

		{#if help}
			<small class="formhelp">
				{@html help}
			</small>
		{/if}

		{#each issues as issue}
			<small class="block text-red-500">
				{issue.message}
			</small>
		{/each}
	</div>
</div>
