<script lang="ts">
	import AssetApprove from "./AssetApprove.svelte"

	export let data

	let tabData = TabData(data.url, ["Asset Queue"])
</script>

<Head title="Asset Approval - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Asset Approval</h1>
	<a href="/admin" class="text-decoration-none">
		<fa class="fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-6">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<div class="row">
				{#each data.assets || [] as asset, num}
					<AssetApprove
						{asset}
						{num}
						total={(data.assets || []).length} />
				{/each}
			</div>
		</div>
	</div>
</div>
