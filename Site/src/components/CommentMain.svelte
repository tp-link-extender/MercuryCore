<script lang="ts">
	import { enhance } from "$app/forms"
	import Comment from "$components/Comment.svelte"
	import type { UserType } from "$components/Comment.svelte"
	import DeleteButton from "$components/DeleteButton.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import type { Comment as CommentType } from "$lib/comment"
	import { likeEnhance } from "$lib/like"
	import { refreshComments } from "$lib/refreshComments"
	import CommentLike from "./CommentLike.svelte"

	let {
		comment = $bindable(),
		depth = 0,
		// postAuthorName,
		commentsCollapsed = $bindable(),
		replyingTo = $bindable(),
		user
	}: {
		comment: CommentType
		depth?: number
		// postAuthorName: string
		commentsCollapsed: { [id: string]: boolean }
		replyingTo: string
		user: UserType
	} = $props()

	let content = $state("") // Allows current reply to not be lost on clicking to another reply

	let hidden = $derived(comment.visibility !== "Visible")
</script>

<div class="w-full">
	<div class="flex items-center pt-2">
		<a
			href="/user/{comment.author.username}"
			class={[
				"userlink light-text items-center no-underline flex flex-row font-bold pl-4",
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
	<p
		class={[
			"py-2 m-0 break-all whitespace-pre-line",
			{ "opacity-33": hidden }
		]}>
		{comment.content[0].text}
	</p>
	{#if replyingTo !== comment.id}
		<CommentLike
			class={["inline pr-2", { "opacity-33": hidden }]}
			{comment}
			likeEnhance={likeEnhance(comment, c => {
				comment = c
			})}
			small />
		{#if !hidden}
			<a
				href="/comment/{comment.id}"
				onclick={e => {
					e.preventDefault()
					replyingTo = comment.id
				}}
				class="btn btn-sm p-0 px-1 text-neutral-5 hover:text-neutral-300">
				<fa fa-message class="pr-2"></fa>
				Reply
			</a>
			<span class="dropdown">
				<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
				<div class="dropdown-content pt-2">
					<ul class="p-2 rounded-3">
						{#if comment.author.username === user.username}
							<DeleteButton id={comment.id} />
						{:else}
							<ReportButton
								user={comment.author.username}
								url="/comment/{comment.id}" />
							{#if user.permissionLevel >= 4}
								<DeleteButton id={comment.id} moderate />
							{/if}
						{/if}
						{#if user.permissionLevel >= 4}
							<PinButton
								id={comment.id}
								{refreshComments}
								pinned={comment.pinned} />
						{/if}
						<li class="rounded-2">
							<a
								class="btn pl-3 px-2 text-neutral-5"
								href="/comment/{comment.id}">
								<fa fa-link class="pr-2"></fa>
								Link
							</a>
						</li>
					</ul>
				</div>
			</span>
		{/if}
	{:else}
		<div class="card reply bg-darker p-4 pt-2 max-w-3/4">
			<form
				use:enhance={e => {
					replyingTo = ""
					return refreshComments(e)
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

{#if depth > 8}
	<a href="/comment/{comment.id}" class="no-underline py-2">
		<fa fa-arrow-down class="pr-2"></fa>
		More comments
	</a>
{/if}

{#each comment.comments as _, num}
	<!-- Get READY for some RECURSION!!! -->
	<Comment
		bind:comment={comment.comments[num]}
		depth={depth + 1}
		{num}
		bind:commentsCollapsed
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
