<script lang="ts">
	import { page } from "$app/stores"

	export let comment = false
	export let formData: any

	const { form, errors, message, constraints, enhance, delayed } = formData
</script>

<form use:enhance class="py-2" method="POST" action="?/reply">
	<label for="content" class="light-text py-2">
		Post a {comment ? "comment" : "reply"}
	</label>
	<fieldset class="w-7/12 flex gap-4 items-end">
		<textarea
			bind:value={$form.content}
			{...$constraints.content}
			class="form-control {$errors.content ? 'is-in' : ''}valid"
			name="content"
			placeholder="What are your thoughts?"
			rows="4" />
		<button class="btn btn-success">
			{#if $delayed}
				Working...
			{:else}
				{comment ? "Comment" : "Reply"}
			{/if}
		</button>
	</fieldset>
	<p
		class="pb-4"
		class:text-success={$page.status == 200}
		class:text-danger={$page.status >= 400}>
		{$message || ""}
	</p>
</form>
