<script lang="ts">
	import { enhance as enhance2 } from "$app/forms"
	import { superForm } from "sveltekit-superforms/client"

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
				[data.title, ""]
			]} />
	{/if}

	<div class="post card bg-darker flex-row overflow-hidden">
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
			class="bg-a p-1"
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
		<div class="p-4 pl-6 no-underline light-text w-full">
			<span class="flex justify-between">
				<div class="flex">
					<User user={data.author} full />
					<i class="pl-4 self-center">
						{new Date(data.posted).toLocaleString()}
					</i>
				</div>
				<span>
					<ReportButton
						user={data.author.username}
						url="/forum/{data.categoryName}/{data.id}" />
				</span>
			</span>
			<h2 class="text-xl pt-2">
				{data.title}
			</h2>
			<p class="break-all">
				{data.content[0].text || ""}
			</p>
		</div>
	</div>

	<PostReply {formData} />

	{#if data.replies.length > 0}
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
	{:else}
		<h3 class="text-center pt-6">
			No replies yet. Be the first to post one!
		</h3>
	{/if}
</div>

<style lang="stylus">
	.post
		border 1px solid var(--accent2)
</style>
