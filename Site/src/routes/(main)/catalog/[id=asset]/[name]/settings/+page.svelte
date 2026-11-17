<script lang="ts">
	import Form from "#components/forms/Form.svelte"
	import Input from "#components/forms/Input.svelte"
	import Textarea from "#components/forms/Textarea.svelte"
	import Head from "#components/Head.svelte"
	import { reuploadForm, settingsForm } from "./settings.remote.js"

	const { data } = $props()

	let { user } = $derived(data)
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
		formData={settingsForm}
		enctype="multipart/form-data"
		submit=" <fa fa-save></fa> Save changes">
		<input {...settingsForm.fields.id.as("hidden", data.id)} />
		<Input
			formData={settingsForm}
			name="name"
			label="Name"
			defaultValue={data.name}
			placeholder="Make sure to make it accurate" />
		<Textarea
			formData={settingsForm}
			name="description"
			label="Description"
			defaultValue={data.description}
			placeholder="Up to 1000 characters" />
		<Input
			formData={settingsForm}
			type="number"
			name="price"
			label="Price"
			defaultValue={data.price.toString()} />
		<Input
			formData={settingsForm}
			type="checkbox"
			name="forSale"
			label="For sale"
			defaultValue={data.forSale} />
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

	{#if data.type !== 32}
		<Form
			formData={reuploadForm}
			enctype="multipart/form-data"
			submit=" <fa fa-upload></fa> Upload file">
			<input {...reuploadForm.fields.id.as("hidden", data.id)} />
			<Input
				formData={reuploadForm}
				type="file"
				name="asset"
				label="New asset file"
				help={data.imageAssetId
					? "Max image size: 20MB. Supports most popular image formats."
					: "Max file size: 20MB."} />
		</Form>
	{:else}
		<p class="grey-text">Packages cannot be reuploaded.</p>
	{/if}
</div>
