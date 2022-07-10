<script lang="ts">
	import { fly } from "svelte/transition"
	import IntersectionObserver from "svelte-intersection-observer"

	let element: HTMLElement
	let intersecting: boolean
	export let test = false
</script>

<IntersectionObserver {element} bind:intersecting>
	<div bind:this={element} class="container justify-content-center">
		<div id="b">
			{#if intersecting}
				<div transition:fly={{ x: test ? -300 : 300, duration: 1000}} class="row align-items-center">
					<slot />
				</div>
			{/if}
		</div>
	</div>
</IntersectionObserver>

<style lang="sass">
	#b
		height: 30vh

</style>
