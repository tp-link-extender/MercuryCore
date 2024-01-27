<script lang="ts">
	import AssetApprove from "./AssetApprove.svelte"
	import AdminShell from "../AdminShell.svelte"

	export let data

	let tabData = TabData(
		data.url,
		["Asset Queue"],
		["fa fa-file-circle-xmark"]
	)
</script>

<Head title="Asset Approval - Admin" />

<div class="ctnr py-6">
	<div class="pb-4">
		<h1>Admin - Asset Approval</h1>
		<a href="/admin" class="no-underline">
			<fa fa-caret-left />
			Back to panel
		</a>
	</div>

	<AdminShell
		bind:tabData
		class="grid gap-4 grid-cols-2 xl:grid-cols-6
		lg:grid-cols-5 md:grid-cols-3 sm:grid-cols-4">
		{#each data.assets || [] as asset, num}
			<AssetApprove {asset} {num} total={(data.assets || []).length} />
		{/each}
	</AdminShell>
</div>
