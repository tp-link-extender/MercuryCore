<script lang="ts">
	import { enhance } from "$app/forms"
	import CommentLike from "$components/CommentLike.svelte"
	import DeleteButton from "$components/DeleteButton.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import { likeEnhance } from "$lib/like"

	let {
		comment,
		onResult,
		user
	}: {
		comment: import("./$types").PageData["comment"]
		onResult: (result: {
			result: import("@sveltejs/kit").ActionResult
		}) => Promise<void>
		user: import("./$types").PageData["user"]
	} = $props()

	const refreshReplies = () => onResult
</script>

<div
	class={[
		"post card bg-darker flex-row border-(1px solid)",
		{ "border-green-5!": comment.pinned }
	]}>
	<form
		use:enhance={likeEnhance(comment, c => {
			comment = c
		})}
		method="POST"
		action="?/like&id={comment.id}"
		class="bg-a p-1 rounded-l-1">
		<CommentLike {comment} />
	</form>
	<div class="p-4 pl-6 no-underline w-full">
		<div class="flex justify-between pb-4">
			<div class="flex">
				<User user={comment.author} full />
				<i class="pl-4 self-center">
					{comment.created.toLocaleString()}
				</i>
			</div>
			<span class="dropdown">
				<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
				<div class="dropdown-content pt-2">
					<ul class="p-2 rounded-3">
						{#if comment.author.username === user.username}
							<DeleteButton id={comment.id} {refreshReplies} />
						{:else}
							<ReportButton
								user={comment.author.username}
								url="/comment/{comment.id}" />
							{#if user.permissionLevel >= 4}
								<DeleteButton
									id={comment.id}
									{refreshReplies}
									moderate />
							{/if}
						{/if}
						{#if user.permissionLevel >= 4}
							<PinButton
								id={comment.id}
								{refreshReplies}
								pinned={comment.pinned} />
						{/if}
					</ul>
				</div>
			</span>
		</div>
		<p class="break-all">
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
