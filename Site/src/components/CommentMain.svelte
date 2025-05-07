<script lang="ts">
	import { enhance } from "$app/forms"
	import Comment from "$components/Comment.svelte"
	import type { Reply, UserType } from "$components/Comment.svelte"
	import DeleteButton from "$components/DeleteButton.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"

	let {
		comment = $bindable(),
		depth = 0,
		// postAuthorName,
		// categoryName = "",
		// postId,
		// assetSlug = "",
		refreshReplies,
		repliesCollapsed = $bindable(),
		replyingTo = $bindable(),
		// topLevel = true,
		// pinnable = false,
		user
	}: {
		comment: Reply
		depth?: number
		// postAuthorName: string
		// categoryName?: string
		// postId: string
		// assetSlug?: string
		refreshReplies: import("@sveltejs/kit").SubmitFunction
		repliesCollapsed: { [id: string]: boolean }
		replyingTo: string
		// topLevel?: boolean
		// pinnable?: boolean
		user: UserType
	} = $props()

	// const baseUrl = categoryName
	// 	? `forum/${categoryName.toLowerCase()}/${postId}`
	// 	: `catalog/${postId}/${assetSlug}`

	let content = $state("") // Allows current reply to not be lost on clicking to another reply

	let hidden = $derived(comment.visibility !== "Visible")

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
</script>

<div class="flex w-full">
	<div class="w-full">
		<div class="flex items-center pt-2">
			<a
				href="/user/{comment.author.username}"
				class={[
					"userlink items-center no-underline flex flex-row font-bold pl-4",
					{
						// [assetSlug ? "text-yellow-500" : "text-blue-600"]:
						// 	reply.author.username === postAuthorName,
						// "light-text": reply.author.username !== postAuthorName,
						"opacity-33": hidden
					}
				]}>
				{comment.author.username}
				<!-- {#if reply.author.username === postAuthorName}
					<fa
						class="{assetSlug
							? 'fa-hammer'
							: 'fa-microphone'} pl-2">
					</fa>
				{/if} -->
			</a>
			<small class="light-text pl-6">
				{comment.created.toLocaleString()}
			</small>
		</div>
		<p class={["py-2 m-0 break-all", { "opacity-33": hidden }]}>
			{comment.content[0].text}
		</p>
		{#if replyingTo !== comment.id}
			<form
				use:enhance={likeEnhance}
				method="POST"
				action="?/like&rid={comment.id}"
				class={["inline pr-2", { "opacity-33": hidden }]}>
				<button
					name="action"
					value={comment.likes ? "unlike" : "like"}
					aria-label={comment.likes ? "Unlike" : "Like"}
					class="size-6 p-0 btn">
					<fa
						fa-thumbs-up
						class="transition {comment.likes
							? 'text-emerald-600 hover:text-emerald-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
				<span
					class={[
						"text-center",
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
					class="btn size-6 p-0">
					<fa
						fa-thumbs-down
						class="transition {comment.dislikes
							? 'text-red-500 hover:text-red-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
			</form>
			{#if !hidden}
				<a
					href="/comment/{comment.id}"
					onclick={e => {
						e.preventDefault()
						replyingTo = comment.id
					}}
					class={[
						"btn btn-sm p-0 px-1 text-neutral-5 hover:text-neutral-300",
						{ "opacity-33": hidden }
					]}>
					<fa fa-message class="pr-2"></fa>
					Reply
				</a>
				<span class="dropdown">
					<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							{#if comment.author.username === user.username}
								<DeleteButton
									id={comment.id}
									{refreshReplies} />
							{:else}
								<ReportButton
									user={comment.author.username}
									url="/comment/{comment.id}" />
								{#if user.permissionLevel >= 4}
									<DeleteButton
										id={comment.id}
										moderate
										{refreshReplies} />
								{/if}
							{/if}
							{#if user.permissionLevel >= 4}
								<PinButton
									{refreshReplies}
									id={comment.id}
									pinned={comment.pinned} />
							{/if}
						</ul>
					</div>
				</span>
			{/if}
		{:else}
			<div class="card reply bg-darker p-4 pt-2 max-w-3/4">
				<form
					use:enhance={e => {
						replyingTo = ""
						return refreshReplies(e)
					}}
					method="POST"
					action="/comment/{comment.id}?/comment">
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
								onclick={() => {
									replyingTo = ""
								}}
								class="btn btn-tertiary grey-text">
								<fa fa-cancel class="pr-2"></fa>
								Cancel
							</button>
						</div>
					</fieldset>
				</form>
			</div>
		{/if}
	</div>
</div>

{#if depth > 8}
	<a href="/comment/{comment.id}" class="no-underline py-2">
		<fa fa-arrow-down class="pr-2"></fa>
		More replies
	</a>
{/if}

{#each comment.comments as _, num}
	<!-- Get READY for some RECURSION!!! -->
	<Comment
		bind:comment={comment.comments[num]}
		depth={depth + 1}
		{num}
		{refreshReplies}
		bind:repliesCollapsed
		bind:replyingTo
		{user} />
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
