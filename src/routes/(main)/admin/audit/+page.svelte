<script lang="ts">
	import AdminShell from "../AdminShell.svelte"

	export let data

	let tabData = TabData(data.url, ["Audit Logs"])
</script>

<Head title="Audit Logs - Admin" />

<div class="ctnr pt-6">
	<h1>Admin - Audit Logs</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>

	<AdminShell bind:tabData>
		<Tab {tabData} />
	</AdminShell>
</div>
