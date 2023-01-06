<script lang="ts">
	import { onMount } from "svelte"
	import Gradient from "$lib/gradient"
	import Moon from "$lib/components/Moon.svelte"

	let onPC: HTMLElement
	let onMobile: HTMLElement

	onMount(() => {
		// otherwise "window is not defined"
		const gradient = new Gradient()
		gradient.initGradient("#gradient-canvas")

		window.addEventListener("scroll", function () {
			if (onPC) {
				const distanceToTop = window.pageYOffset + onPC.getBoundingClientRect().top
				const scrollTop = document.documentElement.scrollTop + window.innerHeight / 2

				let opacity = 1

				if (scrollTop > distanceToTop) {
					opacity = 1 - (scrollTop - distanceToTop) / (onPC.offsetHeight * 3)
				}
				onPC.style.opacity = opacity.toString()
			}

			if (onMobile) {
				const distanceToTop = window.pageYOffset + onMobile.getBoundingClientRect().top
				const scrollTop = document.documentElement.scrollTop + window.innerHeight / 1.7

				let opacity = 0

				if (scrollTop > distanceToTop) {
					opacity = (scrollTop - distanceToTop) / (onMobile.offsetHeight * 3)
				}
				onMobile.style.opacity = opacity.toString()
			}
		})
	})
</script>

<svelte:head>
	<title>Mercury - Mercury</title>
</svelte:head>

<div id="all">
	<canvas id="gradient-canvas" />

	<div id="info" class="container d-flex flex-column justify-content-center align-items-center">
		<div id="moon" class="container d-flex flex-column justify-content-center align-items-center">
			<div class="object">
				<Moon />
			</div>
		</div>
		<br />
		<br />
		<br />
		<h1 id="title" class="fw-bolder light-text">Mercury 2</h1>
		<p class="lead light-text">Endless possibilities. New features. Same nostalgia.</p>
		<span class="badge light-text">Closed Beta</span>
	</div>
	<div id="wavep" class="w-100 h-100">
		<div class="w-100">
			<div />
			<div />
		</div>
	</div>
</div>
<style lang="sass">
	#gradient-canvas
		height: 100vh
		width: 100vw
		position: absolute
		top: 0
		left: 0

	#wavep // rpcs3 momnt
		position: absolute
		top: 0
		overflow: hidden
		div
			position: absolute
			bottom: 0
			transition: all 1s ease-in-out 0s
			div
				background: url("/wave.svg") repeat-x
				position: absolute
				top: -198px
				width: 6144px
				height: 198px
				animation: 11s cubic-bezier(0.36, 0.45, 0.63, 0.53) 0s infinite normal none running waves
				transform: translate3d(0px,0px,0px)
				@keyframes waves
					0%
						margin-left: 0
					100%
						margin-left: -1600px
			div:nth-of-type(2)
				animation: 11s cubic-bezier(0.4, 0.2, 0.2, 0.2) -0.124s infinite normal none running waves, 11s ease -1.24s infinite normal none running swell
				top: -174px
	
		
	#info
		height: 100vh
		width: 100vw
		position: relative
		#title
			font-size: 4rem
			opacity: 0.8
			
		.badge
			background: var(--light-text)
			opacity: 0.5
			color: var(--dark-text)
			font-size: 0.8rem
	#moon
		z-index: 2
		padding-bottom: 10rem
		position: absolute
	#all
		margin-top: -10vh
		background: rgba(0, 0, 0, 0)
</style>
