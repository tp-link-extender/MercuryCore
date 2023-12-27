<script lang="ts">
	export let name: string
	export let description: string
	export let placeholder: string
	export let rows: string = ""

	export let formData: any
	const { form, errors, constraints } = formData
</script>

<div {...$$restProps} class="flex flex-wrap pb-4">
	<label for={name} class="w-full md:w-1/4">
		{description}
	</label>
	<div class="w-full md:w-3/4">
		<textarea
			bind:value={$form[name]}
			{...$constraints[name]}
			{name}
			id={name}
			{rows}
			{placeholder}
			class="form-control {$errors[name] ? 'is-in' : ''}valid" />

		<small class="pb-4 text-danger">
			{$errors[name] || ""}
		</small>
	</div>
</div>
