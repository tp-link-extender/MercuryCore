<script lang="ts">
	// import { Canvas } from "@threlte/core"
	import Head from "$components/Head.svelte"
	import fade from "$lib/fade"
	// import Cubes from "./Cubes.svelte"
	import Libraries from "./Libraries.svelte"
	import Padlock from "./Padlock.svelte"
	import Pagepart from "./Pagepart.svelte"
	import Screenshots from "./Screenshots.svelte"

	const { data } = $props()

	let top: HTMLElement
	let first: HTMLElement
	let scrollY = $state(0)

	const range = (n: number) =>
		Array.from({ length: n }, (_, index) => -Math.floor(n / 2) + index)

	const columns = range(37)
	const rows = range(19)

	const downScroll = () => first.scrollIntoView({ behavior: "smooth" })
	const upScroll = () => top.scrollIntoView({ behavior: "smooth" })

	let cubesMoved = 0
	let cubesClicked = 0
	let completed = $state(false)

	let cubePercentage = $derived(
		Math.floor((cubesMoved / (columns.length * rows.length)) * 100)
	)
	let cubePercentage2 = $derived(
		Math.floor((cubesClicked / (columns.length * rows.length)) * 100)
	)

	$effect(() => {
		if (cubePercentage >= 100 && cubePercentage2 >= 100) {
			completed = true
			window.open("https://youtube.com/watch?v=cvh0nX08nRw", "_blank")
		}
	})
</script>

<Head
	name={data.siteName}
	title="About"
	description="About {data.siteName}{data.longTagline
		? `: ${data.longTagline}`
		: ''}" />

<svelte:window bind:scrollY />

<!-- todo test -->
<!-- <div id="cubes" class="absolute h-full w-full -mt-5vh">
	<Canvas>
		<Cubes
			{columns}
			{rows}
			onmoved={() => cubesMoved++}
			onclicked={() => cubesClicked++} />
	</Canvas>
</div> -->

<div bind:this={top} id="top" class="absolute top-0"></div>

