<script lang="ts">
	export let data
</script>

<Head title="Statistics" />

<h1 class="text-center light-text">Statistics</h1>

<div class="container mt-12 light-text fs-5">
	<h2 class="light-text mb-4">Total number of:</h2>
	<table>
		<tr>
			<td>Users</td>
			<td class="ps-6">{data.users}</td>
		</tr>
		<tr>
			<td>Places</td>
			<td class="ps-6">{data.places}</td>
		</tr>
		<tr>
			<td>Groups</td>
			<td class="ps-6">{data.groups}</td>
		</tr>
		<tr>
			<td>Assets</td>
			<td class="ps-6">{data.assets}</td>
		</tr>
		<tr>
			<td><fa class="fa-gem" /></td>
			<td class="ps-6">{data.totalCurrency}</td>
		</tr>
		<tr>
			<td>Transactions</td>
			<td class="ps-6">{data.transactions}</td>
		</tr>
		<tr>
			<td>Friendships</td>
			<td class="ps-6">{data.friendships}</td>
		</tr>
		<tr>
			<td>Followerships</td>
			<td class="ps-6">{data.followerships}</td>
		</tr>
		<tr>
			<td>Status posts</td>
			<td class="ps-6">{data.statusPosts}</td>
		</tr>
		<tr>
			<td>Forum posts</td>
			<td class="ps-6">{data.forumPosts}</td>
		</tr>
		<tr>
			<td>Forum replies</td>
			<td class="ps-6">{data.forumReplies}</td>
		</tr>
	</table>
	<h2 class="light-text mt-6 mb-4">Average number of:</h2>
	<table>
		<tr>
			<td>
				<fa class="fa-gem me-2" />
				per user
			</td>
			<td class="ps-6">{data.avgCurrency?.toFixed(2)}</td>
		</tr>
		<tr>
			<td>Friends per user</td>
			<td class="ps-6">{(data.friendships / data.users).toFixed(2)}</td>
		</tr>
		<tr>
			<td>Followers per user</td>
			<td class="ps-6">{(data.followerships / data.users).toFixed(2)}</td>
		</tr>
	</table>
</div>

<style lang="stylus">
	containerMinWidth()

	td
		padding 0
</style>
