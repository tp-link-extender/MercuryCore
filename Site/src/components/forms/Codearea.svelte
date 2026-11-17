<script lang="ts" generics="T extends RemoteFormInput">
	import type { HTMLTextareaAttributes } from "svelte/elements"
	import type { ClientForm, ExtractId } from "#lib/validate.ts"

	const {
		name,
		label = "",
		help = "",
		placeholder = "",
		rows = 3,
		defaultValue = "",
		formData,
		...rest
	}: {
		name: ExtractId<T>
		label?: string
		help?: string
		placeholder?: string
		rows?: number
		defaultValue?: string
		formData: Omit<ClientForm<T>, "for">
	} & HTMLTextareaAttributes = $props()

	let issues = $derived(formData.fields[name]?.issues() || [])
</script>

<div class="flex flex-wrap pb-8">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class={["w-full", { "md:w-3/4": label }]}>
		<textarea
			{...formData.fields[name].as("text", defaultValue)}
			{...rest}
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
