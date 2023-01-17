<script lang="ts">
	import { fly } from "svelte/transition"
	import Pagepart from "$lib/components/Pagepart.svelte"
	import { Parallax, ParallaxLayer } from "svelte-parallax"

	let top: HTMLElement
	let first: HTMLElement
	let scrollY: number

	function downScroll() {
		first.scrollIntoView({ behavior: "smooth" })
	}
	function upScroll() {
		top.scrollIntoView({ behavior: "smooth" })
	}
</script>

<svelte:window bind:scrollY />
<svelte:head>
	<title>About - Mercury</title>
</svelte:head>

<div bind:this={top} class="position-relative top-0" />

<div id="info" class="z-3 container d-flex flex-column justify-content-center align-items-center position-relative">
	<h1 id="title" class="fw-bolder text-white z-3">Mercury 2</h1>
	<p class="lead text-white text-center">Endless possibilities. New features. Same nostalgia.</p>
</div>

<button id="arrow" class="btn position-absolute start-50" on:click={downScroll} on:keypress={downScroll}>
	<i class="fa-solid light-text fa-chevron-down title" />
</button>
<button id="arrow2" class="btn position-fixed mb-3" on:click={upScroll} on:keypress={upScroll} style="opacity: {(scrollY - 500) / 300}">
	<i class="fa-solid light-text fa-circle-chevron-up title" />
</button>

<div bind:this={first} />

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart>
			<img class="w-100" src="/about/devices.webp" alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={0} rate={-2}>
		<Pagepart right>
			<div class="w-100">
				<h1 class="fw-bolder fw-light light-text w-100">Next-generation technologies</h1>
				<h4 class="light-text w-100">No revival even comes close as a rival.</h4>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart>
			<div class="w-100">
				<h1 class="fw-bolder fw-light light-text w-100">Lots of clients</h1>
				<h4 class="light-text w-100">Ranging from 1887 to 2087.</h4>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={-2}>
		<Pagepart right>
			<img class="w-100" src="/about/devices.webp" alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart>
			<img class="w-100" src="/about/devices.webp" alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={0} rate={-2}>
		<Pagepart right>
			<h1 class="fw-bolder fw-light light-text w-100">Approximately 60,000 better than Polygon</h1>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart>
			<h1 class="fw-bolder fw-light light-text w-100">Better website, too</h1>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={-2}>
		<Pagepart right>
			<img class="w-100" src="/about/devices.webp" alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Pagepart fullwidth>
	<div in:fly={{ x: -300, duration: 1000 }}>
		<img class="w-100" src="/about/devices.webp" alt="Devices playing Mercury" />
		<h1 class="fw-bolder fw-light light-text w-100 text-center">Includes Web3 Technology.</h1>
	</div>
	<div class="px-5" />
	<div in:fly={{ x: 300, duration: 1000 }}>
		<img class="w-100" src="/about/devices.webp" alt="Devices playing Mercury" />
		<h1 class="fw-bolder fw-light light-text w-100 text-center">It's on the BalochChain.</h1>
	</div>
</Pagepart>

<style lang="sass">
	#info
		height: 70vh

	#title
		font-size: 4rem
	#arrow
		font-size: 3rem
		margin-top: 5vh
		transform: translateX(-50%)
		z-index: 3

	#arrow2
		font-size: 2rem
		right: 0
		bottom: 0
		z-index: 3

	h1, h4
		text-align: center
</style>
