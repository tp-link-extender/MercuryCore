<script lang="ts">
	import type { Snippet } from "svelte"

	const { children }: { children?: Snippet } = $props()
</script>

<!-- basically just <noscript> except not when there's no script -->
<!-- uhh yeah -->

{#await new Promise(r => r(0))}
	{@render children?.()}
{/await}
