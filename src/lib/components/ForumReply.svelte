<script lang="ts">
	import ForumReplyMain from "./ForumReplyMain.svelte"
	import type { Writable } from "svelte/store"

	// too many exports help
	export let user: {
		username: string
		permissionLevel: number
		status: "Playing" | "Online" | "Offline"
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

	export let repliesCollapsed: Writable<{
		[id: string]: boolean
	}>
	export let topLevel = false
	// Some have to be writables to allow them to keep state,
	// either on element destroy or on page change

	let content = "" // Allows current reply to not be lost on clicking to another reply

	const collapse = (id: string) => () =>
		($repliesCollapsed[id] = !$repliesCollapsed[id])

	$: hidden = reply.visibility != "Visible"
</script>

{#if !topLevel}
	<a href="{baseUrl}{assetName ? '?tab=Comments' : ''}" class="no-underline">
		<fa fa-arrow-left class="pr-2"></fa>
		{#if assetName}
			Back to asset
		{:else}
			Parent post
		{/if}
	</a>
	{#if reply.parentReplyId}
		<br />
		<a href="{baseUrl}/{reply.parentReplyId}" class="no-underline">
			<fa fa-arrow-up class="pr-2"></fa>
			Parent reply
		</a>
	{/if}
{/if}

{#if reply && reply.author}
	<div class:mt-2={!$repliesCollapsed?.[reply.id]} class="flex">
		<span class="flex flex-col pt-2">
			<User user={reply.author} thin size="1.5rem" />
			<button
				on:click={collapse(reply.id)}
				aria-label="Collapse reply"
				class="collapseBar bg-a2 p-0 border-0 h-full mt-4
				cursor-pointer">
			</button>
		</span>

		{#if $repliesCollapsed?.[reply.id]}
			<button
				on:click={collapse(reply.id)}
				aria-label="Expand reply"
				class="expandBar m-2 pl-2 mt-0 text-base">
				<small class="max-w-40 text-ellipsis">
					<span class="grey-text">
						{reply.author.username}
						{#if reply.author.username == postAuthorName}
							<i
								class="fa {assetName
									? 'fa-hammer'
									: 'fa-microphone'} pl-1">
							</i>
						{/if}
					</span>
					- {reply.content[0].text}
				</small>
			</button>
		{:else}
			<div in:fade|global={{ num }} class="w-full">
				<ForumReplyMain
					{user}
					{reply}
					{num}
					{depth}
					{replyingTo}
					{postAuthorName}
					{categoryName}
					{postId}
					{assetName}
					{repliesCollapsed} />
			</div>
		{/if}
	</div>
{/if}

<style lang="stylus">
	.collapseBar
	.expandBar
		transition all 0.2s ease-out

	.collapseBar
		border-left 9px solid var(--background)
		border-right 13px solid var(--background)
		&:hover
			background var(--grey-text)

	.expandBar
		border none
		background none

		color var(--accent3)
		&:hover
			color var(--grey-text)
</style>
