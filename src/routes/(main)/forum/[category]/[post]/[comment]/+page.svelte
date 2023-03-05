<script lang="ts">
	import type { PageData } from "./$types"
	import ForumReply from "$lib/components/ForumReply.svelte"
	import { writable } from "svelte/store"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data: PageData
	const baseDepth = writable(data.baseDepth)
</script>

<svelte:head>
	<title>Replies to forum post - Mercury</title>
</svelte:head>

<div class="container light-text">
	{#each data.replies as reply, num}
		<ForumReply {reply} {num} {replyingTo} forumCategory={data.forumCategory} postId={data.postId} postAuthorName={data.author} {repliesCollapsed} {baseDepth} />
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 70rem
</style>
