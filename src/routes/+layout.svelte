<script lang="ts">
	import { page, navigating } from "$app/stores"
	import nprogress from "nprogress"

	import "/src/nprogress.sass"
	import "/src/global.sass"

	// Theme files contain CSS variables that are used throughout the app.
	import "/src/fa/sass/fontawesome.sass"
	import "/src/fa/sass/regular.sass"
	import "/src/fa/sass/solid.sass"

	export let data
	const user = data.user

	// Settings for nprogress, the loading bar shown
	// at the top of the page when navigating
	nprogress.configure({ showSpinner: false })

	let timeout: any
	// 100ms is the minimum time the loading bar will be shown
	$: if ($navigating && !timeout) timeout = setTimeout(nprogress.start, 100)
	else {
		clearTimeout(timeout)
		timeout = null

		nprogress.done()
	}
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
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N"
		crossorigin="anonymous"></script>
</svelte:head>

<slot />

<!-- <div class="toast-container position-fixed bottom-0 end-0 p-3">
	9999
	<div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
		<div class="toast-header">
			<img src="..." class="rounded me-2" alt="..." />
			<strong class="me-auto">Bootstrap</strong>
			<small class="text-body-secondary">just now</small>
			<button
				type="button"
				class="btn-close"
				data-bs-dismiss="toast"
				aria-label="Close" />
		</div>
		<div class="toast-body">See? Just like this.</div>
	</div>

	<div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
		<div class="toast-header">
			<img src="..." class="rounded me-2" alt="..." />
			<strong class="me-auto">Bootstrap</strong>
			<small class="text-body-secondary">2 seconds ago</small>
			<button
				type="button"
				class="btn-close"
				data-bs-dismiss="toast"
				aria-label="Close" />
		</div>
		<div class="toast-body">Heads up, toasts will stack automatically</div>
	</div>
</div> -->

{#if user?.theme == "darken"}
	<style lang="sass">
		@use "../themes/darken.sass"
	</style>
{:else if user?.theme == "storm"}
	<style lang="sass">
		@use "../themes/storm.sass"
	</style>
{:else if user?.theme == "solar"}
	<style lang="sass">
		@use "../themes/solar.sass"
	</style>
{:else}
	<style lang="sass">
		@use "../themes/standard.sass"
	</style>
{/if}
