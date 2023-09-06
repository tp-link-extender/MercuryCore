<script lang="ts">
	import { Gradient } from "stripe-gradient"
	import { Canvas } from "@threlte/core"

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

	const range = (n: number) =>
			Array.from({ length: n }, (_, index) => -Math.floor(n / 2) + index),
		columns = range(37),
		rows = range(19)

	let cubesMoved = 0,
		cubesClicked = 0,
		completed = false

	$: cubePercentage = Math.floor(
		(cubesMoved / (columns.length * rows.length)) * 100
	)
	$: cubePercentage2 = Math.min(
		Math.floor((cubesClicked / (columns.length * rows.length)) * 200),
		100
	)

	$: if (cubePercentage >= 100 && cubePercentage2 >= 100) {
		completed = true
		window.open("https://youtube.com/watch?v=cvh0nX08nRw", "_blank")
	}
</script>

<Head
	title="Mercury: Endless possibilities. New features. Same nostalgia."
	description="Mercury: Endless possibilities. New features. Same nostalgia."
	ogImage="/mercury.gif" />

<canvas id="gradient-canvas" class="w-100 h-100 position-fixed" />

<div
	id="info"
	class="container d-flex flex-column justify-content-center align-items-center position-relative">
	<div
		id="moon"
		class="container d-flex flex-column justify-content-center align-items-center position-absolute">
		<Moon />
	</div>
	<h1 id="title" class="fw-bolder text-white opacity-75">Mercury 2</h1>
	<p class="lead text-white text-center">
		Endless possibilities. New features. Same nostalgia.
	</p>
	<div class="d-inline mb-3">
		<b>
			<a
				type="button"
				href="/register"
				class="d-inline btn btn-sm btn-success text-decoration-none">
				Register <i class="fa fa-chevron-right" />
			</a>
		</b>
		<b>
			<a
				type="button"
				href="/login"
				class="d-inline btn btn-sm btn-primary text-decoration-none">
				Login <i class="fa fa-chevron-right" />
			</a>
		</b>
	</div>
	<a href="/about" class="text-decoration-none pt-3 fs-5">
		About us <i class="fa fa-chevron-right" />
	</a>
</div>
<div id="wavep" class="w-100 h-100 position-absolute top-0 overflow-hidden">
	<div class="w-100 position-absolute bottom-0">
		<div class="position-absolute" />
		<div class="position-absolute" />
	</div>
</div>

<style lang="stylus">
	canvas
	#gradientbg
		+lightTheme()
			--gradient-color-1 #5551ff
			--gradient-color-2 #5599ff
			--gradient-color-3 #55c3ff
			--gradient-color-4 #af79e6

		--gradient-color-1 #161a92
		--gradient-color-2 #2b0574
		--gradient-color-3 #6c2fb9
		--gradient-color-4 #060e25

	canvas
	#moon
	#cubes
		transition opacity 0.75s ease-in

	#cubesMoved
		transform translate(-50%, -50%)

	#gradientbg
		background linear-gradient(
			25deg,
			var(--gradient-color-2),
			var(--gradient-color-4),
			var(--gradient-color-1),
			var(--gradient-color-3)
		)

	#wavep // rpcs3 momnt
		pointer-events none
		div
			transition all 1s ease-in-out 0s
			div
				background url("/landing/wave.svg") repeat-x
				top -198px
				width 6144px
				height 198px
				animation 11s cubic-bezier(0.36, 0.45, 0.63, 0.53) 0s infinite normal none running waves
				transform translate3d(0px,0px,0px)
				@keyframes waves
					0%
						margin-left 0
					100%
						margin-left -1600px

			div:nth-of-type(2)
				animation 11s cubic-bezier(0.4, 0.2, 0.2, 0.2) -0.124s infinite normal none running waves, 11s ease -1.24s infinite normal none running swell
				top -174px

	#info
		background: none
		height 75vh
		transition padding-top 1s ease-in-out
		z-index 500

	#infotext
		transition margin-top 1s ease-in-out
		
	a
		margin 0

	h1
		font-size 4rem

	#moon
		height: 20vh
		margin-bottom min(22rem, 60vh)
</style>
