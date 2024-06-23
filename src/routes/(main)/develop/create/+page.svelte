<script lang="ts">
	import Head from "$lib/components/Head.svelte"
	import Form from "$lib/components/forms/Form.svelte"
	import Input from "$lib/components/forms/Input.svelte"
	import Select from "$lib/components/forms/Select.svelte"
	import Textarea from "$lib/components/forms/Textarea.svelte"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData

	const assets: { [k: string]: string } = {
		"2": "T-Shirt",
		"11": "Shirt",
		"12": "Pants",
		"13": "Decal"
	}
</script>

<Head title="Develop" />

<div class="text-center">
	<h1>Develop - Create</h1>
	<a href="/develop" class="no-underline accent-text">
		<fa fa-caret-left />
		Back to Develop
	</a>
</div>

<Form
	{formData}
	nopad
	enctype="multipart/form-data"
	submit="Create ( <fa fa-gem></fa> 15 )"
	class="ctnr pt-8 max-w-200 light-text">
	<Select
		{formData}
		options={Object.entries(assets)}
		selected={data.assettype}
		name="type"
		label="Asset type" />
	<Input
		{formData}
		name="name"
		label="Asset name"
		placeholder="Make sure to make it accurate" />
	<Textarea
		{formData}
		name="description"
		label="Asset description"
		placeholder="Up to 1000 characters" />
	<Input {formData} name="price" label="Asset price" type="number" />
	{#if data.assettype !== "Hat"}
		<Input
			{formData}
			type="file"
			name="asset"
			label="Asset"
			help="Max image size: 20MB. Supported file types: .png, .jpg, .bmp" />
	{/if}
</Form>
