<script lang="ts">
	import { page } from "$app/stores"
	import Breadcrumbs from "$lib/components/Breadcrumbs.svelte"
	import Head from "$lib/components/Head.svelte"
	import fade from "$lib/fade"
	import realtime, { type ForumResponse } from "$lib/realtime"
	import type { Centrifuge, PublicationContext } from "centrifuge"
	import { onDestroy, onMount } from "svelte"
	import { writable } from "svelte/store"
	import ForumPost from "./ForumPost.svelte"
	import PostPage from "./[post=strid]/+page.svelte"

	export let data

	let posts = writable(data.posts)

	function onPub(c: PublicationContext) {
		const newData = c.data as ForumResponse

		posts.update(p => {
			const post = p.find(p => p.id === newData.id)
			if (!post) return p

			post.score = newData.score
			if (newData.hash !== data.user.realtimeHash) return p

			switch (newData.action) {
				case "like":
					post.likes = true
					post.dislikes = false
					break
				case "dislike":
					post.likes = false
					post.dislikes = true
					break
				case "unlike":
				case "undislike":
					post.likes = false
					post.dislikes = false
					break
				default:
			}

			return p
		})
	}

	let client: Centrifuge | undefined
	onMount(() => {
		client = realtime(data.user.realtimeToken, `forum:${data.name}`, onPub)
	})
	onDestroy(() => client?.disconnect())
</script>

<Head title="{data.name} - Forum" />

<div class="ctnr max-w-200">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[data.name, ""]
		]} />

	<h1 class="pb-8">
		{data.name} &ndash; Forum
		<span class="pl-6">
			<a
				href="/forum/create?category={data.name}"
				class="btn btn-primary">
				<fa fa-file class="pr-2" />
				Create post
			</a>
		</span>
	</h1>
	{#if $posts.length > 0}
		{#each $posts as post, num}
			<ForumPost
				{post}
				{num}
				total={$posts.length}
				categoryName={data.name} />
		{/each}
	{:else}
		<h2 class="text-center">
			No posts in this category yet. Be the first to create one!
		</h2>
	{/if}
</div>

{#if $page.state.openPost}
	<div class="modal-static fixed h-full z-10 overflow-y-auto p-10 py-20">
		<div
			transition:fade={{ duration: 200 }}
			role="button"
			tabindex="0"
			on:click={() => history.back()}
			on:keypress={() => history.back()}
			class="modal-backdrop" />
		<div
			transition:fade={{ duration: 100 }}
			class="modal-box bg-background h-full w-full max-w-280 py-10 max-h-initial!">
			<PostPage data={$page.state.openPost} asComponent />
		</div>
	</div>
{/if}
