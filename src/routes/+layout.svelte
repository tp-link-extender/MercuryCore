<script lang="ts">
	import { page, navigating } from "$app/stores"
	import Loading from "$lib/components/Loading.svelte"
	import { fade } from "svelte/transition"
	import { handleSession, getUser } from "@lucia-auth/sveltekit/client"

	import "/src/global.sass"
	import "/src/bootstrap.scss"
	import "/src/fa/sass/fontawesome.sass"
	import "/src/fa/sass/regular.sass"
	import "/src/fa/sass/solid.sass"

	handleSession(page)
	const user = getUser()
	console.log($user?.theme)
</script>

<slot />

{#if $navigating}
	<div class="position-fixed bottom-0 end-0 m-4" in:fade={{ duration: 1500, delay: 100 }} out:fade={{ duration: 100 }}>
		<h1 class="light-text overflow-hidden">
			<Loading />
		</h1>
	</div>
{/if}

{#if $user?.theme == "darken"}
	<style lang="sass">
		@use "../themes/darken.sass"
	</style>
{:else}
	<style lang="sass">
		@use "../themes/standard.sass"
	</style>
{/if}
