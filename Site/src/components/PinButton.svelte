<script lang="ts">
	import { enhance } from "$app/forms"

	let {
		id,
		pinned = $bindable(false),
		post = false,
		refreshReplies
	}: {
		id: string
		pinned?: boolean
		post?: boolean
		// Replies need to be re-ordered after a reply is pinned or unpinned
		refreshReplies: import("@sveltejs/kit").SubmitFunction<any, any>
	} = $props()

	let text = $derived(pinned ? "unpin" : "pin")
	let colour = $derived(pinned ? "text-red-500" : "text-green-500")
</script>

<li class="rounded-2">
	<form
		use:enhance={e => {
			pinned = !pinned
			return refreshReplies(e)
		}}
		method="POST"
		action="?/{text}{post ? 'post' : ''}&id={id}"
		class="inline">
		<button class="btn pl-4 pr-2 {colour}">
			<fa fa-thumbtack class="pr-2"></fa>
			{text.charAt(0).toUpperCase() + text.slice(1)}
		</button>
	</form>
</li>
