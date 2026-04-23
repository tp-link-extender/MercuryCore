<script lang="ts" generics="T extends RemoteFormInput">
	import type { HTMLTextareaAttributes } from "svelte/elements"
	import type { ClientForm, ExtractId } from "$lib/validate"

	const {
		name,
		label = "",
		help = "",
		placeholder = "",
		rows = 3,
		lowpad = false,
		defaultValue = "",
		formData,
		...rest
	}: {
		name: ExtractId<T>
		label?: string
		help?: string
		placeholder?: string
		rows?: number
		lowpad?: boolean
		defaultValue?: string
		formData: ClientForm<T>
	} & HTMLTextareaAttributes = $props()

	let issues = $derived(formData.fields[name]?.issues() || [])
</script>

<div class="flex flex-wrap {lowpad ? 'pb-4' : 'pb-8'}">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class={["w-full", { "md:w-3/4": label }]}>
		<!-- TODO: prevent tabs in textarea caused by... the formatter.... -->
		<textarea
			{...formData.fields[name].as("text")}
			{...rest}
			{name}
			id={name}
			{rows}
			placeholder={placeholder || null}>
		</textarea>

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
