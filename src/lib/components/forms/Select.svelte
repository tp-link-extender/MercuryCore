<script lang="ts">
	export let name: string
	export let label: string
	export let help = ""
	export let placeholder = ""

	export let formData: any
	const { form, errors, constraints } = formData

	// could make this based on a js object or something
	// but concerns with forms that require more interactivity
</script>

<div {...$$restProps} class="flex flex-wrap pb-8">
	<label for={name} class="w-full md:w-1/4">
		{label}
	</label>
	<div class="w-full md:w-3/4">
		<select
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{placeholder}
			class="form-select {$errors[name] ? 'is-in' : ''}valid">
			<slot />
		</select>

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
