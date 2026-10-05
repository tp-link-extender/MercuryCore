<script lang="ts">
	import { get } from "svelte/store"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import { superForm } from "$lib/validate"

	const { data } = $props()

	let formData = $derived(superForm(data.settingsForm))
	let reuploadData = $derived(superForm(data.reuploadForm))
	let { form } = $derived(formData)
	let { user } = $derived(data)

	$effect(() => {
		if (data.description && !get(formData.form).description)
			$form.description = data.description
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
		action="?/settings"
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

	<hr />

	<div class="pt-6 pb-4">
		<h2 class="text-xl">Reupload asset</h2>
		<p class="grey-text">
			Replace the file for this asset.
			{#if data.visibility === "Pending"}
				This asset is currently pending approval &ndash; your upload will
				stay pending until an admin approves it.
			{:else if user.permissionLevel >= 3}
				Your upload will be
				automatically approved.
			{:else}
				Your upload will need to be approved by an admin before going
				live.
			{/if}
		</p>
	</div>

	<Form
		formData={reuploadData}
		enctype="multipart/form-data"
		action="?/reupload"
		submit=" <fa fa-upload></fa> Upload file">
		<Input
			formData={reuploadData}
			type="file"
			name="asset"
			label="New asset file"
			help="Max image size: 20MB. Supports most popular image formats." />
	</Form>
</div>
