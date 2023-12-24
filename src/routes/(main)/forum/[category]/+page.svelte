<script lang="ts">
	import { page } from "$app/stores"
	import ForumPost from "./ForumPost.svelte"
	import PostPage from "./[post]/+page.svelte"

	export let data
	// Forum
</script>

<Head title="{data.name} - Forum" />

<div class="ctnr light-text">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[data.name, ""],
		]} />

	<h1 class="pb-8">
		{data.name} - Forum
		<span class="ps-6">
			<a
				href="/forum/create?category={data.name}"
				class="btn btn-primary">
				<fa fa-file class="pe-2" />
				Create post
			</a>
		</span>
	</h1>
	{#each data.posts as post, num}
		<ForumPost
			{post}
			{num}
			total={data.posts.length}
			categoryName={data.name} />
	{/each}
</div>

{#if $page.state.openPost}
	<div class="modal-static fixed w-100 h-100 z-10 overflow-y-auto py-20">
		<div
			transition:fade={{ duration: 200 }}
			role="button"
			tabindex="0"
			on:click={() => history.back()}
			on:keypress={() => history.back()}
			class="modal-backdrop vh-100 w-100" />
		<div
			transition:fade={{ duration: 100 }}
			class="modal-box bg-background h-100 py-10">
			<PostPage data={$page.state.openPost} asComponent />
		</div>
	</div>
{/if}

<style lang="stylus">
	containerMinWidth()

	.modal-box
		min-width 70rem
		max-height initial !important
</style>
