<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import types from "$lib/assetTypes"

	const { data } = $props()

	const formDataManual = superForm(data.form)

	let tabData = $state(
		TabData(data.url, ["Asset creation"], ["fa-file-circle-plus"])
	)
</script>

<Head name={data.siteName} title="Asset creation - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Asset creation &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab bind:tabData>
		<Form
			formData={formDataManual}
			nopad
			enctype="multipart/form-data"
			submit="Create">
			<Select
				formData={formDataManual}
				options={Object.values(types)}
				name="type"
				label="Asset type" />
			<Input
				formData={formDataManual}
				name="name"
				label="Asset name"
				placeholder="Make sure to make it accurate" />
			<Textarea
				formData={formDataManual}
				name="description"
				label="Asset description"
				placeholder="Up to 1000 characters" />
			<Input
				formData={formDataManual}
				name="price"
				label="Asset price"
				type="number" />
			<Input
				formData={formDataManual}
				type="file"
				name="asset"
				label="Asset"
				help="Max image size: 20MB. Supported file types: .png, .jpg, .bmp, .rbxm, .xml" />
		</Form>
	</Tab>
</SidebarShell>
