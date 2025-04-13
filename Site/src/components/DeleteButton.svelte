<script lang="ts">
	import { enhance } from "$app/forms"

	const {
		id,
		moderate = false,
		post = false,
		refreshReplies
	}: {
		id: string
		moderate?: boolean
		post?: boolean
		refreshReplies: import("@sveltejs/kit").SubmitFunction
	} = $props()

	const text = moderate ? "moderate" : "delete"
	const colour = moderate ? "text-cyan-500" : "text-yellow-500"
</script>

<li class="rounded-2">
	<form
		use:enhance={refreshReplies}
		method="POST"
		action="?/{text}{post ? 'post' : ''}&id={id}"
		class="inline">
		<button class="btn pl-4 pr-2 {colour}">
			<fa class="{moderate ? 'fa-gavel' : 'fa-trash'} pr-2"></fa>
			{text.charAt(0).toUpperCase() + text.slice(1)}
		</button>
	</form>
</li>
