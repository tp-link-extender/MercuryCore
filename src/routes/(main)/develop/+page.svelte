<script lang="ts">
	const assetTypes = [
		["Shirts", "🧥", "11"],
		["T-Shirts", "👕", "2"],
		["Pants", "👖", "12"],
		["Decals", "🖼️", "13"],
	]

	export let data
	const { user } = data

	if (user?.permissionLevel > 2) {
		assetTypes.push(["Hats", "🎩", "8"])
		assetTypes.push(["Face", "🙂", "18"])
	}

	let tabData = TabData(data.url, ["Create", "Creations"])
	let tabData2 = TabData(data.url, ["Shirts", "T-Shirts", "Pants", "Decals"])
</script>

<Head title="Create" />

<div class="ctnr py-2">
	<h1>Create</h1>
	<div class="flex flex-wrap pt-6">
		<TabNav
			bind:tabData
			vertical
			class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
		<div class="w-full lg:w-5/6 md:w-3/4">
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
	</div>
</div>
