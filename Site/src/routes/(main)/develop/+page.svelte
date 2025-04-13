<script lang="ts">
	import { createBubbler, preventDefault } from 'svelte/legacy';

	const bubble = createBubbler();
	import AdminLink from "$components/AdminLink.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"

	let { data } = $props();

	const assetTypes = [
		["Shirts", "🧥", "11"],
		["T-Shirts", "👕", "2"],
		["Pants", "👖", "12"],
		["Decals", "🖼️", "13"]
	]

	let tabData = $state(TabData(data.url, ["Create", "Creations"]))
	let tabData2 = $state(TabData(data.url, ["Shirts", "T-Shirts", "Pants", "Decals"]))
</script>

<Head name={data.siteName} title="Create" />

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
					onsubmit={preventDefault(bubble('submit'))}
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
							<fa fa-search></fa>
						</button>
					</div>
				</form>
			</Tab>
		</div>
	</SidebarShell>
</div>
