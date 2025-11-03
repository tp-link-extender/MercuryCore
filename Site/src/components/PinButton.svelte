<script lang="ts">
	import { enhance } from "$app/forms"

	let {
		id,
		pinned = $bindable(false),
		refreshComments
	}: {
		id: string
		pinned?: boolean
		// Replies need to be re-ordered after a reply is pinned or unpinned
		refreshComments: import("@sveltejs/kit").SubmitFunction<any, any>
	} = $props()

	let text = $derived(pinned ? "unpin" : "pin")
</script>

<li class="rounded-2">
	<form
		use:enhance={e => {
			pinned = !pinned
			return refreshComments(e)
		}}
		method="post"
		action="/comment/{id}?/pin&set={!pinned}"
		class="inline">
		<button
			class={[
				"btn pl-4 pr-2",
				pinned ? "text-red-500" : "text-green-500"
			]}>
			<fa fa-thumbtack class="pr-2"></fa>
			{text.charAt(0).toUpperCase() + text.slice(1)}
		</button>
	</form>
</li>
