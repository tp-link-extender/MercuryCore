<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import { superForm } from "$lib/validate"
	import assetTypes from "./assetTypes"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	export const snapshot = formData

	let [, c1, c2] = $derived(beautifyCurrency(data.price))
</script>

<Head name={data.siteName} title="Develop - Create" />

<div class="text-center">
	<h1>Develop &ndash; Create</h1>
	<a href="/develop" class="no-underline accent-text">
		<fa fa-caret-left></fa>
		Back to Develop
	</a>
</div>

<Form
	{formData}
	nopad
	enctype="multipart/form-data"
	submit="Create ({data.currencySymbol}{c1}{c2 ? '.' : ''}{c2})"
	class="ctnr pt-8 max-w-200 light-text">
	<Select
		{formData}
		options={assetTypes}
		selected={data.assetType}
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
	{#if data.assetType !== "Hat"}
		<Input
			{formData}
			type="file"
			name="asset"
			label="Asset"
			help="Max image size: 20MB. Supports most popular image formats." />
	{/if}
</Form>
