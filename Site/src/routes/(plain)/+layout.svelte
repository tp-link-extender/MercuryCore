<script lang="ts">
	import type { Snippet } from "svelte"

	const { children }: { children: Snippet } = $props()
</script>

<!-- Plain pages (login and register) do not have a navbar or footer. -->

<main>
	{@render children()}
</main>
