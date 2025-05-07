<script lang="ts">
	import { enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import Comment from "$components/Comment.svelte"
	import Head from "$components/Head.svelte"
	import PinButton from "$components/PinButton.svelte"
	import PostReply from "$components/PostReply.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import type { ActionResult } from "@sveltejs/kit"
	import { superForm } from "sveltekit-superforms"

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
		// Reload the post with the data including the new reply, as the form that posted the reply didn't do that
		comment = data.comment
	}
	const formData = superForm(data.form, { onResult })

	// let topReply = $derived(replies[0])
	// let parentPost = $derived(topReply.parentPost)

	let mainType = $derived(comment.type[0])
	let path: [string, string][] = $derived(
		mainType === "forum" ? [["Forum", "/forum"]] : []
	)

	const likeEnhance: import("@sveltejs/kit").SubmitFunction = ({
		formData
	}) => {
		const action = formData.get("action")

		if (action === "like") {
			comment.likes = true

			if (comment.dislikes) comment.score++
			comment.dislikes = false
			comment.score++
		} else if (action === "dislike") {
			comment.dislikes = true

			if (comment.likes) comment.score--
			comment.likes = false
			comment.score--
		} else if (action === "unlike") {
			comment.likes = false
			comment.score--
		} else if (action === "undislike") {
			comment.dislikes = false
			comment.score++
		}

		return () => {}
	}

	const refreshReplies: import("./$types").SubmitFunction = () => onResult
</script>

<Head name={data.siteName} title="Comment" />

<div class="ctnr max-w-280">
	<Breadcrumbs {path} />

	{#if mainType === "forum"}
		<div
			class={[
				"post card bg-darker flex-row",
				{ "border-(solid 1px green-5)!": comment.pinned }
			]}>
			<form
				use:enhance={likeEnhance}
				method="POST"
				action="?/like&id={comment.id}"
				class="bg-a p-1 rounded-l-1">
				<div class="flex flex-col">
					<button
						name="action"
						value={comment.likes ? "unlike" : "like"}
						aria-label={comment.likes ? "Unlike" : "Like"}
						class="btn p-1">
						<fa
							fa-thumbs-up
							class="transition text-lg {comment.likes
								? 'text-emerald-600 hover:text-emerald-300'
								: 'text-neutral-600 hover:text-neutral-400'}">
						</fa>
					</button>
					<span
						class={[
							"py-2 text-center",
							{
								"text-emerald-600 font-bold": comment.likes,
								"text-red-500 font-bold": comment.dislikes
							}
						]}>
						{comment.score}
					</span>
					<button
						name="action"
						value={comment.dislikes ? "undislike" : "dislike"}
						aria-label={comment.dislikes ? "Undislike" : "Dislike"}
						class="btn p-1">
						<fa
							fa-thumbs-down
							class="transition text-lg {comment.dislikes
								? 'text-red-500 hover:text-red-300'
								: 'text-neutral-600 hover:text-neutral-400'}">
						</fa>
					</button>
				</div>
			</form>
			<div class="p-4 pl-6 no-underline w-full">
				<span class="flex justify-between">
					<div class="flex">
						<User user={comment.author} full />
						<i class="pl-4 self-center">
							{comment.created.toLocaleString()}
						</i>
					</div>
					<span class="dropdown">
						<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
						<div class="dropdown-content pt-2">
							<ul class="p-2 rounded-3">
								{#if user.permissionLevel >= 4}
									<PinButton
										{refreshReplies}
										id={comment.id}
										pinned={comment.pinned}
										post />
								{/if}
								<ReportButton
									user={comment.author.username}
									url="/comment/{comment.id}" />
							</ul>
						</div>
					</span>
				</span>
				<p class="break-all">
					{comment.content[0].text}
				</p>
			</div>
		</div>
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
