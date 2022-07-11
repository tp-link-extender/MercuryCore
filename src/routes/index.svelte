<script lang="ts">
	import { fly } from "svelte/transition"
	import Pagepart from "../components/pagepart.svelte"
	import { Parallax, ParallaxLayer } from "svelte-parallax"
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
				<h1 class="fw-bolder fw-light text-dark">Better than Tadah</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={0}>
			<Pagepart>
				<h1 class="fw-bolder fw-light text-dark">Lots of clients</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={-2}>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>

	<Pagepart fullwidth>
		<div transition:fly={{ x: -300, duration: 1000 }} class="d-flex flex-column">
			<h1 class="fw-bolder fw-light text-dark text-center">The ultimate cross-platform private server.</h1>
			<br /><br />
			<div class="position-relative col-6">
				<img src="/desktop.png" alt="Desktop" />
				<h1 id="desktop" class="imagetext fw-bolder fw-light text-light text-center position-absolute">On desktop,</h1>
			</div>
			<br /><br />
			<div class="position-relative col-6 align-self-end">
				<img src="/laptop.png" alt="Laptop" />
				<h1 class="imagetext fw-bolder fw-light text-light text-center position-absolute">On laptop,</h1>
			</div>
			<br /><br />
			<div class="position-relative col-6">
				<img src="/mobile.png" alt="Mobile" />
				<h1 id="mobile" class="imagetext fw-bolder fw-light text-light text-center position-absolute">On mobile.</h1>
			</div>
		</div>
	</Pagepart>

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
	h1
		width: 100%
		text-align: center

	img
		width: 100%

	#info
		height: 100vh

	.imagetext
		top: 37%
		width: 50%
		left: 25%
		z-index: 3
	#desktop
		top: 25%
	#mobile
		top: 44%
	
	main
		margin-top: -8vh
		background: hsl(305, 63%, 80%)

		background-image: linear-gradient(180deg, rgba(243, 244, 246, 0), rgba(243, 244, 246, 1) 10%), radial-gradient(ellipse at top left, rgba(13, 110, 253, 0.5), #0000 50%), radial-gradient(ellipse at top right, rgba(255, 228, 132, 0.5), #0000 50%)
		// do not look at the last half of this gradient worst mistake of my life
</style>
