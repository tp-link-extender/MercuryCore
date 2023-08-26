<script lang="ts">
	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data

	$: topReply = data.replies[0]
</script>

<Head title="Replies to forum post" />

<div class="w-70rem mx-a light-text">
	<nav aria-label="breadcrumb" class="mx-auto">
		<ol class="breadcrumb border-0 m-0 shadow-none fs-6">
			<li class="breadcrumb-item">
				<a href="/avatarshop" class="accent-text">Avatar shop</a>
			</li>
			<li class="breadcrumb-item">
				<a
					href="/avatarshop/{data.assetId}/{data.assetName}"
					class="accent-text">
					{data.assetName}
				</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">
				{topReply.content[0].text}
			</li>
		</ol>
	</nav>

	{#each data.replies as reply, num}
		<ForumReply
			{user}
			{reply}
			{num}
			{replyingTo}
			postId={data.assetId.toString()}
			assetName={data.assetName}
			postAuthorName={data.creator || ""}
			{repliesCollapsed} />
	{/each}
</div>
