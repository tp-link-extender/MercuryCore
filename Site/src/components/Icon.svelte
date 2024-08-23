<script lang="ts">
	import icons, { type IconName } from "$components/icons/icons.ts"

	export let icon: IconName // keyof typeof icons
	export let fill = "fill-white"
</script>

<span {...$$restProps} class={fill}>
	<svelte:component this={icons[icon]} />
</span>

<style>
	:global(svg) {
		height: 1rem;
		width: 1rem;
	}
	:global(svg),
	:global(path) {
		fill: inherit;
	}
</style>
