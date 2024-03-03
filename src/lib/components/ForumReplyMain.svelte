<script lang="ts">
	import ForumReply from "./ForumReply.svelte"
	import type { Writable } from "svelte/store"
	import type { User, Reply, RepliesCollapsed } from "./ForumReply.svelte"

	export let user: User
	export let reply: Reply

	export let num: number
	export let depth = 0
	export let replyingTo: Writable<string>
	export let postAuthorName: string
	export let categoryName = ""
	export let postId: string
	export let assetName = ""

	const baseUrl = categoryName
		? `/forum/${categoryName.toLowerCase()}/${postId}`
		: `/avatarshop/${postId}/${assetName}`

	export let repliesCollapsed: RepliesCollapsed
	export let topLevel = true
	export let pinnable = false
	export let refreshReplies: () => void

	let content = "" // Allows current reply to not be lost on clicking to another reply

	$: hidden = reply.visibility != "Visible"
</script>

<div class="flex w-full">
	<div class="w-full">
		<div class="flex items-center pt-2">
			<a
				href="/user/{reply.author.number}"
				class="userlink items-center no-underline"
				class:light-text={reply.author.username != postAuthorName}
				class:opacity-33={hidden}>
				<span class="flex flex-row font-bold">
					{#if topLevel}
						<User user={reply.author} thin size="1.5rem" image />
					{/if}
					<span
						class="pl-4 {reply.author.username == postAuthorName
							? assetName
								? 'text-yellow-5'
								: 'text-blue-6'
							: ''}">
						{reply.author.username}
						{#if reply.author.username == postAuthorName}
							<fa
								class="{assetName
									? 'fa-hammer'
									: 'fa-microphone'} ml-2" />
						{/if}
					</span>
				</span>
			</a>
			<small class="light-text pl-6">
				{new Date(reply.posted).toLocaleString()}
			</small>
		</div>
		<p class="py-2 m-0 break-all {hidden ? 'opacity-33' : ''}">
			{reply.content[0].text}
		</p>
		{#if $replyingTo != reply.id}
			<form
				use:enhance={({ formData }) => {
					const action = formData.get("action")

					if (action == "like") {
						reply.likes = true

						if (reply.dislikes) reply.score++
						reply.dislikes = false
						reply.score++
					} else if (action == "dislike") {
						reply.dislikes = true

						if (reply.likes) reply.score--
						reply.likes = false
						reply.score--
					} else if (action == "unlike") {
						reply.likes = false
						reply.score--
					} else if (action == "undislike") {
						reply.dislikes = false
						reply.score++
					}

					return () => {}
				}}
				class="inline pr-2 {hidden ? 'opacity-33' : ''}"
				method="POST"
				action="?/like&rid={reply.id}">
				<button
					name="action"
					value={reply.likes ? "unlike" : "like"}
					aria-label={reply.likes ? "Unlike" : "Like"}
					class="size-6 p-0 btn">
					<i
						class="fa{reply.likes
							? ' text-emerald-6 hover:text-emerald-3'
							: 'r text-neutral-5 hover:text-neutral-3'}
							fa-thumbs-up transition">
					</i>
				</button>
				<span
					class="my-1 text-center {reply.likes
						? 'text-emerald-6 font-bold'
						: reply.dislikes
							? 'text-red-5 font-bold'
							: ''}">
					{reply.score}
				</span>
				<button
					name="action"
					value={reply.dislikes ? "undislike" : "dislike"}
					aria-label={reply.dislikes ? "Undislike" : "Dislike"}
					class="size-6 p-0 btn">
					<i
						class="fa{reply.dislikes
							? ' text-red-5 hover:text-red-3'
							: 'r text-neutral-5 hover:text-neutral-3'}
							fa-thumbs-down transition">
					</i>
				</button>
			</form>
			<a
				href="/forum/{categoryName}/{postId}/{reply.id}"
				on:click|preventDefault={() => replyingTo.set(reply.id)}
				class="p-0 btn btn-sm px-1 text-neutral-5
				hover:text-neutral-3 {hidden ? 'opacity-33' : ''}">
				<far fa-message class="pr-2" />
				Reply
			</a>
			{#if !hidden}
				{#if reply.author.username == user.username}
					<DeleteButton id={reply.id} reverse />
				{:else}
					<ReportButton
						user={reply.author.username}
						url="/forum/{categoryName}/{postId}/{reply.id}"
						reverse />
					{#if user.permissionLevel >= 4}
						<DeleteButton id={reply.id} moderate reverse />
					{/if}
				{/if}
				{#if pinnable}
					<PinButton
						{refreshReplies}
						id={reply.id}
						pinned={reply.pinned}
						reverse />
				{/if}
			{/if}
		{:else}
			<div class="card reply bg-darker mb-2 p-4 pt-2 max-w-3/4">
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
							rows="4" />
						<div class="flex gap-3">
							<button class="btn btn-secondary">
								<far fa-message class="pr-2" />
								Reply
							</button>
							<button
								on:click={() => replyingTo.set("")}
								class="btn btn-tertiary grey-text">
								<fa fa-cancel class="pr-2" />
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
				<div class="card reply bg-darker mb-2 p-4 pt-2 max-w-3/4">
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
								rows="4" />
							<div class="flex gap-3">
								<button class="btn btn-secondary">
									<far fa-message class="pr-2" />
									Reply
								</button>
								<button
									on:click={() => replyingTo.set("")}
									class="btn btn-tertiary grey-text">
									<fa fa-cancel class="pr-2" />
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
	<a href="{baseUrl}/{reply.id}" class="no-underline my-2">
		<fa fa-arrow-down class="pr-2" />
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
		{assetName}
		{postAuthorName}
		{repliesCollapsed}
		depth={depth + 1}
		topLevel={false}
		{refreshReplies} />
{/each}

<style lang="stylus">
	.reply
		border-color var(--accent2)

	.userlink
		margin-top 1px
		transition color 0.2s
		// &:hover
		// 	color var(--accent3)

		span
			transition color 0.2s
			&:hover
				color var(--grey-text) !important
</style>
