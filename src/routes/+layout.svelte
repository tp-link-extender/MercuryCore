<script lang="ts">
	import { page } from "$app/stores"
	import { handleSession } from "@lucia-auth/sveltekit/client"
	import Navbar from "$lib/components/Navbar.svelte"
	import "/src/bootstrap.sass"
	import "/src/global.sass"

	handleSession(page)
</script>

<Navbar />

<main>
	<slot />
</main>

<style lang="sass">
	main
		overflow: hidden
		background-color: var(--background)
		padding-top: 10vh
</style>
