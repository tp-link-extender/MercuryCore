<script lang="ts">
	import { Gradient } from "stripe-gradient"

	// Gradient must run upon page being loaded,
	// and cannot be rendered on serverside.
	onMount(() => new Gradient().initGradient("#gradient-canvas"))
</script>

<svelte:head>
	<meta
		name="description"
		content="Mercury: Endless possibilities. New features. Same nostalgia." />
	<meta property="og:image" content="/mercury.gif" />
	<title>Mercury: Endless possibilities. New features. Same nostalgia.</title>
</svelte:head>

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
	#wavep // rpcs3 momnt
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
		z-index 3
		height 60vh
		padding-top 35vh
		a
			margin 0

		#title
			font-size 4rem

	#moon
		margin-bottom min(22rem, 60vh)

	#gradient-canvas
		+lightTheme()
			--gradient-color-1 #5551ff
			--gradient-color-2 #5599ff
			--gradient-color-3 #55c3ff
			--gradient-color-4 #af79e6

		--gradient-color-1 #161a92
		--gradient-color-2 #2b0574
		--gradient-color-3 #6c2fb9
		--gradient-color-4 #060e25
</style>
