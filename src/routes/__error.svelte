<svelte:head>
	<title>Error {status} - Mercury</title>
</svelte:head>

<script lang="ts" context="module">
	export function load({ error, status }: { error: object; status: number }) {
		return {
			props: {
				status: status,
				error: error,
			},
		}
	}
	// copied straight from kit.svelte.dev
</script>

<script lang="ts">
	// must be 2 separate scripts
	export let status: number
	export let error: any
</script>

<div id="info" class="container d-flex flex-column justify-content-center align-items-center translate-middle top-50 start-50 position-absolute">

	<h1>Error {status}</h1>
	{error["message"]}
</div>

<style lang="sass">
	#info
		background: #fff
		width: fit-content
		padding: 2rem 5rem
		border-radius: 1rem
		box-shadow: 0 0 20px
</style>