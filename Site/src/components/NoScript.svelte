<script lang="ts">
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();
</script>

<!-- basically just <noscript> except not when there's no script -->
<!-- uhh yeah -->

{#await new Promise(r => r(0))}
	{@render children?.()}
{/await}
