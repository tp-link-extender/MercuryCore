<script lang="ts">
	import { enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import Breadcrumbs from "$components/Breadcrumbs.svelte"
	import ForumReply from "$components/ForumReply.svelte"
	import Head from "$components/Head.svelte"
	import PinButton from "$components/PinButton.svelte"
	import PostReply from "$components/PostReply.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import { writable } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	const { data } = $props()

	const { user } = data

	let post = writable(data.post) // this is the svelte 4 thing ever
	let replyingTo = writable("")

	let refresh = $state(0)

	const repliesCollapsed = writable({})

	type ActionResult = import("@sveltejs/kit").ActionResult // I promise there's a reason
	async function onResult({ result }: { result: ActionResult }) {
		if (result.type === "success") await invalidateAll()
		// Reload the post with the data including the new reply, as the form that posted the reply didn't do that
		$post = data.post
		refresh++
	}
	const formData = superForm(data.form, { onResult })
	export const snapshot = formData

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

	const refreshReplies: import("./$types").SubmitFunction = () => onResult
</script>

<Head name={data.siteName} title={$post.title} />

<div class="ctnr max-w-280 light-text">
	<Breadcrumbs
		path={[
			["Forum", "/forum"],
			[$post.categoryName, `/forum/${$post.categoryName}`],
			[$post.title, ""]
		]} />

	<div
		class="post card bg-darker flex-row {$post.pinned
			? 'border-(solid 1px green-5)!'
			: ''}">
		<form
			use:enhance={likeEnhance}
			method="POST"
			action="?/like&id={$post.id}"
			class="bg-a p-1">
			<div class="flex flex-col">
				<button
					name="action"
					value={$post.likes ? "unlike" : "like"}
					aria-label={$post.likes ? "Unlike" : "Like"}
					class="btn p-1">
					<fa
						fa-thumbs-up
						class="transition text-lg {$post.likes
							? 'text-emerald-600 hover:text-emerald-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
				<span
					class="py-2 text-center {$post.likes
						? 'text-emerald-600 font-bold'
						: $post.dislikes
							? 'text-red-500 font-bold'
							: ''}">
					{$post.score}
				</span>
				<button
					name="action"
					value={$post.dislikes ? "undislike" : "dislike"}
					aria-label={$post.dislikes ? "Undislike" : "Dislike"}
					class="btn p-1">
					<fa
						fa-thumbs-down
						class="transition text-lg {$post.dislikes
							? 'text-red-500 hover:text-red-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
			</div>
		</form>
		<div class="p-4 pl-6 no-underline w-full">
			<span class="flex justify-between">
				<div class="flex">
					<User user={$post.author} full />
					<i class="pl-4 self-center">
						{new Date($post.posted).toLocaleString()}
					</i>
				</div>
				<span class="dropdown">
					<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							{#if user.permissionLevel >= 4}
								<PinButton
									{refreshReplies}
									id={$post.id}
									pinned={$post.pinned}
									post />
							{/if}
							<ReportButton
								user={$post.author.username}
								url="/forum/{$post.categoryName}/{$post.id}" />
						</ul>
					</div>
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
			<h3 class="text-center pt-6">No replies yet.</h3>
			<h4 class="text-center pt-4">Be the first to post one!</h4>
		{/if}
	{/key}
</div>

<style>
	.post {
		border: 1px solid var(--accent2);
	}
</style>
