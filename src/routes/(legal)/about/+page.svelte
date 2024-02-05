<script lang="ts">
	import { Canvas } from "@threlte/core"
	import Cubes from "./Cubes.svelte"
	import Pagepart from "./Pagepart.svelte"

	let top: HTMLElement, first: HTMLElement, scrollY: number

	const range = (n: number) =>
		Array.from({ length: n }, (_, index) => -Math.floor(n / 2) + index)

	const downScroll = () => first.scrollIntoView({ behavior: "smooth" })
	const upScroll = () => top.scrollIntoView({ behavior: "smooth" })
	const columns = range(37)
	const rows = range(19)

	let cubesMoved = 0
	let cubesClicked = 0
	let completed = false

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

<div id="cubes" class="absolute h-full w-full -mt-5vh">
	<Canvas>
		<Cubes
			{columns}
			{rows}
			on:moved={() => cubesMoved++}
			on:clicked={() => cubesClicked++} />
	</Canvas>
</div>

<div bind:this={top} id="top" class="absolute top-0" />

<Pagepart>
	{#if cubePercentage < 20}
		<div
			out:fade
			id="info"
			class="pointer-events-none flex flex-col justify-center
			items-center relative h-70vh">
			<h1 class="text-16 font-bold">Mercury 2</h1>
			<p class="text-base light-text text-center">
				Endless possibilities. New features. Same nostalgia.
			</p>
			<h2
				class="p-2 py-1 rounded-2 font-bold text-base
				bg-neutral-5 opacity-75">
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
					class="sf font-bold pointer-events-none text-white opacity-75">
					lmao%
				</h1>
			{:else}
				<h1
					in:fade
					class="sf font-bold pointer-events-none text-white opacity-75">
					{cubePercentage}%
				</h1>
				{#if cubePercentage2 > 0}
					<h1
						in:fade
						class="sf font-bold pointer-events-none text-red-5 opacity-75">
						{cubePercentage2}%
					</h1>
				{/if}
				{#if cubePercentage >= 60 && cubePercentage < 80}
					<h2
						class="sf font-bold pointer-events-none text-white opacity-75">
						zoom out
					</h2>
				{:else if cubePercentage == 100 && cubePercentage2 < 2}
					<h2
						class="sf font-bold pointer-events-none text-red-5 opacity-75">
						click the cubes
					</h2>
				{/if}
			{/if}
		</div>
	{/if}

	<div class="absolute left-1/2 top-4/5 translate-x--1/2">
		<button
			class="btn light-text left-1/2 text-3rem z-3"
			aria-label="Scroll down"
			on:click={downScroll}
			on:keypress={downScroll}
			style="opacity: {(500 - scrollY) / 300}">
			<fa fa-chevron-down />
		</button>
	</div>
	<button
		class="btn light-text fixed pb-4 bottom-0 right-0 z-10 text-2rem"
		aria-label="Scroll up"
		on:click={upScroll}
		on:keypress={upScroll}
		style="opacity: {(scrollY - 500) / 300}">
		<fa fa-circle-chevron-up />
	</button>
</Pagepart>

<div bind:this={first} id="first" />

<Pagepart class="px-12 max-w-350 mx-auto">
	<div class="grid lg:grid-cols-2 gap-6 items-center">
		<div>
			<h1>The ultimate experience</h1>
			<h2>Built with modern technology</h2>
			<p>
				Mercury aims to be the foremost platform of its kind, and the
				Mercury website plays a key part in this. After years of
				testing, tinkering, and tweaking, we've landed on a stack that
				combines rock-solid stability with a flexible foundation for the
				future.
			</p>
			<h2>Limitless possibilities</h2>
			<p>
				Mercury provides everything you would expect from a modern
				revival platform and then some:
			</p>
			<ul>
				<li>An expansive catalog for character customisation</li>
				<li>A robust and intuitive user interface</li>
				<li>A wide variety of games and activities</li>
				<li>
					And communication features that help foster a sense of
					connection and community within Mercury.
				</li>
			</ul>
		</div>
		<img
			src="/about_assets/screenshots.webp"
			alt="Mercury logo"
			class="w-full" />
	</div>
</Pagepart>
<Pagepart class="px-12 max-w-350 mx-auto">
	<div class="grid lg:grid-cols-2 gap-6 items-center">
		<div>
			<h1>The ultimate experience</h1>
			<h2>Built with modern technology</h2>
			<p>
				Mercury aims to be the foremost platform of its kind, and the
				Mercury website plays a key part in this. After years of
				testing, tinkering, and tweaking, we've landed on a stack that
				combines rock-solid stability with a flexible foundation for the
				future.
			</p>
			<h2>Limitless possibilities</h2>
			<p>
				Mercury provides everything you would expect from a modern
				revival platform and then some:
			</p>
			<ul>
				<li>An expansive catalog for character customisation</li>
				<li>A robust and intuitive user interface</li>
				<li>A wide variety of games and activities</li>
				<li>
					And communication features that help foster a sense of
					connection and community within Mercury.
				</li>
			</ul>
		</div>
		<img
			src="/about_assets/screenshots.webp"
			alt="Mercury logo"
			class="w-full" />
	</div>
</Pagepart>

<style lang="stylus">
	h1
		font-size 2.6rem
		padding-bottom 1rem

	p
		padding-left 1rem

	p
	ul
		@apply text-neutral-3
		font-size 1.35rem
</style>
