<script lang="ts">
	import { enhance as enhance2 } from "$app/forms"
	import superForm from "$lib/superForm"

	export let data
	const { user } = data
	export let asComponent = false

	let replyingTo = writable("")
	const repliesCollapsed = writable({})
	const formData = superForm(data.form)

	export const snapshot = formData
</script>

<Head title={data.title} />

<div class="ctnr max-w-280 light-text">
	{#if !asComponent}
		<!--
			Breadcrumbs can give confusing behaviour if linking
			to the same page the component is shallow-routed on
		-->
		<Breadcrumbs
			path={[
				["Forum", "/forum"],
				[data.categoryName, `/forum/${data.categoryName}`],
				[data.title, ""],
			]} />
	{/if}

	<div class="post card bg-darker flex-row">
		<form
			use:enhance2={({ formData }) => {
				const action = formData.get("action")

				if (action == "like") {
					data.likes = true

					if (data.dislikes) data.dislikeCount--
					data.dislikes = false
					data.likeCount++
				} else if (action == "dislike") {
					data.dislikes = true

					if (data.likes) data.likeCount--
					data.likes = false
					data.dislikeCount++
				} else if (action == "unlike") {
					data.likes = false
					data.likeCount--
				} else if (action == "undislike") {
					data.dislikes = false
					data.dislikeCount--
				}

				return () => {}
			}}
			class="sidebar bg-a mr-2 p-1"
			method="POST"
			action="?/like&id={data.id}">
			<div class="flex flex-col">
				<button
					name="action"
					value={data.likes ? "unlike" : "like"}
					aria-label={data.likes ? "Unlike" : "Like"}
					class="btn p-1">
					<i
						class="fa{data.likes
							? ' text-emerald-6 hover:text-emerald-3'
							: 'r text-neutral-5 hover:text-neutral-3'}
						fa-thumbs-up transition text-lg" />
				</button>
				<span
					class="py-2 text-center {data.likes
						? 'text-emerald-6 font-bold'
						: data.dislikes
							? 'text-red-5 font-bold'
							: ''}">
					{data.likeCount - data.dislikeCount}
				</span>
				<button
					name="action"
					value={data.dislikes ? "undislike" : "dislike"}
					aria-label={data.dislikes ? "Undislike" : "Dislike"}
					class="btn p-1">
					<i
						class="fa{data.dislikes
							? ' text-red-5 hover:text-red-3'
							: 'r text-neutral-5 hover:text-neutral-3'}
						fa-thumbs-down transition text-lg" />
				</button>
			</div>
		</form>
		<div class="p-4 no-underline light-text w-full">
			<span class="flex">
				<User user={data.author} full />
				<em class="pl-4 self-center">
					{new Date(data.posted).toLocaleString()}
				</em>
				<span class="ms-auto">
					<ReportButton
						user={data.author.username}
						url="/forum/{data.categoryName}/{data.id}" />
				</span>
			</span>
			<h2 class="text-base mt-2">
				{data.title}
			</h2>
			<p>
				{data.content[0].text || ""}
			</p>
		</div>
	</div>

	<PostReply {formData} />

	{#each data.replies as reply, num}
		<ForumReply
			{user}
			{reply}
			{num}
			{replyingTo}
			categoryName={data.categoryName}
			postId={data.id}
			postAuthorName={data.author.username}
			{repliesCollapsed}
			topLevel />
	{/each}
</div>

<style lang="stylus">
	.sidebar
		width 2.5rem

	.post
		border 1px solid var(--accent2)

	p
		word-break break-word
</style>
