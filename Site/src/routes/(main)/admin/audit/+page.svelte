<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"

	export let data

	let tabData = TabData(data.url, ["Audit logs"], ["fa fa-list"])
</script>

<Head name={data.siteName} title="Audit logs - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Audit logs &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData>
	<Tab {tabData} />
</SidebarShell>
