<script lang="ts">
	import CommentLike from "$components/CommentLike.svelte"
	import DeleteButton from "$components/DeleteButton.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import type { LikeForm } from "$lib/like2"
	import type { getComment } from "./comment.remote"

	const {
		comment,
		likeForm,
		onResult,
		user
	}: {
		comment: Awaited<ReturnType<typeof getComment>>
		likeForm: Omit<LikeForm, "for">
		onResult: (result: {
			result: import("@sveltejs/kit").ActionResult
		}) => Promise<void>
		user: import("./$types").PageData["user"]
	} = $props()

	const refreshComments = () => onResult
</script>

<div
	class={[
		"post card bg-darker flex-row border-(1px solid)",
		{ "border-green-5!": comment.pinned }
	]}>
	<CommentLike class="bg-a p-1 rounded-l-1" {comment} {likeForm} />
	<div class="p-4 pl-6 no-underline w-full">
		<div class="flex pb-4">
			<div class="flex justify-between items-center w-full">
				<User user={comment.author} full />
				<i class="px-4">
					{comment.created.toLocaleString()}
				</i>
			</div>
			<span class="dropdown">
				<fa fa-ellipsis-h class="dropdown-ellipsis py-2"></fa>
				<div class="dropdown-content">
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
						{#if user.permissionLevel >= 4 && (comment.type.length !== 1 || comment.type[0] !== "status")}
							<PinButton
								id={comment.id}
								{refreshComments}
								pinned={comment.pinned} />
						{/if}
					</ul>
				</div>
			</span>
		</div>
		<p class="break-all whitespace-pre-line">
			{comment.content[0].text}
		</p>
	</div>
</div>

<style>
	.card {
		border-color: var(--accent2);
		transition: all 0.3s ease-out;
	}
</style>
