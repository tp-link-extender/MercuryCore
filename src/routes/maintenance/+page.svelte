<script lang="ts">
	import g from "stripe-gradient"
	const { Gradient } = g
	import { Canvas } from "@threlte/core"
	import { onMount } from "svelte"

	export let data

	// Gradient must run upon page being loaded, and cannot be rendered on serverside.
	onMount(() => new Gradient().initGradient("#gradient-canvas"))
</script>

<Head
	title="Maintenance"
	description="Mercury: Endless possibilities. New features. Same nostalgia."
	ogImage="/mercury.gif" />

<canvas id="gradient-canvas" class="w-full h-full fixed" />

<div id="info" class="ctnr flex flex-col justify-center items-center relative">
	<div id="moon" class="ctnr absolute">
		<Canvas>
			<Moon
				item={{
					name: "wrench",
					camPos: [100, 20, 100]
				}} />
		</Canvas>
	</div>
	<h1 id="title" class="font-black text-white opacity-75">Mercury 2</h1>
	<p class="text-base text-white opacity-75 text-center">
		is currently undergoing maintenance. Check back later!
	</p>
	<a
		href="https://status.{data.domain}"
		class="no-underline pt-4 text-xs font-bold accent-text">
		Status <fa fa-chevron-right />
	</a>
</div>

<style lang="stylus">
	#title
		font-size 4rem

	#info
		z-index 3
		height 60vh
		padding-top 40vh

	#moon
		height: 20vh
		margin-bottom min(15rem, 40vh)

	#gradient-canvas
		--gradient-color-1 #555
		--gradient-color-2 #333340
		--gradient-color-3 #222240
		--gradient-color-4 #222228
</style>
