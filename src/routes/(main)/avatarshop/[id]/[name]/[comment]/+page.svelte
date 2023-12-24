<script lang="ts">
	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data

	$: topReply = data.replies[0]
</script>

<Head title="Replies to forum post" />

<div class="ctnr light-text">
	<Breadcrumbs
		path={[
			["Avatar shop", "/avatarshop"],
			[data.assetName, `/avatarshop/${data.assetId}/${data.assetName}`],
			[topReply.content[0].text, ""],
		]} />

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

<style lang="stylus">
	containerMinWidth(70rem)
</style>
