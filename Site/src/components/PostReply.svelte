<script lang="ts" generics="T extends RemoteFormInput">
	import type { ClientForm } from "#lib/validate.ts"

	const { formData }: { formData: ClientForm<T> } = $props()

	let issues = $derived(formData.fields.allIssues() || [])
	let pending = $derived(formData.pending > 0)
</script>

<form {...formData} class="py-2">
	<label for="content" class="light-text py-2">Post a comment</label>
	<fieldset class="max-w-140 flex gap-4 items-end">
		<textarea
			{...formData.fields.content.as("text")}
			name="content"
			placeholder="What are your thoughts?"
			rows="4">
		</textarea>
		<button class="btn btn-secondary" disabled={pending}>
			{#if pending}
				Working...
			{:else}
				Comment
			{/if}
		</button>
	</fieldset>
	{#each issues as issue}
		<p class="pb-4 text-red-500">{issue.message}</p>
	{/each}
</form>
