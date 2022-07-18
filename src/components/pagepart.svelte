<script lang="ts">
	import { fly } from "svelte/transition"
	import { inview } from "svelte-inview"

	export let right = false
	export let fullwidth = false
	let isInView: boolean

	const side = fullwidth ? "" : right ? "right" : "left"
	const width = fullwidth ? "full" : "half"
</script>

<div class={`container ${width}`} id={side} use:inview={{ unobserveOnEnter: true, rootMargin: "-20%" }} on:change={({ detail }) => (isInView = detail.inView)}>
	{#if isInView}
		<div in:fly={{ y: -100, duration: 500 }} id="b" class="d-flex flex-row align-items-center">
			<slot />
		</div>
	{:else}
		<div id="b" />
	{/if}
</div>

<style lang="sass">
	#b
		min-height: 100vh
		padding: 15vh

	.half
		width: 50vw
	.full
		min-width: 100vw
		padding: 0
		margin: 0

	#right
		margin-left: 50vw
	#left
		margin-left: 0

</style>
