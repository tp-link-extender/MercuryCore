<script lang="ts">
	import SubInput from "$components/forms/SubInput.svelte"
	import type {
		HTMLInputAttributes,
		HTMLInputTypeAttribute
	} from "svelte/elements"

	const {
		name,
		label = "",
		help = "",
		after = "",
		type = "text",
		inline = false,
		column = false,
		formData,
		...rest
	}: {
		name: string
		label?: string
		help?: string
		after?: string
		type?: HTMLInputTypeAttribute
		inline?: boolean
		column?: boolean
		formData: import("sveltekit-superforms").SuperForm<any>
	} & HTMLInputAttributes = $props()

	const { errors } = formData
</script>

<div class="flex flex-wrap {inline ? 'flex-1' : 'pb-8'}">
	{#if label}
		<label for={name} class="w-full {column ? '' : 'md:w-1/4'}">
			{label}
		</label>
	{/if}
	<div class="w-full {label && !column ? 'md:w-3/4' : ''}">
		<!-- welp, boilerplate begets boilerplate -->
		{#if after}
			<div class="flex items-center">
				<SubInput {...rest} {name} {type} {formData} />
				{@html after}
			</div>
		{:else}
			<SubInput {...rest} {name} {type} {formData} />
		{/if}

		{#if help}
			<small class="formhelp">
				{help}
			</small>
		{/if}

		{#if $errors[name]}
			<small class="block text-red-500">
				{$errors[name]}
			</small>
		{/if}
	</div>
</div>
