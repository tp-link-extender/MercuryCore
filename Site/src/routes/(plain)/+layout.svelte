<script lang="ts">
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();
</script>

<!--
	Plain pages (login and register) do not have a navbar or footer.
-->

<main>
	{@render children?.()}
</main>
