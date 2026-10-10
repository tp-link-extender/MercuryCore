<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import types from "$lib/assetTypes"
	import { superForm } from "$lib/validate"

	const { data } = $props()

	let formDataManual = $derived(superForm(data.form))
	let { form } = $derived(formDataManual)

	let tabData = $state(
		TabData(data.url, ["Asset creation"], ["fa-file-circle-plus"])
	)

	type AssetEntry = {
		name: string
		description: string
		type: string
		file: File | undefined
	}

	// for packages: uploads to include in the package
	let assets = $state<AssetEntry[]>([])
	let isPackage = $derived($form.type === "Package")

	const addAsset = () => assets.push({ name: "", description: "", type: "Hat" })
	const removeAsset = (num: number) => assets.splice(num, 1)
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
			submit={isPackage ? "Create package" : "Create"}>
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

			{#if isPackage}
				<div class="pb-4">
					<h2 class="pb-2">Package contents</h2>
					<small class="formhelp block pb-4">
						Every item added will be offsale by default (and only
						obtainable by buying this package).
						<b>A package must contain at least 2 assets.</b>
					</small>

					{#each assets as asset, num}
						<div class="package-asset card bg-a p-4 mb-6">
							<div class="flex justify-between pb-2">
								<h3>Asset #{num + 1}</h3>
								<button
									type="button"
									class="btn btn-sm no-underline text-red-500 my-0"
									onclick={() => removeAsset(num)}
									aria-label="Remove asset #{num + 1}">
									<fa fa-trash></fa>
									Remove
								</button>
							</div>
							<div class="flex flex-wrap pb-4">
								<label for={"childName-" + num} class="w-full">
									Asset name
								</label>
								<input
									name="childName"
									id={"childName-" + num}
									maxlength="50"
									bind:value={asset.name} />
							</div>
							<div class="flex flex-wrap pb-4">
								<label
									for={"childDescription-" + num}
									class="w-full">
									Asset description
								</label>
								<textarea
									name="childDescription"
									id={"childDescription-" + num}
									maxlength="1000"
									bind:value={asset.description} />
							</div>
							<div class="flex flex-wrap pb-4">
								<label for={"childType-" + num} class="w-full">
									Asset type
								</label>
								<select name="childType" id={"childType-" + num}>
									{#each Object.values(types) as option}
										<option value={option}>{option}</option>
									{/each}
								</select>
							</div>
							<div class="flex flex-wrap">
								<label for={"childAsset-" + num} class="w-full">
									Asset
								</label>
								<input
									type="file"
									name="childAsset"
									id={"childAsset-" + num}
									accept=".png,.jpg,.bmp,.rbxm,.xml" />
							</div>
						</div>
					{/each}

					<div class="flex justify-center">
						<button
							type="button"
							class="add-asset no-underline"
							onclick={addAsset}
							aria-label="Add asset">
							<fa fa-plus></fa>
						</button>
					</div>
				</div>
			{:else}
				<Input
					formData={formDataManual}
					type="file"
					name="asset"
					label="Asset"
					help="Max image size: 20MB. Supported file types: .png, .jpg, .bmp, .rbxm, .xml" />
			{/if}
		</Form>
	</Tab>
</SidebarShell>

<style>
	.package-asset {
		border: 1px solid var(--accent2);
		border-radius: var(--rounding);
	}

	.add-asset {
		@apply flex items-center justify-center size-10 no-underline mt-4;
		border-radius: 50%;
		border: none;
		background: hsl(var(--hue) 85 55);
		color: hsl(0 0% 100%);
		transition: all 0.2s ease-out;

		&:hover:not(:disabled),
		&:focus:not(:active) {
			background: hsl(var(--hue) 100 60);
		}

		&:focus,
		&:focus-visible,
		&:active {
			outline: none;
			box-shadow: none;
		}
	}
</style>
