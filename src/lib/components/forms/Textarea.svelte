<script lang="ts">
	export let name: string
	export let label: string
	export let help = ""
	export let placeholder = ""
	export let rows = ""

	export let formData: any
	const { form, errors, constraints } = formData
</script>

<div {...$$restProps} class="flex flex-wrap pb-8">
	<label for={name} class="w-full md:w-1/4">
		{label}
	</label>
	<div class="w-full md:w-3/4">
		<textarea
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{rows}
			placeholder={placeholder || null}
			class="form-control {$errors[name] ? 'is-in' : ''}valid" />

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
