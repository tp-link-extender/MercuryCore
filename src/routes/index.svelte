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
		<ParallaxLayer offset={1} rate={-3}>
			<Pagepart>
				<h1 class="fw-bolder fw-light text-dark">Lots of clients</h1>
			</Pagepart>
			<Pagepart>
				<h1 class="fw-bolder fw-light text-dark">Better than Tadah</h1>
			</Pagepart>
			<Pagepart>
				<h1 class="fw-bolder fw-light text-dark">Exactly 0% Kinery</h1>
			</Pagepart>
		</ParallaxLayer>
		<ParallaxLayer offset={0} rate={1}>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			</Pagepart>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			</Pagepart>
			<Pagepart right>
				<img src="/devices.png" alt="Devices playing Mercury. Rendered with models from deviceframes.com" />
			</Pagepart>
		</ParallaxLayer>
	</Parallax>
</main>

<style lang="sass">
	img
		width: 100%

	#info
		height: 100vh
	
	main
		background: hsl(305, 63%, 80%)

		background-image: linear-gradient(180deg, rgba(255, 255, 255, 0), rgba(255, 255, 255, 1) 25%,  rgba(0, 0, 0, 0.2) 50%,  rgba(0, 0, 0, 1) 120%), radial-gradient(ellipse at top left, rgba(13, 110, 253, 0.5), #0000 50%), radial-gradient(ellipse at top right, rgba(255, 228, 132, 0.5), #0000 50%), radial-gradient(ellipse at center right, rgb(255,255,255), #0000 50%), radial-gradient(ellipse at center left, rgb(255,255,255), #0000 50%), radial-gradient(ellipse at center center, rgb(255,255,255), #0000 50%)
		// do not look at the last half of this gradient worst mistake of my life
</style>
