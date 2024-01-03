<script lang="ts">
	export let data
</script>

<Head title="Statistics" />

<h1 class="text-center">Statistics</h1>

<div class="ctnr pt-8 max-w-200 text-xl text-white">
	<h2 class="pb-2">Total number of:</h2>
	<table>
		<tr>
			<td>Users</td>
			<td>{data.users}</td>
		</tr>
		<tr>
			<td>Places</td>
			<td>{data.places}</td>
		</tr>
		<tr>
			<td>Groups</td>
			<td>{data.groups}</td>
		</tr>
		<tr>
			<td>Assets</td>
			<td>{data.assets}</td>
		</tr>
		<tr>
			<td><fa fa-gem /></td>
			<td>{data.totalCurrency}</td>
		</tr>
		<tr>
			<td>Transactions</td>
			<td>{data.transactions}</td>
		</tr>
		<tr>
			<td>Friendships</td>
			<td>{data.friendships}</td>
		</tr>
		<tr>
			<td>Followerships</td>
			<td>{data.followerships}</td>
		</tr>
		<tr>
			<td>Status posts</td>
			<td>{data.statusPosts}</td>
		</tr>
		<tr>
			<td>Forum posts</td>
			<td>{data.forumPosts}</td>
		</tr>
		<tr>
			<td>Forum replies</td>
			<td>{data.forumReplies}</td>
		</tr>
	</table>
	<br />
	<h2 class="pb-2">Average number of:</h2>
	<table>
		<tr>
			<td>
				<fa fa-gem class="pr-2" />
				per user
			</td>
			<td>{data.avgCurrency?.toFixed(2)}</td>
		</tr>
		<tr>
			<td>Friends per user</td>
			<td>{(data.friendships / data.users).toFixed(2)}</td>
		</tr>
		<tr>
			<td>Followers per user</td>
			<td>{(data.followerships / data.users).toFixed(2)}</td>
		</tr>
	</table>
</div>

<style lang="stylus">
	td
		padding 0
		&:nth-child(2)
			text-align right
			padding-left 2rem
</style>
