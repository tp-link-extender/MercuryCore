<script lang="ts">
	export let data
</script>

<svelte:head>
	<title>Statistics - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Statistics</h1>

<div class="container mt-5 light-text h5">
	<h2 class="light-text mb-3">Total number of:</h2>
	<table>
		<tr>
			<td>Users</td>
			<td class="ps-4">{data.users}</td>
		</tr>
		<tr>
			<td>Places</td>
			<td class="ps-4">{data.places}</td>
		</tr>
		<tr>
			<td>Groups</td>
			<td class="ps-4">{data.groups}</td>
		</tr>
		<tr>
			<td>Avatar shop items</td>
			<td class="ps-4">{data.items}</td>
		</tr>
		<tr>
			<td>Currency</td>
			<td class="ps-4">{data.currency._sum.currency}</td>
		</tr>
		<tr>
			<td>Transactions</td>
			<td class="ps-4">{data.transactions}</td>
		</tr>
		<tr>
			<td>Friendships</td>
			<td class="ps-4">{data.friendships}</td>
		</tr>
	</table>
	<br />
	<br />
	<h2 class="light-text mb-3">Average number of:</h2>
	<table>
		<tr>
			<td>Currency per user</td>
			<td class="ps-4">{data.currency._avg.currency}</td>
		</tr>
		<tr>
			<td>Friends per user</td>
			<td class="ps-4">{data.friendships / data.users}</td>
		</tr>
	</table>
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
