<script lang="ts">
	export let name: string
	export let label = ""
	export let help = ""
	export let placeholder = ""
	export let rows = 3
	export let lowpad = false

	export let formData: import("sveltekit-superforms").SuperForm<any>
	const { form, errors, constraints } = formData
</script>

<div class="flex flex-wrap {lowpad ? 'pb-4' : 'pb-8'}">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class="w-full {label ? 'md:w-3/4' : ''}">
		<textarea
			{...$$restProps}
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{rows}
			placeholder={placeholder || null}
			class:is-invalid={$errors[name]} />

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
