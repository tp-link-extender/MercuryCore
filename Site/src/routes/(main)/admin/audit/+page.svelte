<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"

	export let data

	let tabData = TabData(data.url, ["Audit logs"], ["fa fa-list"])
</script>

<Head title="Audit logs - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Admin - Audit logs</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData>
	<Tab {tabData} />
</SidebarShell>
