<script lang="ts">
	import { enhance } from "$app/forms"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	const {
		post = $bindable(),
		num,
		total,
		categoryName
	}: {
		post: import("./$types").PageData["posts"][number]
		num: number
		total: number
		categoryName: string
	} = $props()

	let likesDisabled = false
	let dislikesDisabled = false

	const likeEnhance: import("./$types").SubmitFunction = ({ formData }) => {
		const action = formData.get("action")

		if (action === "like") {
			post.likes = true

			if (post.dislikes) post.score++
			post.dislikes = false
			post.score++
		} else if (action === "dislike") {
			post.dislikes = true

			if (post.likes) post.score--
			post.likes = false
			post.score--
		} else if (action === "unlike") {
			post.likes = false
			post.score--
		} else if (action === "undislike") {
			post.dislikes = false
			post.score++
		}

		return () => {}
	}
</script>

<div
	in:fade|global={{ num, total }}
	class={[
		"card bg-darker flex-row overflow-hidden h-40",
		{ "border-(solid 1px green-5)!": post.pinned }
	]}>
	<form
		use:enhance={likeEnhance}
		method="POST"
		action="?/like&id={post.id}"
		class="bg-a p-1 z-1">
		<div class="flex flex-col">
			<button
				name="action"
				value={post.likes ? "unlike" : "like"}
				aria-label={post.likes ? "Unlike" : "Like"}
				disabled={likesDisabled}
				class="btn p-1">
				<fa
					fa-thumbs-up
					class="transition text-lg {post.likes
						? 'text-emerald-600 hover:text-emerald-300'
						: 'text-neutral-600 hover:text-neutral-400'}">
				</fa>
			</button>
			<span
				class={[
					"py-2 text-center",
					{
						"text-emerald-600 font-bold": post.likes,
						"text-red-500 font-bold": post.dislikes
					}
				]}>
				{post.score}
			</span>
			<button
				name="action"
				value={post.dislikes ? "undislike" : "dislike"}
				aria-label={post.dislikes ? "Undislike" : "Dislike"}
				disabled={dislikesDisabled}
				class="btn p-1">
				<fa
					fa-thumbs-down
					class="transition text-lg {post.dislikes
						? 'text-red-500 hover:text-red-300'
						: 'text-neutral-600 hover:text-neutral-400'}">
				</fa>
			</button>
		</div>
	</form>
	<div class="pl-2 flex flex-col w-full">
		<div class="flex pt-2 pl-4">
			<User user={post.author} full />
			<em class="light-text pl-4 self-center">
				{post.created.toLocaleString()}
			</em>
		</div>
		<a
			href="/forum/{categoryName.toLowerCase()}/{post.id}"
			class="light-text px-4 pt-2 no-underline w-full">
			<h2 class="pt-2">
				{post.title}
			</h2>

			<div class="gradient w-full h-20 absolute bottom-0 left-0"></div>
			<p class="break-all">
				{post.content[0].text || ""}
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
