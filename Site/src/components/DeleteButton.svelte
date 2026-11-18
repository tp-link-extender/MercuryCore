<script lang="ts">
	import { deleteForm } from "#lib/commentActions.remote.ts"

	const {
		id,
		moderate = false
	}: {
		id: string
		moderate?: boolean
	} = $props()

	const deleteFormFor = deleteForm.for(id)

	let text = $derived(moderate ? "remove" : "delete")
</script>

<li class="rounded-2">
	<form {...deleteFormFor} class="inline">
		<input
			{...deleteFormFor.fields.action.as(
				"hidden",
				moderate ? "remove" : "delete"
			)} />
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
