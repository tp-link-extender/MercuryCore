<script lang="ts">
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Comment from "$components/Comment.svelte"
	import Head from "$components/Head.svelte"
	import PostReply from "$components/PostReply.svelte"
	import type { ActionResult } from "@sveltejs/kit"
	import { superForm } from "sveltekit-superforms"
	import ForumPost from "./ForumPost.svelte"
	import ForumReply from "./ForumReply.svelte"

	let replyingTo = $state("")
	let repliesCollapsed = $state({})

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

	{#if type[0] === "forum"}
		{#if type.length === 2}
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
				bind:repliesCollapsed
				bind:replyingTo
				{user} />
		{/each}
	{:else}
		<h3 class="text-center pt-6">
			No comments yet. Be the first to post one!
		</h3>
	{/if}
</div>
