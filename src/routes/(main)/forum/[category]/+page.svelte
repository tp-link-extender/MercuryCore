<script lang="ts">
	import { page } from "$app/stores"
	import ForumPost from "./ForumPost.svelte"
	import PostPage from "./[post=strid]/+page.svelte"
	import client from "$lib/realtime"

	export let data

	let posts = writable(data.posts)

	onMount(() => {
		client(data.realtimeToken)
			?.newSubscription(`forum:${data.name}`)
			.on("publication", c => {
				const newData = c.data as {
					id: string
					score: number
				}

				posts.update(p => {
					const post = p.find(p => p.id === newData.id)
					if (post) post.score = newData.score
					return p
				})
			})
			.on("subscribing", c => {
				console.log(`subscribing: ${c.code}, ${c.reason}`)
			})
			.on("subscribed", c => {
				console.log("subscribed", c)
			})
			.on("unsubscribed", c => {
				console.log(`unsubscribed: ${c.code}, ${c.reason}`)
			})
			.subscribe()
	})
</script>

<Head title="{data.name} - Forum" />

<div class="ctnr max-w-200">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[data.name, ""]
		]} />

	<h1 class="pb-8">
		{data.name} - Forum
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
