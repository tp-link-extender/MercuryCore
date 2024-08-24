<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"

	export let data

	let tabData = TabData(data.url, ["Audit logs"], ["fa-list"])

	const colours = Object.freeze({
		Account: "text-sky-5",
		Administration: "text-red-5",
		Moderation: "text-emerald-5",
		Economy: "text-yellow-5"
	})
</script>

<Head name={data.siteName} title="Audit logs - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Audit logs &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<table class="w-full">
		<thead>
			<tr>
				<th scope="col">Action</th>
				<th scope="col">Note</th>
				<th scope="col">User</th>
				<th scope="col">Time</th>
			</tr>
		</thead>
		<tbody>
			{#each data.logs as log}
				<tr>
					<td class={colours[log.action]}>{log.action}</td>
					<td>{log.note}</td>
					<td><User user={log.user} full thin /></td>
					<td>{new Date(log.time).toLocaleString()}</td>
				</tr>
			{/each}
		</tbody>
	</table>
</SidebarShell>
