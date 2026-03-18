<script lang="ts" generics="T extends object">
	import type {
		HTMLInputAttributes,
		HTMLInputTypeAttribute
	} from "svelte/elements"
	import SubInput from "$components/forms/SubInput.svelte"
	import type { ClientForm } from "$lib/validate"

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
		name: keyof T
		label?: string
		help?: string
		after?: string
		type?: HTMLInputTypeAttribute
		inline?: boolean
		column?: boolean
		disabled?: boolean
		formData: ClientForm<T>
	} & HTMLInputAttributes = $props()

	let { errors } = $derived(formData)
</script>

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
				<SubInput {...rest} {name} {type} {disabled} {formData} />
				{@html after}
			</div>
		{:else}
			<SubInput {...rest} {name} {type} {disabled} {formData} />
		{/if}

		{#if help}
			<small class="formhelp">
				{@html help}
			</small>
		{/if}

		{#if errors[name]}
			<small class="block text-red-500">
				{errors[name]}
			</small>
		{/if}
	</div>
</div>
