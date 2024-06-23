<script lang="ts">
	import { enhance } from "$app/forms"
	import { goto, preloadData, pushState } from "$app/navigation"
	import User from "$lib/components/User.svelte"
	import fade from "$lib/fade"

	export let post: import("./$types").PageData["posts"][number]
	export let num: number
	export let total: number
	export let categoryName: string

	let likesDisabled = false
	let dislikesDisabled = false
</script>

<div
	in:fade|global={{ num, total }}
	class="post card bg-darker flex-row overflow-hidden mb-4 h-40 {post.pinned
		? 'border-(solid 1px green-5)!'
		: ''}">
	<form
		use:enhance={({ formData }) => {
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
		}}
		class="bg-a p-1 z-1"
		method="POST"
		action="?/like&id={post.id}">
		<div class="flex flex-col">
			<button
				name="action"
				value={post.likes ? "unlike" : "like"}
				aria-label={post.likes ? "Unlike" : "Like"}
				disabled={likesDisabled}
				class="btn p-1">
				<i
					class="fa{post.likes
						? ' text-emerald-6 hover:text-emerald-3'
						: 'r text-neutral-5 hover:text-neutral-3'}
					fa-thumbs-up transition text-lg" />
			</button>
			<span
				class="py-2 text-center {post.likes
					? 'text-emerald-6 font-bold'
					: post.dislikes
						? 'text-red-5 font-bold'
						: ''}">
				{post.score}
			</span>
			<button
				name="action"
				value={post.dislikes ? "undislike" : "dislike"}
				aria-label={post.dislikes ? "Undislike" : "Dislike"}
				disabled={dislikesDisabled}
				class="btn p-1">
				<i
					class="fa{post.dislikes
						? ' text-red-5 hover:text-red-3'
						: 'r text-neutral-5 hover:text-neutral-3'}
					fa-thumbs-down transition text-lg" />
			</button>
		</div>
	</form>
	<div class="pl-2 flex flex-col w-full">
		<div class="flex pt-2 pl-4">
			<User user={post.author} full />
			<em class="light-text pl-4 self-center">
				{new Date(post.posted).toLocaleString()}
			</em>
		</div>
		<a
			on:click={async e => {
				// Dude.
				// Shallow routing is AWESOME
				if (e.metaKey || innerWidth < 640) return
				e.preventDefault()

				const { href } = e.currentTarget
				const result = await preloadData(href)

				if (result.type === "loaded" && result.status === 200)
					pushState(href, { openPost: result.data })
				else goto(href)
			}}
			href="/forum/{categoryName.toLowerCase()}/{post.id}"
			class="light-text px-4 pt-2 no-underline w-full">
			<h2 class="pt-2">
				{post.title}
			</h2>

			<div class="gradient w-full h-20 absolute bottom-0 left-0" />
			<p class="break-all">
				{post.content[0].text || ""}
			</p>
		</a>
	</div>
</div>

<style lang="stylus">
	.post
		border 1px solid var(--accent2)
		transition all 0.3s ease-out
		&:hover
			background var(--background)
			border 1px solid var(--accent3)

	.gradient
		background linear-gradient(#0000, var(--darker))
</style>
