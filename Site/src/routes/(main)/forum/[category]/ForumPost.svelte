<script lang="ts">
	import CommentLike from "$components/CommentLike.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"
	import type { LikeEnhance } from "$lib/like2"

	const {
		likeForm,
		num,
		post,
		total
	}: {
		likeForm: LikeEnhance
		num: number
		post: import("./$types").PageData["posts"][number]
		total: number
	} = $props()

	let hidden = $derived(post.visibility !== "Visible")
</script>

<div
	in:fade|global={{ num, total }}
	class={[
		"card bg-darker flex-row overflow-hidden h-40 border-(1px solid)",
		{ "border-green-5!": post.pinned }
	]}>
	<CommentLike
		class={["bg-a p-1 z-1", { "opacity-33": hidden }]}
		{likeForm}
		comment={post} />
	<div class={["pl-2 flex flex-col w-full", { "opacity-33": hidden }]}>
		<div class="flex pt-4 px-4 justify-between items-center w-full">
			<User user={post.author} full />
			<em class="light-text px-4">
				{post.created.toLocaleString()}
			</em>
		</div>
		<a
			href="/comment/{post.id}"
			class="light-text px-4 pt-2 no-underline w-full">
			<div class="gradient w-full h-20 absolute bottom-0 left-0"></div>
			<p class="break-all text-lg whitespace-pre-line">
				{post.currentContent}
			</p>
		</a>
	</div>
</div>

<style>
	.card {
		border-color: var(--accent2);
		transition: all 0.3s ease-out;
		&:hover {
			background: var(--background);
			border: 1px solid var(--accent3);
		}
	}

	.gradient {
		background: linear-gradient(rgba(0, 0, 0, 0), var(--darker));
	}
</style>
