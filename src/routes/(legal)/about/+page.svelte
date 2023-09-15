<script lang="ts">
	import { Parallax, ParallaxLayer } from "svelte-parallax"
	import { Canvas } from "@threlte/core"

	let top: HTMLElement, first: HTMLElement, scrollY: number

	const downScroll = () => first.scrollIntoView({ behavior: "smooth" }),
		upScroll = () => top.scrollIntoView({ behavior: "smooth" })

	const range = (n: number) =>
			Array.from({ length: n }, (_, index) => -Math.floor(n / 2) + index),
		columns = range(37),
		rows = range(19)

	let cubesMoved = 0,
		cubesClicked = 0,
		completed = false

	$: cubePercentage = Math.floor(
		(cubesMoved / (columns.length * rows.length)) * 100
	)
	$: cubePercentage2 = Math.floor(
		(cubesClicked / (columns.length * rows.length)) * 100
	)

	$: if (cubePercentage >= 100 && cubePercentage2 >= 100) {
		completed = true
		window.open("https://youtube.com/watch?v=cvh0nX08nRw", "_blank")
	}
</script>

<Head
	title="About"
	description="About Mercury: Endless possibilities. New features. Same nostalgia." />

<svelte:window bind:scrollY />

<div id="cubes" class="position-absolute h-100 w-100">
	<Canvas>
		<Cubes
			{columns}
			{rows}
			on:moved={() => cubesMoved++}
			on:clicked={() => cubesClicked++} />
	</Canvas>
</div>

<div bind:this={top} id="top" class="position-relative top-0" />

<Pagepart fullwidth>
	{#if cubePercentage < 20}
		<div
			out:fade
			id="info"
			class="container pe-none d-flex flex-column justify-content-center
			align-items-center position-relative">
			<h1 class="title font-black light-text">Mercury 2</h1>
			<p class="lead light-text text-center">
				Endless possibilities. New features. Same nostalgia.
			</p>
			<h2 class="fs-5">
				<span class="badge text-bg-secondary dark-text opacity-75 mb-4">
					Closed Beta
				</span>
			</h2>
		</div>
	{:else}
		<div
			id="cubesMoved"
			class="pe-none position-absolute top-50 start-50 text-center w-100">
			{#if completed}
				<h1 in:fade class="pe-none text-white opacity-75 font-black">
					lmao%
				</h1>
			{:else}
				<h1 in:fade class="pe-none text-white opacity-75 font-black">
					{cubePercentage}%
				</h1>
				{#if cubePercentage2 > 0}
					<h1
						in:fade
						class="pe-none text-danger opacity-75 font-black">
						{cubePercentage2}%
					</h1>
				{/if}
				{#if cubePercentage >= 60 && cubePercentage < 80}
					<h2 class="pe-none text-white opacity-75 font-black">
						zoom out
					</h2>
				{:else if cubePercentage == 100 && cubePercentage2 < 2}
					<h2 class="pe-none text-danger opacity-75 font-black">
						click the cubes
					</h2>
				{/if}
			{/if}
		</div>
	{/if}

	<div id="arrowcontainer">
		<button
			id="arrow"
			class="btn position-absolute shadow-none start-50"
			aria-label="Scroll down"
			on:click={downScroll}
			on:keypress={downScroll}
			style="opacity: {(500 - scrollY) / 300}">
			<i class="fa light-text fa-chevron-down" />
		</button>
	</div>
	<button
		id="arrow2"
		class="btn position-fixed mb-4"
		aria-label="Scroll up"
		on:click={upScroll}
		on:keypress={upScroll}
		style="opacity: {(scrollY - 500) / 300}">
		<i class="fa light-text fa-circle-chevron-up" />
	</button>
</Pagepart>

<div bind:this={first} id="first" />

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart>
			<div class="w-100">
				<h1 class="font-black light-text w-100">
					Endless possibilities
				</h1>
				<h3 class="fs-4 light-text w-100">
					On Mercury 2, you can create games for others to play, or
					shirts and pants for people to buy and wear. You can
					customise your character to your heart's content with a vast
					selection of items on the catalog.
				</h3>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={0} rate={-2}>
		<Pagepart right>
			<img
				class="w-100"
				src="/about_assets/devices.webp"
				alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={2}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="font-black light-text w-100">New features</h1>
				<h3 class="fs-4 light-text w-100">
					Mercury 2 has an even better website experience - easy to
					use and even more feature-packed than the previous website.
				</h3>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="font-black light-text w-100">Same nostalgia.</h1>
				<h3 class="fs-4 light-text w-100">
					We ensure the clients are as vanilla as possible so that you
					remember the client as it was back then.
				</h3>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="font-black light-text w-100">
					Professional developers and community outreach.
				</h1>
				<h3 class="fs-4 light-text w-100">
					Mercury 2 developers deliver consistent updates so your
					experience is always great.
					<br />
					In addition, we aim to fix bugs and glitches as soon as they
					are reported.
					<br />
					Community wise, Mercury 2 aims to be completely transparent and
					non-biased with decisions.
					<br />
					While other private servers proceed to initiate petty wars with
					others, we take an impartial view.
				</h3>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="font-black light-text w-100">Why Mercury 2?</h1>
				<h3 class="fs-4 light-text w-100">
					Mercury 2 provides a simple yet elegant website, with an
					unique client and a forum, so you can communicate with your
					friends
					<br />
					- or make new ones!
				</h3>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<div
				id="info"
				class="container d-flex flex-column justify-content-center align-items-center position-relative">
				<h1 class="title font-black light-text">Mercury 2</h1>
				<p class="lead light-text text-center">
					Endless possibilities. New features. Same nostalgia.
				</p>
				<b>
					<a
						type="button"
						href="/register"
						class="d-inline btn btn-sm btn-success text-decoration-none">
						Register <i class="fa fa-chevron-right" />
					</a>
				</b>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<style lang="stylus">
	#info
		height 70vh

	#top
		scroll-snap-align end
	#first
		scroll-snap-align start

	.title
		font-size 4rem

	#arrowcontainer
		padding-top 55vh
		button
			font-size 3rem
			transform translateX(-50%)
			z-index 3

	#arrow2
		font-size 2rem
		right 0
		bottom 0
		z-index 10

	h1
	h3
		text-align center

	#cubes
		margin-top -5vh

	#cubesMoved
		transform translate(-50%, -50%)
</style>
