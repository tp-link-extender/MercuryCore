<script lang="ts">
	import { pinForm } from "#lib/commentActions.remote.ts"

	let {
		id,
		pinned = false
	}: {
		id: string
		pinned?: boolean
	} = $props()

	const pinFormFor = pinForm.for(id)

	let text = $derived(pinned ? "unpin" : "pin")
</script>

<li class="rounded-2">
	<form {...pinFormFor} onsubmit={() => (pinned = !pinned)} class="inline">
		<input
			{...pinFormFor.fields.set.as("hidden", pinned ? "false" : "true")} />
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
