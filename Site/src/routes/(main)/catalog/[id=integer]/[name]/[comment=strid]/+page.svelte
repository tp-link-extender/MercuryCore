<script lang="ts">
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import ForumReply from "$components/ForumReply.svelte"
	import Head from "$components/Head.svelte"

	let replyingTo = $state("")
	let repliesCollapsed = $state({})
	let refresh = $state(0)

	const { data } = $props()

	const { user } = data

	let topReply = $derived(data.replies[0])
</script>

<Head name={data.siteName} title="Comments on asset" />

<div class="ctnr light-text max-w-280">
	<Breadcrumbs
		path={[
			["Catalog", "/catalog"],
			[data.assetName, `/catalog/${data.assetId}/${data.assetName}`],
			[topReply.content[0].text, ""]
		]} />

	{#key refresh}
		{#each data.replies as reply, num}
			<ForumReply
				{user}
				bind:reply={data.replies[num]}
				{num}
				bind:replyingTo
				postId={data.assetId.toString()}
				assetSlug={data.slug}
				postAuthorName={data.creator || ""}
				bind:repliesCollapsed
				pinnable={!reply.parentReplyId}
				refreshReplies={() =>
					async ({ result }) => {
						if (result.type === "success") await invalidateAll()
						refresh++
					}} />
		{/each}
	{/key}
</div>
