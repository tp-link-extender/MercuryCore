<script lang="ts">
	import type { ActionResult } from "@sveltejs/kit"
	import { superForm } from "sveltekit-superforms"
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Comment from "$components/Comment.svelte"
	import Head from "$components/Head.svelte"
	import PostReply from "$components/PostReply.svelte"
	import ForumPost from "./ForumPost.svelte"
	import ForumReply from "./ForumReply.svelte"

	let replyingTo = $state("")
	let commentsCollapsed = $state({})

	const { data } = $props()

	const { user } = data

	let comment = $state(data.comment)
	$effect(() => {
		comment = data.comment
	})

	async function onResult({ result }: { result: ActionResult }) {
		if (result.type === "success") await invalidateAll()
		comment = data.comment
	}
	const formData = superForm(data.form)

	// let topReply = $derived(replies[0])
	// let parentPost = $derived(topReply.parentPost)
	let comments = $derived(comment.comments)
	let type = $derived(comment.type)

	const elide = (c: string) => (c.length > 50 ? `${c.slice(0, 50)}...` : c)

	function getBreadcrumb(): [string, string][] {
		if (type[0] === "status") return [["Status", "/"]]

		if (type[0] === "asset")
			return [
				["Catalog", "/catalog"],
				["Asset", "/catalog"]
			]

		if (comment.type.length === 2)
			return [
				["Forum", "/forum"],
				[
					comment.info.category || "Category",
					`/forum/${comment.info.category?.toLowerCase()}`
				]
			]

		return [
			["Forum", "/forum"],
			[
				comment.info.category || "Category",
				`/forum/${comment.info.category?.toLowerCase()}`
			],
			[elide(comment.info.post || "Post"), `/comment/${comment.type[2]}`]
		]
	}
</script>

<Head name={data.siteName} title="Comment" />

<!-- huge padding cuz otherwise the dropdown on the bottom comments arent visible lmfao -->
<div class={["ctnr max-w-280", { "pb-32": comments.length > 0 }]}>
	<Breadcrumbs
		path={getBreadcrumb()}
		final={elide(comment.content[0].text)} />

	{#if comment.visibility === "Deleted" || comment.visibility === "Moderated"}
		<div class="pt-2 pb-6">
			<div class="alert alert-red" role="alert">
				<fa class="pr-4" fa-eye-slash></fa>
				<b>
					This comment has been {comment.visibility === "Deleted"
						? "deleted"
						: "removed"}.
				</b>
				{#if type[0] === "forum" && type.length === 2}
					It will no longer appear in forum category pages or in
					recent post sections.
				{/if}
			</div>
		</div>
	{/if}

	<!-- These are just different ways of displaying exactly the same information -->
	{#if type[0] === "forum"}
		{#if type.length === 2}
			<ForumPost {comment} {onResult} {user} />
		{:else}
			<ForumReply {comment} {onResult} {user} />
		{/if}
	{:else if type[0] === "status"}
		{#if type.length === 1}
			<ForumPost {comment} {onResult} {user} />
		{:else}
			<ForumReply {comment} {onResult} {user} />
		{/if}
	{/if}

	<PostReply {formData} />

	{#if comments.length > 0}
		{#each comments as _, num}
			<Comment
				bind:comment={comments[num]}
				{num}
				bind:commentsCollapsed
				bind:replyingTo
				{user} />
		{/each}
	{:else}
		<h3 class="text-center pt-6">
			No comments yet. Be the first to post one!
		</h3>
	{/if}
</div>
