<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import assetTypes from "./assetTypes"
	import { formData } from "./create.remote.js"

	const { data } = $props()

	let { user } = $derived(data)

	let [, c1, c2] = $derived(beautifyCurrency(data.price))

	let currency = $derived(
		` (${data.currencySymbol}${c1}${c2 ? "." : ""}${c2})`
	)
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
	formData={formData}
	nopad
	enctype="multipart/form-data"
	submit="Create{user.permissionLevel < 3 ? currency : ''}"
	class="ctnr pt-8 max-w-200 light-text">
	<Select
		formData={formData}
		options={assetTypes}
		selected={data.assetType ?? undefined}
		name="type"
		label="Asset type" />
	<Input
		formData={formData}
		name="name"
		label="Asset name"
		placeholder="Make sure to make it accurate" />
	<Textarea
		formData={formData}
		name="description"
		label="Asset description"
		placeholder="Up to 1000 characters" />
	<Input
		formData={formData}
		name="price"
		label="Asset price"
		type="number" />
	{#if data.assetType !== "Hat"}
		<Input
			formData={formData}
			type="file"
			name="asset"
			label="Asset"
			help="Max image size: 20MB. Supports most popular image formats." />
	{/if}
</Form>
