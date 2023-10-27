<script lang="ts">
	const assetTypes = [
		["Shirts", "🧥", "11"],
		["T-Shirts", "👕", "2"],
		["Pants", "👖", "12"],
		["Decals", "🖼️", "13"],
	]

	export let data
	const { user } = data

	if (user?.permissionLevel == 5) assetTypes.push(["Hats", "🎩", ""])

	let tabData = TabData(data.url, ["Create", "Creations"])
	let tabData2 = TabData(data.url, ["Shirts", "T-Shirts", "Pants", "Decals"])
</script>

<Head title="Create" />

<div class="container py-2">
	<h1 class="mb-2 light-text">Create</h1>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<div class="row">
					{#each assetTypes as asset, num}
						<AdminLink
							href="/develop/create?asset={asset[2]}"
							emoji={asset[1]}
							{num}
							total={assetTypes.length}
							name={asset[0]} />
					{/each}
				</div>
			</Tab>

			<Tab {tabData}>
				<div class="row">
					<TabNav bind:tabData={tabData2} justify />
					<form
						on:submit|preventDefault
						action="/character?tab={tabData.currentTab}"
						class="row mb-4">
						<input
							type="hidden"
							name="tab"
							value={tabData.currentTab} />
						<div class="input-group">
							<input
								type="text"
								name="q"
								class="form-control light-text valid"
								placeholder="Search for an item"
								aria-label="Search for an item"
								aria-describedby="button-addon2" />
							<button
								class="btn btn-success"
								aria-label="Search"
								id="button-addon2">
								<fa fa-magnifying-glass />
							</button>
						</div>
					</form>
					<Tab tabData={tabData2} />
					<Tab tabData={tabData2} />
					<Tab tabData={tabData2} />
					<Tab tabData={tabData2} />
				</div>
			</Tab>
		</div>
	</div>
</div>
