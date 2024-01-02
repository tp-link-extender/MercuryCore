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
			<div class="flex flex-col pb-2">
				<div>
					<button
						name="action"
						value={data.likes ? "unlike" : "like"}
						aria-label={data.likes ? "Unlike" : "Like"}
						class="btn btn-sm {data.likes
							? 'btn-success'
							: 'btn-outline-success'}">
						<i class="fa{data.likes ? '' : 'r'} fa-thumbs-up" />
					</button>
				</div>
				<span
					class="py-2 text-center {data.likes
						? 'text-success font-bold'
						: data.dislikes
							? 'text-danger font-bold'
							: ''}">
					{data.likeCount - data.dislikeCount}
				</span>
				<div>
					<button
						name="action"
						value={data.dislikes ? "undislike" : "dislike"}
						aria-label={data.dislikes ? "Undislike" : "Dislike"}
						class="btn btn-sm {data.dislikes
							? 'btn-danger'
							: 'btn-outline-danger'}">
						<i
							class="fa{data.dislikes
								? ''
								: 'r'} fa-thumbs-down" />
					</button>
				</div>
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
