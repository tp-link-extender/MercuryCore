<script lang="ts">
	import { onMount } from "svelte/internal"
	import { fly } from "svelte/transition"
	import Pagepart from "../components/pagepart.svelte"
	import { Parallax, ParallaxLayer } from "svelte-parallax"

	let onPC: HTMLElement
	let onMobile: HTMLElement

	onMount(() => { // otherwise "window is not defined"
		window.addEventListener("scroll", function () {
			if (onPC) {
				let distanceToTop = window.pageYOffset + onPC.getBoundingClientRect().top
				let scrollTop = document.documentElement.scrollTop + window.innerHeight / 2
	
				let opacity = 1
	
				if (scrollTop > distanceToTop) {
					opacity = 1 - (scrollTop - distanceToTop) / ( onPC.offsetHeight * 3)
				}
				onPC.style.opacity = opacity.toString()
			}

			if (onMobile) {
				let distanceToTop = window.pageYOffset + onMobile.getBoundingClientRect().top
				let scrollTop = document.documentElement.scrollTop + window.innerHeight / 1.7
	
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
	<div id="info" class="container d-flex flex-column justify-content-center align-items-center">
		<h1 class="fw-bolder fw-light text-dark" style="font-size: 4rem">Mercury</h1>
		<p class="lead text-dark">Endless possibilities. New features. Same nostalgia.</p>
		<span class="badge bg-warning text-black">Closed Beta</span>
	</div>

	<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
		<ParallaxLayer offset={0} rate={0}>
			<Pagepart>
				<img src="/devices.png" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={0} rate={-2}>
			<Pagepart right>
				<div class="text">
					<h1 class="fw-bolder fw-light text-dark">Next-generation technologies</h1>
					<h4>No revival even comes close as a rival.</h4>
				</div>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={0}>
			<Pagepart>
				<div class="text">
					<h1 class="fw-bolder fw-light text-dark">Lots of clients</h1>
					<h4>Ranging from 1887 to 2087.</h4>
				</div>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={-2}>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>

	<div transition:fly={{ x: -300, duration: 1000 }} id="overlap">
		<h1 class="fw-bolder fw-light text-dark text-center d-flex flex-column">The ultimate cross-platform private server.</h1>
		<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
			<ParallaxLayer offset={0} rate={0}>
				<Pagepart fullwidth>
					<div class="align-self-center d-flex flex-column align-items-center">
						<img class="device" src="/laptop.png" alt="Laptop" />
					</div>
				</Pagepart>
			</ParallaxLayer>
			<ParallaxLayer offset={0} rate={-0.5}>
				<Pagepart fullwidth>
					<h1 bind:this={onPC} class="fw-bolder fw-light text-center text-light">On PC,</h1>
				</Pagepart>
			</ParallaxLayer>
		</Parallax>
		<div style="transform: translate(0px, -250vh)">
			<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
				<ParallaxLayer offset={1} rate={0}>
					<Pagepart fullwidth>
						<div class="align-self-center d-flex flex-column align-items-center">
							<img class="device" src="/mobile.png" alt="Mobile" />
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
				<img src="/devices.png" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={0} rate={-2}>
			<Pagepart right>
				<h1 class="fw-bolder fw-light text-dark">Approximately 60,000 better than Polygon</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={0}>
			<Pagepart>
				<h1 class="fw-bolder fw-light text-dark">Better website, too</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={-2}>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>

	<Pagepart fullwidth>
		<div transition:fly={{ x: -300, duration: 1000 }}>
			<img src="/devices.png" alt="Devices playing Mercury" />
			<h1 class="fw-bolder fw-light text-dark text-center">Includes Web3 Technology.</h1>
		</div>
		<div class="px-5" />
		<div transition:fly={{ x: 300, duration: 1000 }}>
			<img src="/devices.png" alt="Devices playing Mercury" />
			<h1 class="fw-bolder fw-light text-dark text-center">It's on the BalochChain.</h1>
		</div>
	</Pagepart>
</main>

<style lang="sass">
	h1, h4
		width: 100%
		text-align: center

	.text
		width: 100%

	#overlap
		height: 120vh
	.imagetext
		color: #f3f4f6

	.device
		width: 50%

	img
		width: 100%

	#info
		height: 100vh
	
	main
		margin-top: -8vh
		background: hsl(305, 63%, 80%)

		background-image: linear-gradient(180deg, rgba(243, 244, 246, 0), rgba(243, 244, 246, 1) 10%), radial-gradient(ellipse at top left, rgba(13, 110, 253, 0.5), #0000 50%), radial-gradient(ellipse at top right, rgba(255, 228, 132, 0.5), #0000 50%)
		// do not look at the last half of this gradient worst mistake of my life
</style>
