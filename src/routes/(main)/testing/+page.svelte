<script lang="ts">
	export let data

	let tabData1 = TabData(data.url, [
		"Hats",
		"T-Shirts",
		"Shirts",
		"Pants",
		"Decals",
	])
	let tabData2 = TabData(data.url, [
		"Hats",
		"T-Shirts",
		"Shirts",
		"Pants",
		"Decals",
	])
	let tabData3 = TabData(data.url, [
		"Hats",
		"T-Shirts",
		"Shirts",
		"Pants",
		"Decals",
	])
</script>

<Head title="Inventory" />

<h1 class="light-text text-center mb-4">Inventory</h1>

<div class="container d-flex gap-3 flex-column">
	<div class="bg-darker p-3 rounded-3 w-35">
		<TabNav bind:tabData={tabData1} vertical />
	</div>
	<div class="bg-darker p-3 rounded-3">
		<TabNav bind:tabData={tabData2} />
	</div>
	<div class="bg-darker p-3 rounded-3">
		<TabNav bind:tabData={tabData3} justify />
	</div>
</div>

<style lang="stylus">
	containerMinWidth(35rem)
</style>
