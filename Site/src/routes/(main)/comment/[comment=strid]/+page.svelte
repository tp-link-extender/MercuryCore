<script lang="ts">
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Comment from "$components/Comment.svelte"
	import Head from "$components/Head.svelte"
	import PostReply from "$components/PostReply.svelte"
	import type { ActionResult } from "@sveltejs/kit"
	import { superForm } from "sveltekit-superforms"
	import ForumPost from "./ForumPost.svelte"

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

	let mainType = $derived(comment.type[0])
	let breadcrumb = $derived(
		((): { path: [string, string][]; final: string } => {
			if (mainType === "status")
				return { path: [["Status", "/"]], final: "Post" }

			if (mainType === "asset")
				return {
					path: [
						["Catalog", "/catalog"],
						["Asset", "/catalog"]
					],
					final: "Comment"
				}

			if (comment.type.length === 2)
				return {
					path: [
						["Forum", "/forum"],
						["Category", "/forum"]
					],
					final: "Post"
				}

			return {
				path: [
					["Forum", "/forum"],
					["Category", "/forum"],
					["Post", `/comment/${comment.id}`]
				],
				final: "Comment"
			}
		})()
	)
</script>

<Head name={data.siteName} title="Comment" />

<div class="ctnr max-w-280">
	<Breadcrumbs {...breadcrumb} />

	{#if mainType === "forum"}
		<ForumPost {comment} {onResult} {user} />
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
