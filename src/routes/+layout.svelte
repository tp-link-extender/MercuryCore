<script lang="ts">
	import { page } from "$app/stores"
	import { handleSession } from "@lucia-auth/sveltekit/client"
	import "/src/global.sass"
	import "/src/bootstrap.scss"

	handleSession(page)
</script>

<slot />
