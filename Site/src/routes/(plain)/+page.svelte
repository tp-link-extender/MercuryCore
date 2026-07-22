<script lang="ts">
	import { Canvas } from "@threlte/core"
	import { Gradient } from "stripe-gradient"
	import { onMount } from "svelte"
	import Head from "$components/Head.svelte"
	import Moon from "./Moon.svelte"
	import Waves from "./Waves.svelte"
	
	// Gradient must run upon page being loaded, and cannot be rendered on serverside.
	let canvasOpacity = $state(0)
	let infoPadding = $state(50)
	let infoTextMargin = $state(-30)

	onMount(() => {
		new Gradient().initGradient("#gradientcanvas")
		// fade gradient and moon in
		canvasOpacity = 1
		infoPadding = 30
		infoTextMargin = 0
	})

	const { data } = $props()
</script>

<Head
	name={data.siteName}
	title="{data.siteName}: Endless possibilities. New features. Same nostalgia."
	description="{data.siteName}: Endless possibilities. New features. Same nostalgia."
	ogImage="/mercury.gif" />

<div id="gradientbg" class="w-full h-full fixed"></div>

<canvas
	id="gradientcanvas"
	class="w-full h-full fixed"
	style="opacity: {canvasOpacity}">
</canvas>

<Waves reverse />

<div
	id="info"
	class="ctnr flex justify-center items-center h-75vh"
	style="padding-top: {infoPadding}vh">
	<div
		id="moon"
		class="absolute w-full h-20vh"
		style="opacity: {canvasOpacity}">
		<Canvas>
			<Moon />
		</Canvas>
	</div>
	<div
		id="infotext"
		class="flex flex-col justify-center items-center relative"
		style="padding-top: {infoTextMargin}vh">
		<h1 class="font-bold opacity-75 text-16">{data.siteName}</h1>
		<p class="lead text-center">
			Endless possibilities. New features. Same nostalgia.
		</p>
		<div class="inline pb-2">
			<a
				type="button"
				href="/login"
				class="inline btn btn-sm btn-secondary">
				<b>Login</b>
				<fa fa-right-to-bracket class="pl-1"></fa>
			</a>
			<a
				type="button"
				href="/register"
				class="inline btn btn-sm btn-primary">
				<b>Register</b>
				<fa fa-plus class="pl-1"></fa>
			</a>
		</div>
		<a href="/about" class="btn btn-sm btn-tertiary">
			About us
			<fa fa-circle-question class="pl-1"></fa>
		</a>
	</div>
</div>

<style>
	canvas,
	#gradientbg {
		--gradient-color-1: #161a92;
		--gradient-color-2: #2b0574;
		--gradient-color-3: #6c2fb9;
		--gradient-color-4: #060e25;
	}

	canvas,
	#moon {
		transition: opacity 0.75s ease-in;
	}

	#gradientbg {
		background: linear-gradient(
			25deg,
			var(--gradient-color-2),
			var(--gradient-color-4),
			var(--gradient-color-1),
			var(--gradient-color-3)
		);
	}

	#info,
	#infotext {
		transition: padding-top 1s ease-in-out;
	}

	#moon {
		margin-bottom: 22rem;
	}
</style>