<Pagepart
	class="cubes {cubePercentage < 20 ? 'pb-60' : 'pb-[calc(15rem+70vh)]'}">
	{#if cubePercentage < 20}
		<div
			out:fade
			class="pointer-events-none flex flex-col justify-center items-center relative h-70vh">
			<h1 class="text-16 font-bold">{data.siteName}</h1>
			{#if data.longTagline}
				<p>{data.longTagline}</p>
			{/if}
			{#if data.tagline}
				<h3
					class="p-3 py-1 rounded-2 font-bold text-lg! bg-neutral-5 opacity-75">
					{data.tagline}
				</h3>
			{/if}
		</div>
	{:else}
		<div
			in:fade={{ delay: 500 }}
			class="pointer-events-none absolute top-1/2 left-1/2 translate--1/2 flex flex-col items-center">
			{#if completed}
				<h1
					in:fade
					class="font-bold pointer-events-none text-white opacity-75">
					lmao%
				</h1>
			{:else}
				<h1
					in:fade
					class="font-bold pointer-events-none text-white opacity-75">
					{cubePercentage}%
				</h1>
				{#if cubePercentage2 > 0}
					<h1
						in:fade
						class="font-bold pointer-events-none text-red-5 opacity-75">
						{cubePercentage2}%
					</h1>
				{/if}
				{#if cubePercentage >= 60 && cubePercentage < 80}
					<h3
						class="font-bold pointer-events-none text-white opacity-75">
						zoom out
					</h3>
				{:else if cubePercentage === 100 && cubePercentage2 < 2}
					<h3
						class="font-bold pointer-events-none text-red-5 opacity-75">
						click the cubes
					</h3>
				{/if}
			{/if}
		</div>
	{/if}

	<div class="absolute left-1/2 top-4/5 translate-x--1/2">
		<button
			class="btn light-text left-1/2 text-3rem z-3"
			aria-label="Scroll down"
			onclick={downScroll}
			onkeypress={downScroll}
			style="opacity: {(500 - scrollY) / 300}">
			↓
		</button>
	</div>
	<button
		class="btn light-text fixed pb-4 bottom-0 right-0 z-10 text-2rem"
		aria-label="Scroll up"
		onclick={upScroll}
		onkeypress={upScroll}
		style="opacity: {(scrollY - 500) / 300}">
		<fa fa-circle-chevron-up></fa>
	</button>
</Pagepart>

<div bind:this={first} id="first"></div>

<Pagepart class="px-12 mx-auto <lg:pb-50">
	<div class="lg:flex gap-6 items-center">
		<div class="lg:max-w-150">
			<h2>A refurbished experience</h2>
			<h3>New features.</h3>
			<p>
				{data.siteName} aims to be the foremost platform of its kind, and
				the {data.siteName} website plays a prominent part in this. After
				years of testing, tinkering, and tweaking, we've landed on a stack
				that combines rock-solid stability with a flexible foundation for
				the future.
			</p>
			<h3>Limitless possibilities.</h3>
			<p>
				{data.siteName} provides everything you would expect from a modern
				revival platform and then some:
			</p>
			<ul>
				<li>An expansive catalog for character customisation</li>
				<li>An innovative, robust, and intuitive user interface</li>
				<li>A vast variety of places and games to explore</li>
				<li>
					And communication features that help foster a sense of
					connection and community within {data.siteName}.
				</li>
			</ul>
			<h3>Same nostalgia.</h3>
			<p>
				{data.siteName} still uses the exact same client as the previous
				2 iterations. Our philosophy when it comes to our client is to make
				sure that it is accurately represented. The end-goal with our client
				is to implement every feature that it originally had.
			</p>
		</div>
		<div class="w-full h-80 min-w-[min(40vw,40rem)] <lg:pt-50 relative">
			<Screenshots />
		</div>
	</div>
</Pagepart>

<Pagepart class="px-12 mx-auto <lg:pb-50">
	<div class="lg:flex gap-6 items-center">
		<div class="w-full h-150 min-w-100 mb--25 flex justify-center">
			<Padlock />
		</div>
		<div class="lg:max-w-180">
			<h2>Security and privacy</h2>
			<h3>Data protection</h3>
			<p>
				We take the security and privacy of our users very seriously. No
				identifying information is stored on our servers, and no data is
				shared with third parties.
			</p>
			<h3>Vulnerability management</h3>
			<p>
				Careful technology choices ensure that {data.siteName} isn't vulnerable
				to the same attacks that plague similar platforms. We're constantly
				monitoring and updating our systems to ensure that users are safe
				&ndash; and a streamlined reporting system allows us to respond to
				any security concerns quickly and effectively.
			</p>
		</div>
	</div>
</Pagepart>

<Pagepart class="px-12 mx-auto <lg:pb-50">
	<div class="lg:flex gap-6 items-center">
		<div class="lg:max-w-300">
			<h2>Transparency and trust</h2>
			<div class="grid grid-cols-2 gap-6">
				<div>
					<h3>Professional developers</h3>
					<p>
						A group of experienced developers are behind {data.siteName},
						and we're committed to improving user experience and
						security. We aim to remain transparent and open about
						our development process and decisions.
					</p>
				</div>
				<div>
					<h3>Community outreach</h3>
					<p>
						Our team of testers contribute extensively to the
						platform's development and direction, and we're always
						open to feedback and suggestions from the community.
					</p>
				</div>
			</div>
		</div>
	</div>
</Pagepart>

<Pagepart class="px-12 mx-auto pb-100">
	<div class="lg:flex gap-6 items-center">
		<div class="w-full h-140 min-w-[min(40vw,40rem)] <lg:mb--20 relative">
			<Libraries />
		</div>
		<div class="lg:max-w-150 <lg:pt-60">
			<h2>Development experience</h2>
			<h3>Library usage</h3>
			<p>
				We put a strong emphasis on library usage to improve development
				speed and maintainability. {data.siteName} is the first revival platform
				to utilise modern libraries and frameworks backported from contemporary
				Lua, Luau, and JavaScript ecosystems.
			</p>
			<h3>Optimisation and stability</h3>
			<p>
				{data.siteName} makes use of techniques borrowed from modern game
				development to boost performance and reduce latency. Our optimisations
				have already been proven to improve user experience &ndash; for example,
				place joining on {data.siteName} is 30-40% faster than competing
				platforms.
			</p>
		</div>
	</div>
</Pagepart>

<Pagepart class="pb-60">
	<div class="flex flex-col justify-center items-center relative">
		<h1 class="text-16 font-bold">{data.siteName}</h1>
		{#if data.longTagline}
			<p>{data.longTagline}</p>
		{/if}
		{#if !data.user}
			<a
				type="button"
				href="/register"
				class="btn btn-sm btn-primary inline no-underline">
				<b>Register</b>
				→
			</a>
		{/if}
	</div>
</Pagepart>

<style>
	:not(.cubes) {
		& h2 {
			font-size: 2.6rem;
			padding-bottom: 1rem;
			font-weight: 600;
			text-decoration: underline #8b52ff;
		}
		& h3 {
			font-size: 1.5rem;
		}
	}
	p {
		padding-left: 1rem;
	}
	p,
	ul {
		font-size: 1.35rem;
		font-weight: 330;
		@apply text-neutral-3;
	}
</style>
