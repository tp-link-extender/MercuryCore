<script lang="ts">
	import type { HTMLTextareaAttributes } from "svelte/elements"

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
		name: string
		label?: string
		help?: string
		placeholder?: string
		rows?: number
		lowpad?: boolean
		defaultValue?: string
		formData: import("sveltekit-superforms").SuperForm<any>
	} & HTMLTextareaAttributes = $props()

	const { form, errors, constraints } = formData

	// TODO: prevent tabs in textarea caused by... the formatter....
	$effect(() => {
		$form[name] = defaultValue
	})
</script>

<div class="flex flex-wrap {lowpad ? 'pb-4' : 'pb-8'}">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class={["w-full", { "md:w-3/4": label }]}>
		<textarea
			{...rest}
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{rows}
			placeholder={placeholder || null}
			class={{ "is-invalid": $errors[name] }}>
		</textarea>

		{#if help}
			<small class="formhelp">
				{@html help}
			</small>
		{/if}

		<small class="pb-4 text-red-500">
			{$errors[name] || ""}
		</small>
	</div>
</div>
