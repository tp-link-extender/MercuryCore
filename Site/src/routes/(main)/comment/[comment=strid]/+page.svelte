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
	let refresh = $state(0)

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
	const formData = superForm(data.form, { onResult })

	// let topReply = $derived(replies[0])
	// let parentPost = $derived(topReply.parentPost)
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

<div class="ctnr max-w-280">
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

	{#each comment.comments as _, num}
		<Comment
			bind:comment={comment.comments[num]}
			{num}
			refreshReplies={() =>
				async ({ result }) => {
					if (result.type === "success") await invalidateAll()
					refresh++
				}}
			bind:repliesCollapsed
			bind:replyingTo
			user={data.user} />
	{/each}
</div>
