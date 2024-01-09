<script lang="ts">
	import g from "stripe-gradient"
	const { Gradient } = g
	import { Canvas } from "@threlte/core"
	import Waves from "./Waves.svelte"

	// Gradient must run upon page being loaded,
	// and cannot be rendered on serverside.
	let canvasOpacity = 0,
		infoPadding = 50,
		infoTextMargin = -30

	onMount(() => {
		new Gradient().initGradient("#gradientcanvas")
		// fade gradient and moon in
		canvasOpacity = 1
		infoPadding = 30
		infoTextMargin = 0
	})
</script>

<Head
	title="Mercury: Endless possibilities. New features. Same nostalgia."
	description="Mercury: Endless possibilities. New features. Same nostalgia."
	ogImage="/mercury.gif" />

<div id="gradientbg" class="w-full h-full fixed" />

<canvas
	id="gradientcanvas"
	class="w-full h-full fixed"
	style="opacity: {canvasOpacity}" />

<Waves reverse />

<div
	id="info"
	class="ctnr flex justify-center items-center h-75vh"
	style="padding-top: {infoPadding}vh">
	<div
		id="moon"
		class="absolute w-full h-20vh"
		style="opacity: {canvasOpacity}">
		<Canvas>
			<Moon />
		</Canvas>
	</div>
	<div
		id="infotext"
		class="flex flex-col justify-center items-center relative"
		style="padding-top: {infoTextMargin}vh">
		<h1 class="sf font-bold opacity-75 text-16">Mercury 2</h1>
		<p class="lead text-center">
			Endless possibilities. New features. Same nostalgia.
		</p>
		<div class="inline pb-2">
			<a
				type="button"
				href="/login"
				class="inline btn btn-sm btn-secondary">
				<b>
					Login <fa fa-chevron-right />
				</b>
			</a>
			<a
				type="button"
				href="/register"
				class="inline btn btn-sm btn-primary">
				<b>
					Register <fa fa-chevron-right />
				</b>
			</a>
		</div>
		<a href="/about" class="btn btn-sm btn-tertiary">
			About us <fa fa-chevron-right />
		</a>
	</div>
</div>

<style lang="stylus">
	canvas
	#gradientbg
		--gradient-color-1 #161a92
		--gradient-color-2 #2b0574
		--gradient-color-3 #6c2fb9
		--gradient-color-4 #060e25

	canvas
	#moon
		transition opacity 0.75s ease-in

	#gradientbg
		background linear-gradient(
			25deg,
			var(--gradient-color-2),
			var(--gradient-color-4),
			var(--gradient-color-1),
			var(--gradient-color-3)
		)

	#info
	#infotext
		transition padding-top 1s ease-in-out

	#moon
		margin-bottom min(22rem, 60vh)
</style>
