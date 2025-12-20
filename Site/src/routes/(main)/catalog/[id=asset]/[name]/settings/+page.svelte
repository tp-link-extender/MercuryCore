<script lang="ts">
	import { get } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	let { form } = $derived(formData)

	$effect(() => {
		if (data.description && !get(formData.form).description)
			$form.description = data.description.text
	})
</script>

<Head name={data.siteName} title="{data.name} Settings" />

<div class="ctnr max-w-180 light-text">
	<div class="pb-4">
		<h1>Configure {data.name}</h1>
		<a href="/catalog/{data.id}/{data.slug}" class="no-underline">
			<fa fa-caret-left></fa>
			Back to asset
		</a>
	</div>

	<Form
		{formData}
		enctype="multipart/form-data"
		submit=" <fa fa-save></fa> Save changes">
		<Input
			{formData}
			name="name"
			label="Name"
			placeholder="Make sure to make it accurate" />
		<Textarea
			{formData}
			name="description"
			label="Description"
			placeholder="Up to 1000 characters" />
		<Input {formData} type="number" name="price" label="Price" />
		<Input {formData} type="checkbox" name="forSale" label="For sale" />
	</Form>
</div>
