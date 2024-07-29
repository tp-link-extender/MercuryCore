<script lang="ts">
	import { enhance } from "$app/forms"

	export let id: string
	export let pinned = false
	export let post = false
	// Replies need to be re-ordered after a reply is pinned or unpinned
	export let refreshReplies: import("@sveltejs/kit").SubmitFunction<any, any>

	$: text = pinned ? "unpin" : "pin"
	$: colour = pinned ? "text-red-5" : "text-green-5"
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
		<button
			class="btn pl-4 pr-2 {colour}">
			<far fa-thumbtack class="pr-2" />
			{text.charAt(0).toUpperCase() + text.slice(1)}
		</button>
	</form>
</li>
