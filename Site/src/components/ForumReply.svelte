<script lang="ts" module>
	export type UserType = {
		username: string
		permissionLevel: number
		status: "Playing" | "Online" | "Offline"
	}

	export type Reply =
		| import("../routes/(main)/forum/[category]/[post=strid]/$types").PageData["post"]["replies"][number]
		| import("../routes/(main)/catalog/[id=integer]/[name]/$types").PageData["asset"]["replies"][number]

	export type RepliesCollapsed = Writable<{
		[id: string]: boolean
	}>
</script>

<script lang="ts">
	import ForumReplyMain from "$components/ForumReplyMain.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"
	import type { Writable } from "svelte/store"

	const {
		user,
		reply,
		num,
		depth = 0,
		replyingTo,
		postAuthorName,
		categoryName = "",
		postId,
		assetSlug = "",
		pinnable = false,
		refreshReplies,
		repliesCollapsed,
		topLevel = true
	}: {
		// too many exports help
		user: UserType
		reply: Reply
		num: number
		depth?: number
		replyingTo: Writable<string>
		postAuthorName: string
		categoryName?: string
		postId: string
		assetSlug?: string
		pinnable?: boolean
		refreshReplies: import("@sveltejs/kit").SubmitFunction<any, any>
		repliesCollapsed: RepliesCollapsed
		topLevel?: boolean
	} = $props()

	const baseUrl = categoryName
		? `/forum/${categoryName.toLowerCase()}/${postId}`
		: `/catalog/${postId}/${assetSlug}`

	// Some have to be writables to allow them to keep state, either on element destroy or on page change

	const collapse = (id: string) => () =>
		($repliesCollapsed[id] = !$repliesCollapsed[id])
</script>

{#if topLevel}
	<a href="{baseUrl}{assetSlug ? '?tab=Comments' : ''}" class="no-underline">
		<fa fa-arrow-left class="pr-2"></fa>
		{#if assetSlug}
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
	<div class="pt-2" class:flex={!topLevel}>
		{#if !topLevel}
			<span class="flex flex-col pt-2">
				<User user={reply.author} thin size="1.5rem" />
				<button
					onclick={collapse(reply.id)}
					aria-label="Collapse reply"
					class="collapseBar {reply.pinned
						? 'bg-green-500'
						: 'bg-a2'} p-0 border-0 h-full mt-4 cursor-pointer">
				</button>
			</span>
		{/if}

		{#if $repliesCollapsed?.[reply.id]}
			<button
				onclick={collapse(reply.id)}
				aria-label="Expand reply"
				class="expandBar pb-2 pl-4 text-base cursor-pointer">
				<small class="max-w-40 text-ellipsis">
					<span class="grey-text">
						{reply.author.username}
						{#if reply.author.username === postAuthorName}
							<fa
								class="{assetSlug
									? 'fa-hammer'
									: 'fa-microphone'} pl-1">
							</fa>
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
					{assetSlug}
					{repliesCollapsed}
					{topLevel}
					{pinnable}
					{refreshReplies} />
			</div>
		{/if}
	</div>
{/if}

<style>
	.collapseBar,
	.expandBar {
		transition: all 0.2s ease-out;
	}

	.collapseBar {
		border-left: 9px solid var(--background);
		border-right: 13px solid var(--background);
		&:hover {
			background: var(--grey-text);
		}
	}

	.expandBar {
		border: none;
		background: none;
		color: var(--accent3);
		&:hover {
			color: var(--grey-text);
		}
	}
</style>
