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

<div class="flex px-4">
	<div class="<lg:hidden w-75" />
	<div class="flex w-full justify-center">
		<div class="w-full max-w-240 <md:px-4">
			<h1>Admin - Asset approval</h1>
			<a href="/admin" class="no-underline">
				<fa fa-caret-left />
				Back to panel
			</a>
		</div>
		<div class="<lg:hidden shrink-9999 w-75" />
	</div>
</div>

<div class="px-4 pt-6">
	<SidebarShell
		bind:tabData
		class="grid gap-4 grid-cols-2 xl:grid-cols-6 lg:grid-cols-5 md:grid-cols-3 sm:grid-cols-4">
		{#each data.assets || [] as asset, num}
			<AssetApprove {asset} {num} total={(data.assets || []).length} />
		{/each}
	</SidebarShell>
</div>
