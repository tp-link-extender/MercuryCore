<script lang="ts">
	import { enhance } from "$app/forms"
	import DeleteButton from "$components/DeleteButton.svelte"
	import ForumReply from "$components/ForumReply.svelte"
	import type {
		RepliesCollapsed,
		Reply,
		UserType
	} from "$components/ForumReply.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import type { Writable } from "svelte/store"

	export let user: UserType
	export let reply: Reply

	export let num: number
	export let depth = 0
	export let replyingTo: Writable<string>
	export let postAuthorName: string
	export let categoryName = ""
	export let postId: string
	export let assetSlug = ""

	const baseUrl = categoryName
		? `forum/${categoryName.toLowerCase()}/${postId}`
		: `catalog/${postId}/${assetSlug}`

	export let repliesCollapsed: RepliesCollapsed
	export let topLevel = true
	export let pinnable = false
	export let refreshReplies: import("@sveltejs/kit").SubmitFunction

	let content = "" // Allows current reply to not be lost on clicking to another reply

	$: hidden = reply.visibility !== "Visible"

	const likeEnhance: import("@sveltejs/kit").SubmitFunction = ({
		formData
	}) => {
		const action = formData.get("action")

		if (action === "like") {
			reply.likes = true

			if (reply.dislikes) reply.score++
			reply.dislikes = false
			reply.score++
		} else if (action === "dislike") {
			reply.dislikes = true

			if (reply.likes) reply.score--
			reply.likes = false
			reply.score--
		} else if (action === "unlike") {
			reply.likes = false
			reply.score--
		} else if (action === "undislike") {
			reply.dislikes = false
			reply.score++
		}

		return () => {}
	}
</script>

<div class="flex w-full">
	<div class="w-full">
		<div class="flex items-center pt-2">
			<a
				href="/user/{reply.author.username}"
				class="userlink items-center no-underline flex flex-row font-bold {reply
					.author.username === postAuthorName
					? assetSlug
						? 'text-yellow-500'
						: 'text-blue-600'
					: ''}"
				class:light-text={reply.author.username !== postAuthorName}
				class:opacity-33={hidden}
				class:pl-4={!topLevel}>
				{#if topLevel}
					<User
						user={reply.author}
						thin
						size="1.5rem"
						image
						class="pr-4" />
				{/if}
				{reply.author.username}
				{#if reply.author.username === postAuthorName}
					<fa
						class="{assetSlug
							? 'fa-hammer'
							: 'fa-microphone'} pl-2">
					</fa>
				{/if}
			</a>
			<small class="light-text pl-6">
				{new Date(reply.posted).toLocaleString()}
			</small>
		</div>
		<p class="py-2 m-0 break-all {hidden ? 'opacity-33' : ''}">
			{reply.content[0].text}
		</p>
		{#if $replyingTo !== reply.id}
			<form
				use:enhance={likeEnhance}
				method="POST"
				action="?/like&rid={reply.id}"
				class="inline pr-2 {hidden ? 'opacity-33' : ''}">
				<button
					name="action"
					value={reply.likes ? "unlike" : "like"}
					aria-label={reply.likes ? "Unlike" : "Like"}
					class="size-6 p-0 btn">
					<fa
						fa-thumbs-up
						class="transition {reply.likes
							? 'text-emerald-600 hover:text-emerald-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
				<span
					class="text-center {reply.likes
						? 'text-emerald-600 font-bold'
						: reply.dislikes
							? 'text-red-500 font-bold'
							: ''}">
					{reply.score}
				</span>
				<button
					name="action"
					value={reply.dislikes ? "undislike" : "dislike"}
					aria-label={reply.dislikes ? "Undislike" : "Dislike"}
					class="btn size-6 p-0">
					<fa
						fa-thumbs-down
						class="transition {reply.dislikes
							? 'text-red-500 hover:text-red-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
			</form>
			<a
				href="/forum/{categoryName}/{postId}/{reply.id}"
				on:click|preventDefault={() => replyingTo.set(reply.id)}
				class="btn btn-sm p-0 px-1 text-neutral-5
				hover:text-neutral-300 {hidden ? 'opacity-33' : ''}">
				<fa fa-message class="pr-2"></fa>
				Reply
			</a>
			{#if !hidden}
				<span class="dropdown">
					<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							{#if reply.author.username === user.username}
								<DeleteButton id={reply.id} {refreshReplies} />
							{:else}
								<ReportButton
									user={reply.author.username}
									url="/forum/{categoryName}/{postId}/{reply.id}" />
								{#if user.permissionLevel >= 4}
									<DeleteButton
										id={reply.id}
										moderate
										{refreshReplies} />
								{/if}
							{/if}
							{#if pinnable && user.permissionLevel >= 4}
								<PinButton
									{refreshReplies}
									id={reply.id}
									pinned={reply.pinned} />
							{/if}
						</ul>
					</div>
				</span>
			{/if}
		{:else}
			<div class="card reply bg-darker p-4 pt-2 max-w-3/4">
				<form
					use:enhance={e => {
						replyingTo.set("")
						return refreshReplies(e)
					}}
					method="POST"
					action="?/reply&rid={reply.id}">
					<label for="content" class="light-text pb-2">
						Post a Reply
					</label>
					<fieldset class="flex flex-col gap-3">
						<textarea
							bind:value={content}
							required
							minlength="1"
							maxlength="1000"
							name="content"
							placeholder="What are your thoughts?"
							rows="4">
						</textarea>
						<div class="flex gap-3">
							<button class="btn btn-secondary">
								<fa fa-message class="pr-2"></fa>
								Reply
							</button>
							<button
								on:click={() => replyingTo.set("")}
								class="btn btn-tertiary grey-text">
								<fa fa-cancel class="pr-2"></fa>
								Cancel
							</button>
						</div>
					</fieldset>
				</form>
			</div>
		{/if}
		{#if topLevel}
			<!-- Pls give snippets svelte -->
			<noscript>
				<div class="card reply bg-darker p-4 pt-2 max-w-3/4">
					<form
						use:enhance
						on:submit={() => replyingTo.set("")}
						method="POST"
						action="?/reply&rid={reply.id}">
						<label for="content" class="light-text pb-2">
							Post a Reply
						</label>
						<fieldset class="flex flex-col gap-3">
							<textarea
								bind:value={content}
								required
								minlength="1"
								maxlength="1000"
								name="content"
								placeholder="What are your thoughts?"
								rows="4">
							</textarea>
							<div class="flex gap-3">
								<button class="btn btn-secondary">
									<fa fa-message class="pr-2"></fa>
									Reply
								</button>
								<button
									on:click={() => replyingTo.set("")}
									class="btn btn-tertiary grey-text">
									<fa fa-cancel class="pr-2"></fa>
									Cancel
								</button>
							</div>
						</fieldset>
					</form>
				</div>
			</noscript>
		{/if}
	</div>
</div>

{#if depth > 8}
	<a href="/{baseUrl}/{reply.id}" class="no-underline py-2">
		<fa fa-arrow-down class="pr-2"></fa>
		More replies
	</a>
{/if}

{#each reply.replies as reply2}
	<!-- Get READY for some RECURSION!!! -->
	<ForumReply
		{user}
		reply={reply2}
		{num}
		{replyingTo}
		{categoryName}
		{postId}
		{assetSlug}
		{postAuthorName}
		{repliesCollapsed}
		depth={depth + 1}
		topLevel={false}
		{refreshReplies} />
{/each}

<style>
	.reply {
		border-color: var(--accent2);
	}

	.userlink {
		transition: color 0.2s;
		&:hover {
			color: var(--grey-text) !important;
		}
	}
</style>
