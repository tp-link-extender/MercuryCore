<script lang="ts">
	import type { Writable } from "svelte/store"

	// too many exports help
	export let user: {
		username: string
		permissionLevel: number
	}

	export let reply:
		| import("../../routes/(main)/forum/[category]/[post]/$types").PageData["replies"][number]
		| import("../../routes/(main)/avatarshop/[id]/[name]/$types").PageData["replies"][number]

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

	export let repliesCollapsed: Writable<any>
	export let topLevel = false
	// Some have to be writables to allow them to keep state,
	// either on element destroy or on page change

	let content = "" // Allows current reply to not be lost on clicking to another reply

	const collapse = (id: string) => () => {
		repliesCollapsed.update(collapsed => {
			collapsed[id] = !collapsed[id]
			return collapsed
		})
	}

	$: hidden = reply.visibility != "Visible"
</script>

{#if !topLevel}
	<a
		href="{baseUrl}{assetName ? '?tab=Comments' : ''}"
		class="text-decoration-none">
		<i class="fa fa-arrow-left me-2" />
		{#if assetName}
			Back to asset
		{:else}
			Parent post
		{/if}
	</a>
	{#if reply.parentReplyId}
		<br />
		<a href="{baseUrl}/{reply.parentReplyId}" class="text-decoration-none">
			<i class="fa fa-arrow-up me-2" />
			Parent reply
		</a>
	{/if}
{/if}

{#if reply && reply.author}
	<div class:mt-2={!$repliesCollapsed?.[reply.id]} class="d-flex">
		<span class="d-flex flex-column pt-2">
			<User user={reply.author} thin size="1.5rem" />
			<button
				on:click={collapse(reply.id)}
				aria-label="Collapse reply"
				class="collapseBar bg-a2 p-0 border-0 h-100 mt-4" />
		</span>

		{#if $repliesCollapsed?.[reply.id]}
			<button
				on:click={collapse(reply.id)}
				aria-label="Expand reply"
				class="expandBar m-2 ms-4 p-0 mt-0">
				<small>
					<span class="grey-text">
						{reply.author.username}
						{#if reply.author.username == postAuthorName}
							<i
								class="fa {assetName
									? 'fa-hammer'
									: 'fa-microphone'} ms-1" />
						{/if}
					</span>
					- {reply.content[0].text}
				</small>
			</button>
		{:else}
			<div in:fade|global={{ num }} class="w-100">
				<div class="d-flex w-100">
					<div class="w-100">
						<a
							href="/user/{reply.author.number}"
							class:hidden
							class="user userlink d-flex text-decoration-none pt-2 ms-4 {reply
								.author.username == postAuthorName
								? ''
								: 'light-text'}">
							<span
								class="font-bold {reply.author.username ==
								postAuthorName
									? assetName
										? 'text-warning'
										: 'text-primary'
									: ''}">
								{reply.author.username}
								{#if reply.author.username == postAuthorName}
									<i
										class="fa {assetName
											? 'fa-hammer'
											: 'fa-microphone'} ms-2" />
								{/if}
							</span>
							<small class="light-text ps-6">
								{new Date(reply.posted).toLocaleString()}
							</small>
						</a>
						<p class:hidden class="my-2">
							{reply.content[0].text}
						</p>
						{#if $replyingTo != reply.id}
							<form
								use:enhance={({ formData }) => {
									const action = formData.get("action")

									if (action == "like") {
										reply.likes = true

										if (reply.dislikes) reply.dislikeCount--
										reply.dislikes = false
										reply.likeCount++
									} else if (action == "dislike") {
										reply.dislikes = true

										if (reply.likes) reply.likeCount--
										reply.likes = false
										reply.dislikeCount++
									} else if (action == "unlike") {
										reply.likes = false
										reply.likeCount--
									} else if (action == "undislike") {
										reply.dislikes = false
										reply.dislikeCount--
									}

									return () => {}
								}}
								class:hidden
								class="d-inline me-2"
								method="POST"
								action="?/like&rid={reply.id}">
								<button
									name="action"
									value={reply.likes ? "unlike" : "like"}
									aria-label={reply.likes ? "Unlike" : "Like"}
									class="smallbutton p-0 btn btn-sm">
									<i
										class="fa{reply.likes
											? ' text-success'
											: 'r'} fa-thumbs-up" />
								</button>
								<span
									class="my-1 text-center {reply.likes
										? 'text-success font-bold'
										: reply.dislikes
										? 'text-danger font-bold'
										: ''}">
									{reply.likeCount - reply.dislikeCount}
								</span>
								<button
									name="action"
									value={reply.dislikes
										? "undislike"
										: "dislike"}
									aria-label={reply.dislikes
										? "Undislike"
										: "Dislike"}
									class="smallbutton p-0 btn btn-sm">
									<i
										class="fa{reply.dislikes
											? ' text-danger'
											: 'r'} fa-thumbs-down" />
								</button>
							</form>
							<button
								on:click={() => replyingTo.set(reply.id)}
								class:hidden
								class="p-0 btn btn-sm grey-text px-1">
								<i class="far fa-message pe-2" />
								Reply
							</button>
							{#if !hidden}
								{#if reply.author.username == user.username}
									<DeleteButton id={reply.id} reverse />
								{:else}
									<ReportButton
										user={reply.author.username}
										url="/forum/{categoryName}/{postId}/{reply.id}"
										reverse />
									{#if user.permissionLevel >= 4}
										<DeleteButton
											id={reply.id}
											moderate
											reverse />
									{/if}
								{/if}
							{/if}
						{:else}
							<div class="mb-2 card reply bg-darker">
								<div class="card-body p-4 pt-1 pb-0">
									<form
										use:enhance
										on:submit={() => replyingTo.set("")}
										class="mb-6"
										method="POST"
										action="?/reply&rid={reply.id}">
										<label
											for="content"
											class="form-label light-text mt-2">
											Post a Reply
										</label>
										<fieldset>
											<textarea
												bind:value={content}
												class="form-control valid mb-2"
												required
												minlength="1"
												maxlength="1000"
												name="content"
												placeholder="What are your thoughts?"
												rows="4" />
											<button class="btn btn-success">
												<i
													class="far fa-message me-2" />
												Reply
											</button>
											<button
												on:click={() =>
													replyingTo.set("")}
												class="btn btn-dark grey-text ms-1">
												<i class="fa fa-cancel me-2" />
												Cancel
											</button>
										</fieldset>
									</form>
								</div>
							</div>
						{/if}
					</div>
				</div>

				{#if depth > 8}
					<a href="{baseUrl}/{reply.id}" class="text-decoration-none">
						<i class="fa fa-arrow-down me-2" />
						More replies
					</a>
				{/if}

				{#each reply.replies as reply2}
					<!-- Get READY for some RECURSION!!! -->
					<svelte:self
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
						topLevel />
				{/each}
			</div>
		{/if}
	</div>
{/if}

<style lang="stylus">
	.collapseBar
	.expandBar
		transition all 0.2s ease-out

	.collapseBar
		width auto
		border-left 9px solid var(--background) !important
		border-right 13px solid var(--background) !important
		&:hover
			background var(--grey-text) !important

	.expandBar
		border none
		background none

		color var(--accent3)
		&:hover
			color var(--grey-text)

		small
			max-width 10rem
			text-overflow ellipsis

	.card
		max-width 75%

	.reply
		border-color var(--accent2)

	.smallbutton
		width 1.5rem
		height 1.5rem

	p
		word-break break-word

	.userlink
		margin-top 1px
		transition color 0.2s
		// &:hover
		// 	color var(--accent3)

		span
			transition color 0.2s
			&:hover
				color var(--grey-text) !important

		span.text-primary:hover
			color var(--accent-text) !important

	.user
		align-items center

	.hidden
		opacity 33%
</style>
