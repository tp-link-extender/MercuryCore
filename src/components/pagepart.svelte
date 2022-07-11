<script lang="ts">
	import { fly } from "svelte/transition"
	export let right = false
	export let fullwidth = false

	let side = fullwidth ? "" : right ? "right" : "left"
	let width = fullwidth ? "full" : "half"
</script>

<div class={`container ${width}`} id={side}>
	<div id="b" transition:fly={{ x: 300, duration: 1000 }} class="d-flex flex-row align-items-center">
		<slot />
	</div>
</div>

<style lang="sass">
	#b
		height: 100vh
		padding: 15vh

	.half
		width: 50vw
	.full
		width: 100vw

	#right
		margin-left: 50vw
	#left
		margin-left: 0
	
</style>
