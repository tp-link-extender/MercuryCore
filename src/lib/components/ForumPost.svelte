<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"
	import type { PageData } from "../../routes/(main)/forum/[category]/$types"

	export let post: PageData["posts"][0]
	export let num: number
	export let total: number
	export let categoryName: string

	let likesDisabled = false
	let dislikesDisabled = false
</script>

<div in:fade|global={{ num, total }} class="post card bg-darker mb-3 flex-row">
	<form
		use:enhance={({ formData }) => {
			const action = formData.get("action")

			if (action == "like") {
				post.likes = true

				if (post.dislikes) post.dislikeCount--
				post.dislikes = false
				post.likeCount++
			} else if (action == "dislike") {
				post.dislikes = true

				if (post.likes) post.likeCount--
				post.likes = false
				post.dislikeCount++
			} else if (action == "unlike") {
				post.likes = false
				post.likeCount--
			} else if (action == "undislike") {
				post.dislikes = false
				post.dislikeCount--
			}

			return () => {}
		}}
		class="sidebar bg-a me-2 p-1"
		method="POST"
		action="?/like&id={post.id}">
		<div class="mb-2 flex flex-col">
			<div class="text-center">
				<button
					name="action"
					value={post.likes ? "unlike" : "like"}
					aria-label={post.likes ? "Unlike" : "Like"}
					disabled={likesDisabled}
					class="btn btn-sm {post.likes
						? 'bg-emerald-600 hover:bg-emerald-800 text-white'
						: 'btn-outline-success'}">
					<i class="fa{post.likes ? '' : 'r'} fa-thumbs-up" />
				</button>
			</div>
			<span
				class="my-2 text-center {post.likes
					? 'text-emerald-500 font-bold'
					: post.dislikes
					? 'text-danger font-bold'
					: ''}">
				{post.likeCount - post.dislikeCount}
			</span>
			<div class="text-center">
				<button
					name="action"
					value={post.dislikes ? "undislike" : "dislike"}
					aria-label={post.dislikes ? "Undislike" : "Dislike"}
					disabled={dislikesDisabled}
					class="btn btn-sm {post.dislikes
						? 'btn-danger'
						: 'btn-outline-danger'}">
					<i class="fa{post.dislikes ? '' : 'r'} fa-thumbs-down" />
				</button>
			</div>
			<!-- <div id="replycount" class="flex">
				<div class="mt-auto"><i class="far fa-message" /> {post._count.replies}</div>
			</div> -->
		</div>
	</form>
	<div class="flex flex-col w-100">
		<a
			href="/user/{post.author.number}"
			class="user flex light-text no-underline m-2 pe-4 mb-0 w-100">
			<span class="pfp bg-a2 rounded-circle me-1">
				<img
					src="/api/avatar/{post.author.username}"
					alt={post.author.username}
					class="rounded-circle rounded-top-0" />
			</span>
			<span class="font-bold ms-2">
				{post.author.username}
			</span>
			<em class="ms-auto">
				{post.posted.toLocaleString()}
			</em>
		</a>
		<a
			href="/forum/{categoryName.toLowerCase()}/{post.id}"
			class="p-3 pb-0 no-underline light-text w-100">
			<h2 class="h4 mt-2">
				{post.title}
			</h2>

			<div class="mb-0">
				<div class="gradient w-100 h-75" />
				{post.content[0].text}
			</div>
		</a>
	</div>
</div>

<style lang="sass">
	.sidebar
		z-index: 1
		// min-width: 3rem

	// #replycount
	// 	justify-content: center

	.post
		height: 10rem
		overflow: hidden
		word-break: break-word

		border-color: var(--accent2)
		transition: all 0.3s ease-out
		&:hover
			background: var(--background)
			border-color: var(--accent3)

	.gradient
		position: absolute
		bottom: 0
		left: 0
		height: 5rem !important
		background: linear-gradient(#0000, var(--darker))

	.user
		align-items: center 
		.pfp img
			max-width: 2rem
			width: 2rem
</style>
