<script lang="ts">
	import type { Snippet } from "svelte"

	const { children }: { children: Snippet } = $props()
</script>

<!-- the opposite of <noscript> -->

{#await new Promise(r => r(0)) then}
	{@render children()}
{/await}
