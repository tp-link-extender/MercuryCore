<script lang="ts">
	import { fly } from "svelte/transition"
	import IntersectionObserver from "svelte-intersection-observer"

	let element: HTMLElement
	let intersecting: boolean
	export let right = false
	export let middle = false

	let id = middle ? "middle" : right ? "right" : "left"
</script>

<IntersectionObserver {element} bind:intersecting>
	<div bind:this={element} class="container" {id}>
		<div>
			<!-- {#if intersecting} -->
				<div id="b" transition:fly={{ x: 300, duration: 1}} class="d-flex flex-column justify-content-center align-items-center">
					<slot />
				</div>
			<!-- {/if} -->
		</div>
	</div>
</IntersectionObserver>

<style lang="sass">
	#b
		height: 50vh
		width: 33vh

	#right
		margin-left: 66vw
	#middle
		margin-left: 41vw
</style>
