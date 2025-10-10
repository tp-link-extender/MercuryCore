<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"

	const { data } = $props()

	let tabData = $state(TabData(data.url, ["Gameservers"], ["fa-server"]))
</script>

<Head name={data.siteName} title="Gameservers - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Gameservers &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-240">
		<table class="w-full">
		<thead>
			<tr>
				<th scope="col">ID</th>
				<th scope="col">PID</th>
				<th scope="col">Uptime</th>
			</tr>
		</thead>
		<tbody>
			{#each data.gameservers as [id, g]}
				<tr>
					<td><a href="/place/{id}">{id}</a></td>
					<td>{g.pid}</td>
					<td>{new Date(g.startTime).toLocaleString()}</td>
				</tr>
			{/each}
		</tbody>
	</table>
</SidebarShell>

<style>
	tbody tr:nth-child(2n-1) {
		background: var(--darker);
	}
</style>
