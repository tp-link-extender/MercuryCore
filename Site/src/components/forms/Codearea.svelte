<script lang="ts">
	const {
		name,
		label = "",
		help = "",
		placeholder = "",
		rows,
		formData,
		...rest
	}: {
		name: string
		label?: string
		help?: string
		placeholder?: string
		rows?: number
		formData: import("sveltekit-superforms").SuperForm<any>
	} = $props()

	const { form, errors, constraints } = formData
</script>

<div class="flex flex-wrap pb-8">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class="w-full {label ? 'md:w-3/4' : ''}">
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
				{help}
			</small>
		{/if}

		<small class="pb-4 text-red-500">
			{$errors[name] || ""}
		</small>
	</div>
</div>
