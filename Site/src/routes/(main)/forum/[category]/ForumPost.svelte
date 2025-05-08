<script lang="ts">
	import { enhance } from "$app/forms"
	import CommentLike from "$components/CommentLike.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"
	import { likeEnhance } from "$lib/like"

	let {
		post = $bindable(),
		num,
		total
	}: {
		post: import("./$types").PageData["posts"][number]
		num: number
		total: number
	} = $props()
</script>

<div
	in:fade|global={{ num, total }}
	class={[
		"card bg-darker flex-row overflow-hidden h-40",
		{ "border-(solid 1px green-5)!": post.pinned }
	]}>
	<form
		use:enhance={likeEnhance(post, p => {
			post = p
		})}
		method="POST"
		action="?/like&id={post.id}"
		class="bg-a p-1 z-1">
		<CommentLike comment={post} />
	</form>
	<div class="pl-2 flex flex-col w-full">
		<div class="flex pt-4 pl-4">
			<User user={post.author} full />
			<em class="light-text pl-4 self-center">
				{post.created.toLocaleString()}
			</em>
		</div>
		<a
			href="/comment/{post.id}"
			class="light-text px-4 pt-2 no-underline w-full">
			<div class="gradient w-full h-20 absolute bottom-0 left-0"></div>
			<p class="break-all text-lg">
				{post.currentContent}
			</p>
		</a>
	</div>
</div>

<style>
	.card {
		border: 1px solid var(--accent2);
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
