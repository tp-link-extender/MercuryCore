<script lang="ts">
	import Pagepart from "../components/pagepart.svelte"
	import { Parallax, ParallaxLayer } from "svelte-parallax"
</script>

<svelte:head>
	<title>Home - Mercury</title>
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
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
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
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>
	<Pagepart fullwidth>
		<div>
			<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			<h1 class="fw-bolder fw-light text-dark text-center">Exactly 0% Kinery.</h1>
		</div>
		<div class="px-5"></div>
		<div>
			<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			<h1 class="fw-bolder fw-light text-dark text-center">That's 100% less Kinery than Tadah.</h1>
		</div>
	</Pagepart>


	<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
		<ParallaxLayer offset={0} rate={0}>
			<Pagepart>
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={0} rate={-2}>
			<Pagepart right>
				<h1 class="fw-bolder fw-light text-dark">Approximately 60,000 better than Polygon</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={0}>
			<Pagepart>
				<h1 class="fw-bolder fw-light text-light">Better website, too</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={1} rate={-2}>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>
	<Pagepart fullwidth>
		<div>
			<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			<h1 class="fw-bolder fw-light text-light text-center">Includes Web3 Technology.</h1>
		</div>
		<div class="px-5"></div>
		<div>
			<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			<h1 class="fw-bolder fw-light text-light text-center">It's on the BalochChain.</h1>
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
	
	main
		background: hsl(305, 63%, 80%)

		background-image: linear-gradient(180deg, rgba(255, 255, 255, 0), rgba(255, 255, 255, 1) 10%,  rgba(0, 0, 0, 0.2) 50%,  rgba(0, 0, 0, 1) 120%), radial-gradient(ellipse at top left, rgba(13, 110, 253, 0.5), #0000 50%), radial-gradient(ellipse at top right, rgba(255, 228, 132, 0.5), #0000 50%), radial-gradient(ellipse at center right, rgb(255,255,255), #0000 50%), radial-gradient(ellipse at center left, rgb(255,255,255), #0000 50%), radial-gradient(ellipse at center center, rgb(255,255,255), #0000 50%)
		// do not look at the last half of this gradient worst mistake of my life
</style>
