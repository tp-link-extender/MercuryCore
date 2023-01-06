<script lang="ts">
	import { page } from "$app/stores"
	import { handleSession } from "@lucia-auth/sveltekit/client"
	import * as bootstrap from "bootstrap"
	import Navbar from "$lib/components/Navbar.svelte"
	import "/src/global.sass"
	import "/src/bootstrap.scss"

	handleSession(page)
</script>

<Navbar />
<main>
	<slot />	
</main>


<style lang="sass">
	slot	
		padding-top: 15vh
</style>
