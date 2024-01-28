<script lang="ts">
	import AdminShell from "../AdminShell.svelte";
	import superForm from "$lib/superForm"

	export let data;
	const formDataManual = superForm(data.formManual)
	const formDataAutopilot = superForm(data.formAuto)

	let tabData = TabData(data.url, ["Create Asset"], ["fa fa-file-circle-plus"]);
	let tabData2 = TabData(data.url, ["Manual", "Autopilot"]);

	const assets: { [k: string]: string } = {
		"8": "Hat",
		"18": "Face"
	}

	const assetsAutopilot: { [k: string]: string } = {
		"8": "Hat"
	}
</script>

<Head title="Create Asset - Admin" />

<div class="ctnr pt-6">
	<div class="pb-4">
		<h1>Admin - Create Asset</h1>
		<a href="/admin" class="no-underline">
			<fa fa-caret-left />
			Back to panel
		</a>
	</div>

	<AdminShell bind:tabData>
		<Tab {tabData}>
			<TabNav bind:tabData={tabData2} justify />
			{((tabData2.num = 0), "")}
			<Tab tabData={tabData2}>
				<div class="alert alert-primary" role="alert">
					<far class="pr-2" fa-circle-info />
					Manual uploading mode is for shared assets (i.e. requires textures)
				</div>
				<Form 	
				formData={formDataManual}
				nopad
				enctype="multipart/form-data"
				submit="Create"
				class="pt-8 max-w-200 light-text">
				<Select formData={formDataManual} name="type" label="Asset type">
					{#each Object.keys(assets) as value}
					<option {value}>
						{assets[value]}
					</option>
				{/each}
				</Select>
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
				<Input formData={formDataManual} name="price" label="Asset price" type="number" />
				<Input
				formData={formDataManual}
				type="file"
				name="asset"
				label="Asset"
				help="Max image size: 20MB. Supported file types: .png, .jpg, .bmp, .rbxm, .xml" />
				</Form>
			</Tab>
			<Tab tabData={tabData2}>
				<div class="alert alert-primary" role="alert">
					<far class="pr-2" fa-circle-info />
					Use manual uploading mode for shared assets (i.e. mesh)
				</div>
				<Form 				
				formData={formDataAutopilot}
				nopad
				enctype="multipart/form-data"
				submit="Create"
				class="pt-8 max-w-200 light-text">
				<Select formData={formDataAutopilot} name="type" label="Asset type">
					{#each Object.keys(assetsAutopilot) as value}
					<option {value}>
						{assets[value]}
					</option>
				{/each}
				</Select>
				<Input formData={formDataAutopilot} name="assetId" label="Asset ID" type="number" />
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
				<Input formData={formDataManual} name="price" label="Asset price" type="number" />
				<Select formData={formDataAutopilot} name="type" label="Asset version">
					{#each Object.keys(assetsAutopilot) as value}
					<option {value}>
						{assets[value]}
					</option>
				{/each}
				</Select>
				<Select formData={formDataAutopilot} name="type" label="Shared assets">
					{#each Object.keys(assetsAutopilot) as value}
					<option {value}>
						{assets[value]}
					</option>
				{/each}
				</Select>
				</Form>

			</Tab>
		</Tab>
	</AdminShell>
</div>
