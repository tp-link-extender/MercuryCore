<script lang="ts">
	import { page, navigating } from "$app/stores"
	import Loading from "$lib/components/Loading.svelte"
	import { fade } from "svelte/transition"
	import { handleSession, getUser } from "@lucia-auth/sveltekit/client"

	import "/src/global.sass"
	import "/src/bootstrap.scss"

	// Theme files contain CSS variables that are used throughout the app.
	import "/src/fa/sass/fontawesome.sass"
	import "/src/fa/sass/regular.sass"
	import "/src/fa/sass/solid.sass"

	handleSession(page)
	const user = getUser()
</script>

<svelte:head>
	<meta charset="utf-8" />
	<meta name="theme-color" content="#1f1d1c" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="/favicon.svg" />
	<link rel="manifest" href="/manifest.json" />
	<link rel="apple-touch-icon" href="/icon192.png" />

	<script
		defer
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN"
		crossorigin="anonymous"></script>
</svelte:head>

<slot />

<!-- While a page is loading, a loading spinner can be shown -->
{#if $navigating}
	<div
		class="position-fixed bottom-0 end-0 m-4"
		in:fade={{ duration: 1500, delay: 100 }}
		out:fade={{ duration: 100 }}>
		<h1 class="light-text overflow-hidden">
			<Loading />
		</h1>
	</div>
{/if}

{#if $user?.theme == "darken"}
	<style lang="sass">
		@use "../themes/darken.sass"
	</style>
{:else if $user?.theme == "storm"}
	<style lang="sass">
		@use "../themes/storm.sass"
	</style>
{:else if $user?.theme == "solar"}
	<style lang="sass">
		@use "../themes/solar.sass"
	</style>
{:else}
	<style lang="sass">
		@use "../themes/standard.sass"
	</style>
{/if}
