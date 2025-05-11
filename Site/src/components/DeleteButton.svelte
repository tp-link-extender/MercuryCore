<script lang="ts">
	import { enhance } from "$app/forms"
	import { refreshComments } from "$lib/refreshComments"

	const {
		id,
		moderate = false,
	}: {
		id: string
		moderate?: boolean
	} = $props()

	const text = moderate ? "remove" : "delete"
</script>

<li class="rounded-2">
	<form
		use:enhance={refreshComments}
		method="POST"
		action="/comment/{id}?/delete&action={text}"
		class="inline">
		<button
			class={[
				"btn pl-4 pr-2",
				moderate ? "text-cyan-500" : "text-yellow-500"
			]}>
			<fa class="{moderate ? 'fa-gavel' : 'fa-trash'} pr-2"></fa>
			{text.charAt(0).toUpperCase() + text.slice(1)}
		</button>
	</form>
</li>
