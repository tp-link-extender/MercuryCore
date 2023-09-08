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
</script>

<Head title="Create" />

<div class="container py-2">
	<h1 class="h1 mb-2 light-text">Create</h1>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData tabs />
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
					{#each assetTypes as asset, num}
						<AdminLink
							href="/develop/create?asset={asset[2]}"
							emoji={asset[1]}
							{num}
							total={assetTypes.length}
							name={asset[0]}>
							<small class="text-warning">
								0 of this asset created and approved
							</small>
						</AdminLink>
					{/each}
				</div>
			</Tab>
		</div>
	</div>
</div>
