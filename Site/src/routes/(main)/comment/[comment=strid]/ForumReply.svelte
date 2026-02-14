<script lang="ts">
	import CommentLike from "$components/CommentLike.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import type { LikeForm } from "$lib/like2"
	import type { getComment } from "./comment.remote"

	let {
		comment,
		likeForm,
		onResult,
		user
	}: {
		comment: Awaited<ReturnType<typeof getComment>>["comments"][number]
		likeForm: Omit<LikeForm, "for">
		onResult: (result: {
			result: import("@sveltejs/kit").ActionResult
		}) => Promise<void>
		user: import("./$types").PageData["user"]
	} = $props()

	const refreshComments = () => onResult
</script>

<a href="/comment/{comment.parentId}" class="no-underline">
	<fa fa-arrow-up class="pr-2"></fa>
	Parent comment
</a>

<div
	class={[
		"py-4 no-underline w-full",
		{ "border-(solid 1px green-5)!": comment.pinned }
	]}>
	<div class="flex pb-4">
		<User user={comment.author} full />
		<i class="pl-4 self-center">
			{comment.created.toLocaleString()}
		</i>
	</div>
	<p class="break-all whitespace-pre-line">
		{comment.content[0].text}
	</p>

	<div class="flex gap-2">
		<CommentLike {comment} {likeForm} small />

		<span class="dropdown">
			<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
			<div class="dropdown-content pt-2">
				<ul class="p-2 rounded-3">
					{#if user.permissionLevel >= 4}
						<PinButton
							{refreshComments}
							id={comment.id}
							pinned={comment.pinned} />
					{/if}
					<ReportButton
						user={comment.author.username}
						url="/comment/{comment.id}" />
				</ul>
			</div>
		</span>
	</div>
</div>
