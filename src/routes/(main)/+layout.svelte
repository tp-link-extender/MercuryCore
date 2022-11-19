<script lang="ts">
	import { page } from "$app/stores"
	import { handleSession } from "@lucia-auth/sveltekit/client"
	import Navbar from "../../components/navbar.svelte"
	import "/src/bootstrap.sass"
	import "/src/global.sass"

	handleSession(page)
</script>

<Navbar />

<div id="all">
	<div id="bg" class="position-fixed" />
	<main>
		<slot />
	</main>

	<footer class="position-relative text-center">
		<br />
		<a class="light-text h4" href="/">Mercury</a>
		<p class="info text-muted">
			© Mercury 2022 - All rights reserved, we are not affiliated with Roblox Corporation.<br />
		</p>
		<a class="light-text h5" href="/rules">Rules</a>
		<a class="light-text h5" href="/about">About</a>
		<a class="light-text h5" href="/terms">Terms of Service</a>
		<a class="light-text h5" href="/privacy">Privacy Policy</a>
		<a class="light-text h5" href="/statistics">Statistics</a>
	</footer>
	<noscript>
		<div id="nojs" class="position-fixed bottom-0 d-block">
			<p class="light-text text-center">Javascript is disabled. You may have a diminished experience while using Mercury.</p>
		</div>
	</noscript>
</div>

<style lang="sass">
	#all
		overflow-y: hidden
		height: 100%
		main
			min-height: 65vh
			margin-top: 10vh
			margin-bottom: 5vh

	#bg
		background-color: var(--background)
		min-height: 100vh
		height: 100%
		width: 100%
		z-index: -1
		
	footer
		background: rgba(0, 0, 0, 0.15)
		height: 20vh
		width: 100vw
		padding: 1vh
		.info
			margin-bottom: 1.75rem

		a 
			margin: 0 0.5rem
			text-decoration: none
			&:hover
				text-decoration: underline

	#nojs
		width: 100vw
		background: rgba(0, 0, 0, 0.5)
		transform: translate(0px, 1rem)
</style>
