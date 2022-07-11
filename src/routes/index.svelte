<script lang="ts">
	import Pagepart from "../components/pagepart.svelte"
	import { Parallax, ParallaxLayer } from "svelte-parallax"

	let vr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<main>
	<div id="info" class="container d-flex flex-column justify-content-center align-items-center">
		<h1 class="fw-bolder fw-light text-dark" style="font-size: 4rem">Mercury</h1>
		<p class="lead text-center text-dark">Endless possibilities. New features. Same nostalgia.</p>
		<span class="badge bg-warning text-black">Closed Beta</span>
	</div>

	<Parallax sections={3} config={{ stiffness: 1, damping: 1 }}>
		<ParallaxLayer offset={0} rate={1}>
			{#each vr as i}
				<Pagepart>
					<img src="/devices.png" alt="Devices, rendered with deviceframes.com" />
					<h1 class="fw-bolder fw-light text-dark text-center" style="font-size: 2.5rem">Cross-platform play</h1>
				</Pagepart>
			{/each}
		</ParallaxLayer>
		<ParallaxLayer offset={3} rate={-1.5}>
			{#each vr as i}
				<Pagepart middle>
					<img src="/devices.png" alt="Devices, rendered with deviceframes.com" />
					<h1 class="fw-bolder fw-light text-dark text-center" style="font-size: 2.5rem">Cross-platform play</h1>
				</Pagepart>
			{/each}
		</ParallaxLayer>
		<ParallaxLayer offset={3} rate={-3}>
			{#each vr as i}
				<Pagepart right>
					<img src="/devices.png" alt="Devices, rendered with deviceframes.com" />
					<h1 class="fw-bolder fw-light text-dark text-center" style="font-size: 2.5rem">Cross-platform play</h1>
				</Pagepart>
			{/each}
		</ParallaxLayer>
	</Parallax>
	<br /><br /><br /><br /><br />
</main>


<style lang="sass">
	img
		width: 100%

	#info
		height: 100vh
	
	main
		height: 420vh
		background: hsl(305, 63%, 80%)

		background-image: linear-gradient(180deg, rgba(255, 255, 255, 0.01), rgba(255, 255, 255, 1) 25%,  rgba(0, 0, 0, 0.2) 50%,  rgba(0, 0, 0, 1) 100%), radial-gradient(ellipse at top left, rgba(13, 110, 253, 0.5), #0000 50%), radial-gradient(ellipse at top right, rgba(255, 228, 132, 0.5), #0000 50%), radial-gradient(ellipse at center right, rgba(112.520718, 44.062154, 249.437, 0.5), #0000 50%), radial-gradient(ellipse at center left, rgba(214, 51, 132, 0.5), #0000 50%)

</style>
