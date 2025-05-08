<script lang="ts" module>
	export type UserType = {
		username: string
		permissionLevel: number
		status: "Playing" | "Online" | "Offline"
	}

	export type Reply =
		import("../routes/(main)/comment/[comment=strid]/$types").PageData["comment"]
</script>

<script lang="ts">
	import CommentMain from "$components/CommentMain.svelte"
	import User from "$components/User.svelte"
	import { slide } from "svelte/transition"
	import fade from "$lib/fade"

	let {
		comment = $bindable(),
		depth = 0,
		num,
		// postAuthorName,
		// categoryName = "",
		// postId,
		// assetSlug = "",
		// pinnable = false,
		refreshReplies,
		repliesCollapsed = $bindable(),
		replyingTo = $bindable(),
		// topLevel = true
		user
	}: {
		// too many exports help
		comment: Reply
		depth?: number
		num: number
		// postAuthorName: string
		// categoryName?: string
		// postId: string
		// assetSlug?: string
		// pinnable?: boolean
		refreshReplies: import("@sveltejs/kit").SubmitFunction<any, any>
		repliesCollapsed: { [id: string]: boolean }
		replyingTo: string
		// topLevel?: boolean
		user: UserType
	} = $props()

	// const baseUrl = categoryName
	// 	? `/forum/${categoryName.toLowerCase()}/${postId}`
	// 	: `/catalog/${postId}/${assetSlug}`

	// Some have to be bindable to allow them to keep state, either on element/component destroy or on page change

	const collapse = (id: string) => () => {
		repliesCollapsed[id] = !repliesCollapsed[id]
	}
</script>

{#if comment && comment.author}
	<div class="pt-4 flex" in:fade|global={{ num }}>
		<span class="flex flex-col pt-2">
			<User user={comment.author} thin size="1.5rem" />
			<button
				onclick={collapse(comment.id)}
				aria-label="Collapse reply"
				class="collapseBar {comment.pinned
					? 'bg-green-500'
					: 'bg-a2'} p-0 border-0 h-full mt-4 cursor-pointer">
			</button>
		</span>

		{#if repliesCollapsed?.[comment.id]}
			<!-- delay transition in -->
			<button
				in:fade={{ delay: 350, duration: 150 }}
				onclick={collapse(comment.id)}
				aria-label="Expand reply"
				class="expandBar justify-center pl-4 text-sm cursor-pointer text-left max-h-10 overflow-hidden">
				<span class="grey-text">
					{comment.author.username}
					<!-- {#if reply.author.username === postAuthorName}
							<fa
								class={[
									assetSlug ? "fa-hammer" : "fa-microphone",
									"pl-1"
								]}>
							</fa>
						{/if} -->
				</span>
				- {comment.content[0].text}
			</button>
		{:else}
			<div transition:slide class="min-w-full pe-10">
				<CommentMain
					bind:comment
					{depth}
					bind:repliesCollapsed
					bind:replyingTo
					{user}
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
