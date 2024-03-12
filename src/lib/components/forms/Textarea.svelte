<script lang="ts">
	export let name: string
	export let label = ""
	export let help = ""
	export let placeholder = ""
	export let rows = ""

	export let formData: any
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
			{...$$restProps}
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{rows}
			placeholder={placeholder || null}
			class:is-invalid={$errors[name]} />

		{#if help}
			<small class="grey-text">
				{help}
			</small>
		{/if}

		<small class="pb-4 text-red-5">
			{$errors[name] || ""}
		</small>
	</div>
</div>
