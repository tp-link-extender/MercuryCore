<script lang="ts">
	import { Parallax, ParallaxLayer } from "svelte-parallax"

	let top: HTMLElement
	let first: HTMLElement
	let scrollY: number

	const downScroll = () => first.scrollIntoView({ behavior: "smooth" })
	const upScroll = () => top.scrollIntoView({ behavior: "smooth" })
</script>

<!-- Keeps the scrollY variable updated with the scrollY property of the window. -->
<svelte:window bind:scrollY />
<svelte:head>
	<meta
		name="description"
		content="About Mercury: Endless possibilities. New features. Same nostalgia." />
	<title>About - Mercury</title>
</svelte:head>

<div bind:this={top} id="top" class="position-relative top-0" />

<div
	id="info"
	class="container d-flex flex-column justify-content-center align-items-center position-relative">
	<h1 id="title" class="fw-bolder light-text">Mercury 2</h1>
	<p class="lead light-text text-center">
		Endless possibilities. New features. Same nostalgia.
	</p>
	<h2 class="h5">
		<span class="badge text-bg-secondary dark-text opacity-75 mb-3">
			Closed Beta
		</span>
	</h2>
</div>

<button
	id="arrow"
	class="btn position-absolute shadow-none start-50"
	aria-label="Scroll down"
	on:click={downScroll}
	on:keypress={downScroll}
	style="opacity: {(500 - scrollY) / 300}">
	<i class="fa light-text fa-chevron-down title" />
</button>
<button
	id="arrow2"
	class="btn position-fixed mb-3"
	aria-label="Scroll up"
	on:click={upScroll}
	on:keypress={upScroll}
	style="opacity: {(scrollY - 500) / 300}">
	<i class="fa light-text fa-circle-chevron-up title" />
</button>

<div bind:this={first} id="first" />

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart>
			<div class="w-100">
				<h1 class="fw-bolder fw-light light-text w-100">
					Endless possibilities
				</h1>
				<h4 class="light-text w-100">
					On Mercury 2, you can create games for others to play, or
					shirts and pants for people to buy and wear. You can
					customise your character to your heart's content with a vast
					selection of items on the catalog.
				</h4>
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
				<h1 class="fw-bolder fw-light light-text w-100">
					New features
				</h1>
				<h4 class="light-text w-100">
					Mercury 2 has an even better website experience - easy to
					use and even more feature-packed than the previous website.
				</h4>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="fw-bolder fw-light light-text w-100">
					Same nostalgia.
				</h1>
				<h4 class="light-text w-100">
					We ensure the clients are as vanilla as possible so that you
					remember the client as it was back then.
				</h4>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="fw-bolder fw-light light-text w-100">
					Professional developers and community outreach.
				</h1>
				<h4 class="light-text w-100">
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
				</h4>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart fullwidth>
			<div class="w-100">
				<h1 class="fw-bolder fw-light light-text w-100">
					Why Mercury 2?
				</h1>
				<h4 class="light-text w-100">
					Mercury 2 provides a simple yet elegant website, with an
					unique client and a forum, so you can communicate with your
					friends
					<br />
					- or make new ones!
				</h4>
			</div>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<div
				id="info"
				class="container d-flex flex-column justify-content-center align-items-center position-relative">
				<h1 id="title" class="fw-bolder light-text">Mercury 2</h1>
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

	#title
		font-size 4rem
	#arrow
		font-size 3rem
		margin-top 5vh
		transform translateX(-50%)
		z-index 3

	#arrow2
		font-size 2rem
		right 0
		bottom 0
		z-index 3

	h1, h4
		text-align center
</style>
