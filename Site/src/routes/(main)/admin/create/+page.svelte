<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import types from "$lib/assetTypes"
	import fade from "$lib/fade"
	import { superForm } from "sveltekit-superforms/client"

	let { data } = $props();

	const formDataManual = superForm(data.formManual)
	const formDataAutopilot = superForm(data.formAuto)

	let tabData = $state(TabData(data.url, ["Asset creation"], ["fa-file-circle-plus"]))
	let tabData2 = $state(TabData(data.url, ["Manual", "Autopilot"], [], "tab2"))

	const aan = (word: string) =>
		"aeiou".includes(word[0].toLowerCase()) ? "an" : "a"
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
	<Tab {tabData}>
		<TabNav bind:tabData={tabData2} justify />
		{((tabData2.num = 0), "")}
		<Tab tabData={tabData2}>
			<div class="alert alert-primary" role="alert">
				<fa class="pr-2" fa-circle-info></fa>
				Manual uploading mode is for shared assets (ie. requires textures)
			</div>
			<Form
				formData={formDataManual}
				nopad
				enctype="multipart/form-data"
				submit="Create"
				class="pt-8 light-text">
				<Select
					formData={formDataManual}
					options={Object.entries(types)}
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
		<Tab tabData={tabData2}>
			<div class="alert alert-primary" role="alert">
				<fa class="pr-2" fa-circle-info></fa>
				Use manual uploading mode for shared assets (ie. mesh)
			</div>
			{#if data.stage >= 2}
				<div class="py-4 flex gap-6 items-center">
					<a
						href="/admin/create?tab2=Autopilot"
						class="btn btn-secondary">
						Reset
					</a>
					<span>
						You are uploading
						{#if data.type && types[data.type]}
							{aan(types[data.type])}
							<b>{types[data.type]}</b>
						{:else}
							an unknown
						{/if}
						asset with asset id
						<b>{data.assetId}</b>
						{#if data.stage === 3}
							and version <b>{data.version}</b>
						{/if}
					</span>
				</div>
			{/if}

			{#if data.stage === 2 && data.getVersions}
				<p>
					{#await data.getVersions}
						Getting asset versions, please wait...
					{:then versions}
						{#if versions.list.length > 0}
							Found {versions.list.length} versions of asset {data.assetId}
							{#if versions.cached}
								(Using cached data)
							{/if}
						{:else}
							No versions found for asset {data.assetId}
						{/if}
					{/await}
				</p>
			{/if}
			{#if data.stage === 3 && data.getSharedAssets}
				<p>
					{#await data.getSharedAssets}
						Getting asset versions, please wait...
					{:then sharedAssets}
						{#if sharedAssets.length > 0}
							Found {sharedAssets.length} shared assets related to
							{data.assetId}
						{:else}
							No versions found for asset {data.assetId}
						{/if}
					{/await}
				</p>
			{/if}
			<Form
				formData={formDataAutopilot}
				method={data.stage === 3 ? "POST" : "GET"}
				action="?/autopilot"
				submit="Create"
				class="pt-8 light-text">
				<input type="hidden" name="tab2" value={tabData2.currentTab} />
				{#if data.stage === 1}
					<Input
						formData={formDataAutopilot}
						name="assetId"
						label="Asset Id"
						type="number"
						placeholder="33866846"
						required />
				{:else if data.stage === 2 && data.getVersions}
					<input type="hidden" name="assetId" value={data.assetId} />
					{#await data.getVersions then versions}
						{#if versions.list.length > 0}
							<Select
								formData={formDataAutopilot}
								options={versions.list}
								name="version"
								label="Asset version" />
						{/if}
					{/await}
				{:else if data.stage === 3}
					<input type="hidden" name="assetId" value={data.assetId} />
					<input type="hidden" name="version" value={data.version} />
					<Input
						formData={formDataAutopilot}
						name="name"
						label="Asset name"
						placeholder="Make sure to make it accurate" />
					<Textarea
						formData={formDataAutopilot}
						name="description"
						label="Asset description"
						placeholder="Up to 1000 characters" />
					<Input
						formData={formDataAutopilot}
						name="price"
						label="Asset price"
						type="number" />
					{#await data.getSharedAssets then sharedAssets}
						{#if sharedAssets && sharedAssets.length > 0}
							<div in:fade|global>
								<Select
									multiple
									formData={formDataAutopilot}
									options={sharedAssets.map(a => [a, a])}
									name="shared"
									label="Shared assets" />
							</div>
						{/if}
					{/await}
				{/if}
			</Form>
		</Tab>
	</Tab>
</SidebarShell>
