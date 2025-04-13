<script lang="ts">
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();
</script>

<!-- the opposite of <noscript> -->

{#await new Promise(r => r(0)) then}
	{@render children?.()}
{/await}
