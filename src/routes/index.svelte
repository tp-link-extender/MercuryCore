<script lang="ts">
	import { onMount } from "svelte"
	import { fly } from "svelte/transition"
	import Gradient from "./gradient"
	import Pagepart from "../components/pagepart.svelte"
	import { Parallax, ParallaxLayer } from "svelte-parallax"

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

<main>
	<canvas id="gradient-canvas" class="position-relative" />

	<div id="info" class="container d-flex flex-column justify-content-center align-items-center">
		<svg viewBox="0 0 100 12" xmlns="http://www.w3.org/2000/svg">
			<text x="50" y="9" id="title" text-anchor="middle" font-size="9" fill="none" stroke-width=".15" stroke="#fff">Mercury</text>
		</svg>
		<p class="lead text-light">Endless possibilities. New features. Same nostalgia.</p>
		<span id="beta" class="badge text-white">Closed Beta</span>
	</div>

	<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
		<ParallaxLayer offset={0} rate={0}>
			<Pagepart>
				<img src="/devices.webp" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={0} rate={-2}>
			<Pagepart right>
				<div class="text">
					<h1 class="fw-bolder fw-light dark-text">Next-generation technologies</h1>
					<h4 class="dark-text">No revival even comes close as a rival.</h4>
				</div>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={0}>
			<Pagepart>
				<div class="text">
					<h1 class="fw-bolder fw-light dark-text">Lots of clients</h1>
					<h4 class="dark-text">Ranging from 1887 to 2087.</h4>
				</div>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={-2}>
			<Pagepart right>
				<img src="/devices.webp" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>

	<div in:fly={{ x: -300, duration: 1000 }} id="overlap">
		<h1 id="ultimate" class="fw-bolder fw-light dark-text text-center d-flex flex-column">The ultimate cross-platform private server.</h1>
		<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
			<ParallaxLayer offset={0} rate={0}>
				<Pagepart fullwidth>
					<div class="align-self-center d-flex flex-column align-items-center">
						<img class="device" src="/laptop.webp" alt="Laptop" />
					</div>
				</Pagepart>
			</ParallaxLayer>
			<ParallaxLayer offset={0} rate={-0.5}>
				<Pagepart fullwidth>
					<h1 bind:this={onPC} class="imagetext fw-bolder fw-light text-center text-light">On PC,</h1>
				</Pagepart>
			</ParallaxLayer>
		</Parallax>
		<div style="transform: translate(0px, -210vh)">
			<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
				<ParallaxLayer offset={1} rate={0}>
					<Pagepart fullwidth>
						<div class="align-self-center d-flex flex-column align-items-center">
							<img class="device" src="/mobile.webp" alt="Mobile" />
						</div>
					</Pagepart>
				</ParallaxLayer>
				<ParallaxLayer offset={1} rate={-0.5}>
					<Pagepart fullwidth>
						<h1 bind:this={onMobile} class="imagetext fw-bolder fw-light text-center text-light">and on mobile.</h1>
					</Pagepart>
				</ParallaxLayer>
			</Parallax>
		</div>
	</div>

	<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
		<ParallaxLayer offset={0} rate={0}>
			<Pagepart>
				<img src="/devices.webp" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={0} rate={-2}>
			<Pagepart right>
				<h1 class="fw-bolder fw-light dark-text">Approximately 60,000 better than Polygon</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={0}>
			<Pagepart>
				<h1 class="fw-bolder fw-light dark-text">Better website, too</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={-2}>
			<Pagepart right>
				<img src="/devices.webp" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>

	<Pagepart fullwidth>
		<div in:fly={{ x: -300, duration: 1000 }}>
			<img src="/devices.webp" alt="Devices playing Mercury" />
			<h1 class="fw-bolder fw-light dark-text text-center">Includes Web3 Technology.</h1>
		</div>
		<div class="px-5" />
		<div in:fly={{ x: 300, duration: 1000 }}>
			<img src="/devices.webp" alt="Devices playing Mercury" />
			<h1 class="fw-bolder fw-light dark-text text-center">It's on the BalochChain.</h1>
		</div>
	</Pagepart>
</main>

<style lang="sass">
	#gradient-canvas
		height: 100vh
		--gradient-color-1: #161a92
		--gradient-color-2: #2b0574
		--gradient-color-3: #6c2fb9
		--gradient-color-4: #060e25
		width: 100vw
	
	#info
		margin-top: -100vh
		height: 100vh
		position: relative
		#title
			font-weight: bold
		#beta
			outline: 2px solid white
			font-size: 0.8rem

	h1, h4
		width: 100%
		text-align: center

	.text
		width: 100%
	.imagetext
		font-size: 3vw

	#ultimate
		margin: 30vh 0 -15vh 0
	#overlap
		height: 150vh
		margin-top: -40vh

	.device
		width: 50%

	img
		width: 100%

			
	
	main
		margin-top: -10vh
		background: rgba(0, 0, 0, 0)
</style>
