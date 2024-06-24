<script lang="ts">
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$lib/components/Breadcrumbs.svelte"
	import ForumReply from "$lib/components/ForumReply.svelte"
	import Head from "$lib/components/Head.svelte"
	import { writable } from "svelte/store"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data

	$: topReply = data.replies[0]

	let refresh = 0
</script>

<Head title="Comments on asset" />

<div class="ctnr max-w-280 light-text">
	<Breadcrumbs
		path={[
			["Avatar shop", "/avatarshop"],
			[data.assetName, `/avatarshop/${data.assetId}/${data.assetName}`],
			[topReply.content[0].text, ""]
		]} />

	{#key refresh}
		{#each data.replies as reply, num}
			<ForumReply
				{user}
				{reply}
				{num}
				{replyingTo}
				postId={data.assetId.toString()}
				assetName={data.assetName}
				postAuthorName={data.creator || ""}
				{repliesCollapsed}
				pinnable={!reply.parentReplyId}
				refreshReplies={() =>
					async ({ result }) => {
						if (result.type === "success") await invalidateAll()
						refresh++
					}} />
		{/each}
	{/key}
</div>
