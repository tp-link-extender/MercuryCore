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
			margin-bottom: -6px

	#bg
		background-color: var(--background)
		min-height: 100vh
		height: 100%
		width: 100%
		z-index: -1

	#nojs
		width: 100vw
		background: rgba(0, 0, 0, 0.5)
		transform: translate(0px, 1rem)
</style>
