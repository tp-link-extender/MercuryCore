<script lang="ts">
	import { page } from "$app/stores"
	import { handleSession } from "@lucia-auth/sveltekit/client"
	import * as bootstrap from "bootstrap"
	import Navbar from "$lib/components/Navbar.svelte"
	import "/src/global.sass"

	handleSession(page)
</script>

<Navbar />

<slot />
