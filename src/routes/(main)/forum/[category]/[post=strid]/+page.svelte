<script lang="ts">
	import { enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$lib/components/Breadcrumbs.svelte"
	import ForumReply from "$lib/components/ForumReply.svelte"
	import Head from "$lib/components/Head.svelte"
	import PinButton from "$lib/components/PinButton.svelte"
	import PostReply from "$lib/components/PostReply.svelte"
	import ReportButton from "$lib/components/ReportButton.svelte"
	import User from "$lib/components/User.svelte"
	import realtime, { type ForumResponse } from "$lib/realtime"
	import type { Centrifuge, PublicationContext } from "centrifuge"
	import { onDestroy, onMount } from "svelte"
	import { writable } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const { user } = data
	export let asComponent = false

	let post = writable(data.post) // this is the svelte 4 thing ever
	let replyingTo = writable("")
	const repliesCollapsed = writable({})
	const formData = superForm(data.form)

	export const snapshot = formData

	let refreshPost = 0
	let refresh = 0

	function searchReplies(
		id: string,
		replies: typeof $post.replies
	): (typeof $post.replies)[0] | undefined {
		for (const reply of replies) {
			if (reply.id === id) return reply

			if (reply.replies.length > 0) {
				const found = searchReplies(id, reply.replies)
				if (found) return found
			}
		}
	}

	function setAction(
		thing: {
			likes: boolean
			dislikes: boolean
		},
		action: ForumResponse["action"]
	) {
		switch (action) {
			case "like":
				thing.likes = true
				thing.dislikes = false
				break
			case "dislike":
				thing.likes = false
				thing.dislikes = true
				break
			case "unlike":
			case "undislike":
				thing.likes = false
				thing.dislikes = false
				break
			default:
		}
		return thing
	}

	function onPub(c: PublicationContext) {
		const newData = c.data as ForumResponse

		// We can do this more normally since we aren't updating nested data
		if (newData.id !== $post.id) {
			if (newData.type === "Reply") return

			post.update(p => {
				const reply = searchReplies(newData.id, p.replies)
				if (!reply) return p

				reply.score = newData.score
				if (newData.hash === data.user.realtimeHash)
					setAction(reply, newData.action)

				return p
			})
			return
		}
		if (newData.type !== "Post") return

		$post.score = newData.score
		if (newData.hash !== data.user.realtimeHash) return

		setAction($post, newData.action)
	}

	let client: Centrifuge | undefined
	onMount(() => {
		client = realtime(
			data.user.realtimeToken,
			`forum:${$post.categoryName}`,
			onPub
		)
	})
	onDestroy(() => client?.disconnect()) // lazy evaluation my beloved

	const likeEnhance: import("./$types").SubmitFunction = ({ formData }) => {
		const action = formData.get("action")

		if (action === "like") {
			$post.likes = true

			if ($post.dislikes) $post.score++
			$post.dislikes = false
			$post.score++
		} else if (action === "dislike") {
			$post.dislikes = true

			if ($post.likes) $post.score--
			$post.likes = false
			$post.score--
		} else if (action === "unlike") {
			$post.likes = false
			$post.score--
		} else if (action === "undislike") {
			$post.dislikes = false
			$post.score++
		}

		return () => {}
	}

	const refreshReplies: import("./$types").SubmitFunction =
		() =>
		async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			// Reload the post with the data including the new reply, as the form that posted the reply didn't do that
			$post = data.post
			refresh++
		}
</script>

<Head title={$post.title} />

<div class="ctnr max-w-280 light-text">
	{#if !asComponent}
		<!--
			Breadcrumbs can give confusing behaviour if linking
			to the same page the component is shallow-routed on
		-->
		<Breadcrumbs
			path={[
				["Forum", "/forum"],
				[$post.categoryName, `/forum/${$post.categoryName}`],
				[$post.title, ""]
			]} />
	{/if}

	{#key refreshPost}
		<div
			class="post card bg-darker flex-row overflow-hidden {$post.pinned
				? 'border-(solid 1px green-5)!'
				: ''}">
			<form
				use:enhance={likeEnhance}
				class="bg-a p-1"
				method="POST"
				action="?/like&id={$post.id}">
				<div class="flex flex-col">
					<button
						name="action"
						value={$post.likes ? "unlike" : "like"}
						aria-label={$post.likes ? "Unlike" : "Like"}
						class="btn p-1">
						<i
							class="fa{$post.likes
								? ' text-emerald-6 hover:text-emerald-3'
								: 'r text-neutral-5 hover:text-neutral-3'}
						fa-thumbs-up transition text-lg" />
					</button>
					<span
						class="py-2 text-center {$post.likes
							? 'text-emerald-6 font-bold'
							: $post.dislikes
								? 'text-red-5 font-bold'
								: ''}">
						{$post.score}
					</span>
					<button
						name="action"
						value={$post.dislikes ? "undislike" : "dislike"}
						aria-label={$post.dislikes ? "Undislike" : "Dislike"}
						class="btn p-1">
						<i
							class="fa{$post.dislikes
								? ' text-red-5 hover:text-red-3'
								: 'r text-neutral-5 hover:text-neutral-3'}
						fa-thumbs-down transition text-lg" />
					</button>
				</div>
			</form>
			<div class="p-4 pl-6 no-underline light-text w-full">
				<span class="flex justify-between">
					<div class="flex">
						<User user={$post.author} full />
						<i class="pl-4 self-center">
							{new Date($post.posted).toLocaleString()}
						</i>
					</div>
					<span>
						{#if user.permissionLevel >= 4}
							<PinButton
								refreshReplies={() => refreshPost++}
								id={$post.id}
								pinned={$post.pinned}
								post />
						{/if}
						<ReportButton
							user={$post.author.username}
							url="/forum/{$post.categoryName}/{$post.id}" />
					</span>
				</span>
				<h2 class="text-xl pt-2">
					{$post.title}
				</h2>
				<p class="break-all">
					{$post.content[0].text || ""}
				</p>
			</div>
		</div>
	{/key}

	<PostReply {formData} />

	{#key refresh}
		{#if $post.replies.length > 0}
			{#each $post.replies as reply, num}
				<ForumReply
					{user}
					{reply}
					{num}
					{replyingTo}
					categoryName={$post.categoryName}
					postId={$post.id}
					postAuthorName={$post.author.username}
					{repliesCollapsed}
					topLevel={false}
					pinnable
					{refreshReplies} />
			{/each}
		{:else}
			<h3 class="text-center pt-6">
				No replies yet. Be the first to post one!
			</h3>
		{/if}
	{/key}
</div>

<style>
	.post {
		border: 1px solid var(--accent2);
	}
</style>
