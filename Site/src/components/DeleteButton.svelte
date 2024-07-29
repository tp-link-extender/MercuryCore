<script lang="ts">
	import { enhance } from "$app/forms"

	export let id: string
	export let moderate = false
	export let post = false
	export let refreshReplies: import("@sveltejs/kit").SubmitFunction

	const text = moderate ? "moderate" : "delete"
	const colour = moderate ? "text-cyan-5" : "text-yellow-5"
</script>

<li class="rounded-2">
	<form
		use:enhance={refreshReplies}
		method="POST"
		action="?/{text}{post ? 'post' : ''}&id={id}"
		class="inline">
		<button class="btn pl-4 pr-2 {colour}">
			<far class="{moderate ? 'fa-gavel' : 'fa-trash'} pr-2" />
			{text.charAt(0).toUpperCase() + text.slice(1)}
		</button>
	</form>
</li>
