<script lang="ts">
	import Head from "$components/Head.svelte"

	const { data } = $props()

	let [
		users,
		places,
		groups,
		assets,
		friendships,
		followerships,
		comments
	] = $derived(data.stats)
</script>

<Head name={data.siteName} title="Statistics" />

<h1 class="text-center">Statistics</h1>

<div class="ctnr pt-8 max-w-200 text-xl text-white">
	<h2 class="pb-2">Total number of:</h2>
	<table>
		<tbody>
			<tr>
				<td>Users</td>
				<td>{users}</td>
			</tr>
			<tr>
				<td>Places</td>
				<td>{places}</td>
			</tr>
			<tr>
				<td>Groups</td>
				<td>{groups}</td>
			</tr>
			<tr>
				<td>Assets</td>
				<td>{assets}</td>
			</tr>
			<tr>
				<td>Friendships</td>
				<td>{friendships}</td>
			</tr>
			<tr>
				<td>Followerships</td>
				<td>{followerships}</td>
			</tr>
			<tr>
				<td>Comments</td>
				<td>{comments}</td>
			</tr>
		</tbody>
	</table>
	<br />
	<h2 class="pb-2">Average number of:</h2>
	<table>
		<tbody>
			<tr>
				<td>Friends per user</td>
				<td>{(friendships / users).toFixed(2)}</td>
			</tr>
			<tr>
				<td>Followers per user</td>
				<td>{(followerships / users).toFixed(2)}</td>
			</tr>
		</tbody>
	</table>
</div>

<style>
	td {
		padding: 0;
		&:nth-child(2) {
			text-align: right;
			padding-left: 2rem;
		}
	}
</style>
