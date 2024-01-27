<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData

	const assets: { [k: string]: string } = {
		"2": "T-Shirt",
		"11": "Shirt",
		"12": "Pants",
		"13": "Decal",
	}

	if (data.user.permissionLevel > 3) {
		assets["8"] = "Hat"
		assets["18"] = "Face"
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
	<Select {formData} name="type" label="Asset type" selected={data.assettype}>
		{#each Object.keys(assets) as value}
			<option {value} selected={value == data.assettype}>
				{assets[value]}
			</option>
		{/each}
	</Select>
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
	<Input
		{formData}
		type="file"
		name="asset"
		label="Asset"
		help="Max image size: 20MB. Supported file types: .png, .jpg, .bmp" />
</Form>
