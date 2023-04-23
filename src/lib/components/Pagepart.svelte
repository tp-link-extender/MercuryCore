<script lang="ts">
	// Used on the About page to allow a part of the page to be displayed
	// fullscreen or on either side, and to be animated in.

	import { fly } from "svelte/transition"
	import { inview } from "svelte-inview"

	let isInView: boolean
	export let right = false
	export let fullwidth = false
</script>

<div
	class="container {fullwidth ? 'full min-vw-100' : 'half'}"
	id={fullwidth ? "" : right ? "right" : "left"}
	use:inview={{ unobserveOnEnter: true, rootMargin: "-20%" }}
	on:change={({ detail }) => (isInView = detail.inView)}>
	{#if isInView}
		<div
			in:fly={{ y: -100, duration: 500 }}
			id="b"
			class="d-flex flex-row align-items-center min-vh-100">
			<slot />
		</div>
	{:else}
		<div id="b" class="min-vh-100" />
	{/if}
</div>

<style lang="sass">
	#b
		padding: 15vh

	@media only screen and (max-width: 768px)
		#b
			padding: 1vh	

	.half
		width: 50vw
	.full
		padding: 0
		margin: 0

	#right
		margin-left: 50vw
	#left
		margin-left: 0

</style>
