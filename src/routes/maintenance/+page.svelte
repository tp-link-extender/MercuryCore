<script lang="ts">
	import { onMount } from "svelte"
	import Gradient from "$lib/gradient"
	import Moon from "$lib/components/Moon.svelte"

	// Gradient must run upon page being loaded,
	// and cannot be rendered on serverside.
	onMount(() => new Gradient().initGradient("#gradient-canvas"))

	const images = ["tools", "gears", "gear", "wrench", "hammer", "screwdriver"]
</script>

<svelte:head>
	<meta
		name="description"
		content="Mercury: Endless possibilities. New features. Same nostalgia." />
	<meta property="og:image" content="/mercury.gif" />
	<title>Maintenance - Mercury</title>
</svelte:head>

<canvas id="gradient-canvas" class="w-100 h-100 position-fixed" />

<div
	id="info"
	class="container d-flex flex-column justify-content-center align-items-center position-relative">
	<div
		id="moon"
		class="container d-flex flex-column justify-content-center align-items-center position-absolute">
		<Moon
			item={{
				name: "wrench",
				camPos: { x: 100, y: 20, z: 100 },
			}} />
	</div>
	<h1 id="title" class="fw-bolder text-white opacity-75">Mercury 2</h1>
	<p class="h4 text-white opacity-75 text-center">
		is currently undergoing maintenance. Check back later!
	</p>
	<button class="btn btn-link text-decoration-none pt-3 fs-5 fw-bold">
		Status <i class="fa fa-chevron-right" />
	</button>
</div>

<style lang="sass">
	#title
		font-size: 4rem

	#info
		z-index: 3
		height: 60vh
		padding-top: 40vh

	#moon
		margin-bottom: min(15rem, 40vh)

	#gradient-canvas
		--gradient-color-1: #555
		--gradient-color-2: #333340
		--gradient-color-3: #222240
		--gradient-color-4: #222228
</style>
