<script lang="ts">
	import { page } from "$app/stores"

	export let working = "Working..."
	export let submit = "Submit"
	export let formData: any // boooo but nothing else works
	const { message, enhance, delayed, capture, restore } = formData

	export const snapshot = { capture, restore }
</script>

<form use:enhance method="POST" {...$$restProps}>
	<fieldset class="pb-2">
		<slot />
	</fieldset>
	<button class="btn btn-success">
		{$delayed ? working : submit}
	</button>
</form>
<p
	class:text-success={$page.status == 200}
	class:text-danger={$page.status >= 400}>
	{$message || ""}
</p>
