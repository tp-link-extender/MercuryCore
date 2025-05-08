<script lang="ts">
	import { enhance } from "$app/forms"
	import CommentLike from "$components/CommentLike.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import { likeEnhance } from "$lib/like"
	import type { SubmitFunction } from "./$types"

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

	const refreshReplies: SubmitFunction = () => onResult
</script>

<div
	class={[
		"post card bg-darker flex-row",
		{ "border-(solid 1px green-5)!": comment.pinned }
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
						{#if user.permissionLevel >= 4}
							<PinButton
								{refreshReplies}
								id={comment.id}
								pinned={comment.pinned}
								post />
						{/if}
						<ReportButton
							user={comment.author.username}
							url="/comment/{comment.id}" />
					</ul>
				</div>
			</span>
		</div>
		<p class="break-all">
			{comment.content[0].text}
		</p>
	</div>
</div>
