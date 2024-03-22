<script lang="ts">
	import AssetApprove from "./AssetApprove.svelte"

	export let data

	let tabData = TabData(
		data.url,
		["Asset Queue"],
		["fa fa-file-circle-xmark"]
	)
</script>

<Head title="Asset approval - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Admin - Asset approval</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell
	bind:tabData
	class="grid gap-4 grid-cols-2 xl:grid-cols-6 lg:grid-cols-5 md:grid-cols-3 sm:grid-cols-4">
	{#each data.assets || [] as asset, num}
		<AssetApprove {asset} {num} total={(data.assets || []).length} />
	{/each}
</SidebarShell>
