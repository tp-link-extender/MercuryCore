<script lang="ts">
	import { page } from "$app/stores"

	export let working = "Working..."
	export let submit = "Submit"

	export let inline = false
	export let formData: any // boooo but nothing else works
	const { errors, message, enhance, delayed } = formData

	$: other = ($errors as any).other || ""
</script>

<form use:enhance method="POST" {...$$restProps}>
	<fieldset class={inline ? "input-group" : "pb-2"}>
		<slot />
		{#if submit}
			<button class="btn btn-success">
				{@html /* ecks ess ess moment */ $delayed ? working : submit}
			</button>
		{/if}
	</fieldset>
	{#if other}
		<p class="text-danger">
			{other}
		</p>
	{/if}
</form>
<p
	class={inline ? "mb-0 pb-3" : ""}
	class:text-success={$page.status == 200}
	class:text-danger={$page.status >= 400}>
	{$message || ""}
</p>
