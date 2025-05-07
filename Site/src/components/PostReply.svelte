<script lang="ts">
	import { page } from "$app/state"

	const {
		formData
	}: { formData: import("sveltekit-superforms").SuperForm<any> } = $props()

	const { form, errors, message, constraints, enhance, delayed } = formData
</script>

<form use:enhance method="POST" action="?/comment" class="py-2">
	<label for="content" class="light-text py-2">Post a comment</label>
	<fieldset class="max-w-140 flex gap-4 items-end">
		<textarea
			bind:value={$form.content}
			{...$constraints.content}
			class={{ "is-invalid": $errors.content }}
			name="content"
			placeholder="What are your thoughts?"
			rows="4">
		</textarea>
		<button class="btn btn-secondary">
			{#if $delayed}
				Working...
			{:else}
				Comment
			{/if}
		</button>
	</fieldset>
	<p
		class={[
			"pb-4",
			{
				"text-emerald-600": page.status === 200,
				"text-red-500": page.status >= 400
			}
		]}>
		{$message || $errors.content || ""}
	</p>
</form>
