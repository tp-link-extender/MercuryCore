<script lang="ts">
	import { page } from "$app/state"

	const {
		comment = false,
		formData
	}: {
		comment?: boolean
		formData: import("sveltekit-superforms").SuperForm<any>
	} = $props()

	const {
		form,
		errors,
		message,
		constraints,
		enhance: enh,
		delayed
	} = formData
</script>

<form use:enh method="POST" action="?/reply" class="py-2">
	<label for="content" class="light-text py-2">
		Post a {comment ? "comment" : "reply"}
	</label>
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
				{comment ? "Comment" : "Reply"}
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
