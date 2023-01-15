<script lang="ts">
	import { onMount } from "svelte"
	import { ArrowRight } from "svelte-bootstrap-icons"
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
	<canvas id="gradient-canvas" class="vh-100 vw-100 position-absolute top-0 left-0" />

	<div id="info" class="z-3 container d-flex flex-column justify-content-center align-items-center position-relative">
		<div id="moon" class="container d-flex flex-column justify-content-center align-items-center z-2 position-absolute">
		<Moon />
		</div>
		<br />
		<br />
		<br />
		<h1 id="title" class="fw-bolder text-white z-3 opacity-75">Mercury 2</h1>
		<p class="lead text-white">Endless possibilities. New features. Same nostalgia.</p>
		<h5>
			<span class="badge dark-text opacity-50">Closed Beta</span>
			<a type="button" href="/register" class="btn btn-sm btn-success ms-3 rounded">Register <ArrowRight class="ms-1"/></a>
		</h5>
	</div>
	<div id="wavep" class="w-100 h-100 position-absolute top-0 overflow-hidden">
		<div class="w-100 position-absolute bottom-0">
			<div class="position-absolute" />
			<div class="position-absolute" />
		</div>
	</div>
</div>

<style lang="sass">
	#wavep // rpcs3 momnt
		div
			transition: all 1s ease-in-out 0s
			div
				background: url("/wave.svg") repeat-x
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
		padding-top: 35vh
		a
			margin: 0

		#title
			font-size: 4rem

		.badge
			background: var(--light-text)
	
	#moon
		margin-bottom: 20vh

	#all
		margin-top: -20vh
		background: rgba(0, 0, 0, 0)

		@media (prefers-color-scheme: light)
			--gradient-color-1: #5551ff
			--gradient-color-2: #5599ff
			--gradient-color-3: #55c3ff
			--gradient-color-4: #af79e6

		--gradient-color-1: #161a92
		--gradient-color-2: #2b0574
		--gradient-color-3: #6c2fb9
		--gradient-color-4: #060e25
</style>
