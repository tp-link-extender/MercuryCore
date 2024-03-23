<script lang="ts">
	const assetTypes = [
		["Shirts", "🧥", "11"],
		["T-Shirts", "👕", "2"],
		["Pants", "👖", "12"],
		["Decals", "🖼️", "13"]
	]

	export let data

	let tabData = TabData(data.url, ["Create", "Creations"])
	let tabData2 = TabData(data.url, ["Shirts", "T-Shirts", "Pants", "Decals"])
</script>

<Head title="Create" />

<h1 class="text-center pb-4">Create</h1>

<div class="px-4 pt-6">
	<SidebarShell bind:tabData space>
		<div>
			<Tab {tabData} class="grid lg:grid-cols-4 gap-4">
				{#each assetTypes as asset, num}
					<AdminLink
						href="/develop/create?asset={asset[2]}"
						emoji={asset[1]}
						{num}
						total={assetTypes.length}
						name={asset[0]} />
				{/each}
			</Tab>

			<Tab {tabData}>
				<TabNav bind:tabData={tabData2} justify />
				<form
					on:submit|preventDefault
					action="/character?tab={tabData.currentTab}"
					class="pb-4">
					<input
						type="hidden"
						name="tab"
						value={tabData.currentTab} />
					<div class="input-group">
						<input
							type="text"
							name="q"
							placeholder="Search for an item"
							aria-label="Search for an item"
							aria-describedby="button-addon2" />
						<button
							class="btn btn-secondary"
							aria-label="Search"
							id="button-addon2">
							<fa fa-magnifying-glass />
						</button>
					</div>
				</form>
			</Tab>
		</div>
	</SidebarShell>
</div>
