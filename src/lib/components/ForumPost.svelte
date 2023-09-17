<script lang="ts">
	// lel, anything for intellisense
	export let post: import("../../routes/(main)/forum/[category]/$types").PageData["posts"][number]
	export let num: number
	export let total: number
	export let categoryName: string

	let likesDisabled = false,
		dislikesDisabled = false

	post.id = post.id.split(":")[1]
</script>

<div in:fade|global={{ num, total }} class="post card bg-darker mb-4 flex-row">
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
		<div class="mb-2 d-flex flex-column">
			<div class="text-center">
				<button
					name="action"
					value={post.likes ? "unlike" : "like"}
					aria-label={post.likes ? "Unlike" : "Like"}
					disabled={likesDisabled}
					class="btn btn-sm {post.likes
						? 'btn-success'
						: 'btn-outline-success'}">
					<i class="fa{post.likes ? '' : 'r'} fa-thumbs-up" />
				</button>
			</div>
			<span
				class="my-2 text-center {post.likes
					? 'text-success font-bold'
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
			<!-- <div id="replycount" class="d-flex">
				<div class="mt-auto"><i class="far fa-message" /> {post._count.replies}</div>
			</div> -->
		</div>
	</form>
	<div class="d-flex flex-column w-100">
		<div class="d-flex pt-2 ps-4">
			<User user={post.author} full />
			<em class="light-text ps-4 align-self-center">
				{post.posted.toLocaleString()}
			</em>
		</div>
		<a
			href="/forum/{categoryName.toLowerCase()}/{post.id}"
			class="px-4 pt-2 text-decoration-none light-text w-100">
			<h2 class="fs-4 mt-2">
				{post.title}
			</h2>

			<div class="mb-0">
				<div class="gradient w-100 h-75" />
				{post.content[0][0].text}
			</div>
		</a>
	</div>
</div>

<style lang="stylus">
	.sidebar
		z-index 1
		// min-width 3rem

	// #replycount
	// 	justify-content center

	.post
		height 10rem
		overflow hidden
		word-break break-word

		border-color var(--accent2)
		transition all 0.3s ease-out
		&:hover
			background var(--background)
			border-color var(--accent3)

	.gradient
		position absolute
		bottom 0
		left 0
		height 5rem !important
		background linear-gradient(#0000, var(--darker))
</style>
