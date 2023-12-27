<script lang="ts">
	import { Parallax, ParallaxLayer } from "svelte-parallax"
	import { Canvas } from "@threlte/core"
	import Cubes from "./Cubes.svelte"
	import Pagepart from "./Pagepart.svelte"

	let top: HTMLElement, first: HTMLElement, scrollY: number

	const range = (n: number) =>
		Array.from({ length: n }, (_, index) => -Math.floor(n / 2) + index)

	const downScroll = () => first.scrollIntoView({ behavior: "smooth" }),
		upScroll = () => top.scrollIntoView({ behavior: "smooth" }),
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

<div id="cubes" class="absolute h-full w-full">
	<Canvas>
		<Cubes
			{columns}
			{rows}
			on:moved={() => cubesMoved++}
			on:clicked={() => cubesClicked++} />
	</Canvas>
</div>

<div bind:this={top} id="top" class="absolute top-0" />

<Pagepart fullwidth>
	{#if cubePercentage < 20}
		<div
			out:fade
			id="info"
			class="ctnr pointer-events-none flex flex-col justify-center
			items-center relative">
			<h1 class="title font-black">Mercury 2</h1>
			<p class="text-base light-text text-center">
				Endless possibilities. New features. Same nostalgia.
			</p>
			<h2
				class="p-2 py-1 rounded-3 font-bold text-base
				bg-secondary text-light opacity-75">
				Closed Beta
			</h2>
		</div>
	{:else}
		<div
			in:fade={{ delay: 500 }}
			id="cubesMoved"
			class="pointer-events-none absolute top-1/2 left-1/2 -translate-1/2">
			{#if completed}
				<h1
					in:fade
					class="pointer-events-none text-white opacity-75 font-black">
					lmao%
				</h1>
			{:else}
				<h1
					in:fade
					class="pointer-events-none text-white opacity-75 font-black">
					{cubePercentage}%
				</h1>
				{#if cubePercentage2 > 0}
					<h1
						in:fade
						class="pointer-events-none text-danger opacity-75 font-black">
						{cubePercentage2}%
					</h1>
				{/if}
				{#if cubePercentage >= 60 && cubePercentage < 80}
					<h2
						class="pointer-events-none text-white opacity-75 font-black">
						zoom out
					</h2>
				{:else if cubePercentage == 100 && cubePercentage2 < 2}
					<h2
						class="pointer-events-none text-danger opacity-75 font-black">
						click the cubes
					</h2>
				{/if}
			{/if}
		</div>
	{/if}

	<div id="arrowcontainer">
		<button
			id="arrow"
			class="btn absolute shadow-none left-1/2 light-text"
			aria-label="Scroll down"
			on:click={downScroll}
			on:keypress={downScroll}
			style="opacity: {(500 - scrollY) / 300}">
			<fa fa-chevron-down />
		</button>
	</div>
	<button
		id="arrow2"
		class="btn fixed pb-4 light-text"
		aria-label="Scroll up"
		on:click={upScroll}
		on:keypress={upScroll}
		style="opacity: {(scrollY - 500) / 300}">
		<fa fa-circle-chevron-up />
	</button>
</Pagepart>

<div bind:this={first} id="first" />

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart>
			<div class="w-full">
				<h1 class="font-black w-full">Endless possibilities</h1>
				<h3 class=" light-text w-full">
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
				class="w-full"
				src="/about_assets/devices.webp"
				alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={2}>
		<Pagepart fullwidth>
			<div class="w-full">
				<h1 class="font-black w-full">New features</h1>
				<h3 class="w-full">
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
			<div class="w-full">
				<h1 class="font-black w-full">Same nostalgia.</h1>
				<h3 class="w-full">
					We ensure the clients are as vanilla as possible so that you
					remember the client as it was back then.
				</h3>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<div class="w-full">
				<h1 class="font-black w-full">
					Professional developers and community outreach.
				</h1>
				<h3 class="w-full">
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
			<div class="w-full">
				<h1 class="font-black w-full">Why Mercury 2?</h1>
				<h3 class="w-full">
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
				class="ctnr flex flex-col justify-center
				items-center relative">
				<h1 class="title font-black">Mercury 2</h1>
				<p class="lead light-text text-center">
					Endless possibilities. New features. Same nostalgia.
				</p>
				<b>
					<a
						type="button"
						href="/register"
						class="inline btn btn-sm btn-success no-underline">
						Register <fa fa-chevron-right />
					</a>
				</b>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<style lang="stylus">
	#info
		height 70vh

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
		font-size 3rem

	h1
	h3
		text-align center

	#cubes
		margin-top -5vh
</style>
