<script lang="ts">
	import AssetApprove from "./AssetApprove.svelte"

	export let data

	let tabData = TabData(data.url, ["Asset Queue"])
</script>

<Head title="Asset Approval - Admin" />

<div class="ctnr py-6">
	<h1>Admin - Asset Approval</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="flex flex-wrap pt-6">
		<TabNav
			bind:tabData
			vertical
			class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
		<div
			class="w-full lg:w-5/6 md:w-3/4 grid gap-4
			xl:grid-cols-6 md:grid-cols-4 sm:grid-cols-3 grid-cols-2">
			{#each data.assets || [] as asset, num}
				<AssetApprove
					{asset}
					{num}
					total={(data.assets || []).length} />
			{/each}
		</div>
	</div>
</div>
