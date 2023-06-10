<script lang="ts">
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

	export let data

	let tabData = TabData(data.url, ["Audit Logs"])
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Audit Logs</h1>
	<a href="/admin" class="no-underline">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="grid grid-cols-12 gap-6 mt-4">
		<div class="lg:col-span-2 md:col-span-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="lg:col-span-10 md:col-span-9">
			<Tab {tabData} />
		</div>
	</div>
</div>
