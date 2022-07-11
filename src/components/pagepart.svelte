<script lang="ts">
	import { fly } from "svelte/transition"
	export let right = false

	let id = right ? "right" : "left"
</script>

<div class="container" {id}>
	<div id="b" transition:fly={{ x: 300, duration: 1000 }} class="d-flex flex-column justify-content-center align-items-center">
		<slot />
	</div>
</div>

<style lang="sass">
	#b
		height: 100vh
		width: 50vw
		padding: 15vh

	#right
		margin-left: 50vw

	#left
		margin-left: 0
</style>
