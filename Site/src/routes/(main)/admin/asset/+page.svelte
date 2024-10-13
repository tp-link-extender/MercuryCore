<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"
	import AssetApprove from "./AssetApprove.svelte"

	export let data

	let tabData = TabData(data.url, ["Asset queue"], ["fa-file-circle-xmark"])
</script>

<Head name={data.siteName} title="Asset approval - Admin" />

<div class="flex px-4">
	<div class="<lg:hidden w-75"></div>
	<div class="flex w-full justify-center">
		<div class="w-full max-w-240 <md:px-4">
			<h1>Asset approval &ndash; Admin</h1>
			<a href="/admin" class="no-underline">
				<fa fa-caret-left></fa>
				Back to panel
			</a>
		</div>
		<div class="<lg:hidden shrink-9999 w-75"></div>
	</div>
</div>

<div class="px-4 pt-6">
	<SidebarShell
		bind:tabData
		space
		class="grid gap-4 grid-cols-2 xl:grid-cols-6 lg:grid-cols-5 md:grid-cols-3 sm:grid-cols-4">
		{#each data.assets || [] as asset, num}
			<AssetApprove {asset} {num} total={(data.assets || []).length} />
		{/each}
	</SidebarShell>
</div>
