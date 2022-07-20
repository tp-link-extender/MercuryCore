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

<svelte:head>
	<title>Error {status} - Mercury</title>
</svelte:head>

<div id="all">
	<div id="info" class="container d-flex flex-column justify-content-center align-items-center light-text">
		<h1 class="light-text">Error {status}</h1>
		{error["message"]}
	</div>
</div>

<style lang="sass">
	#all
		padding: 25vh 0

	#info
		background: var(--accent2)
		width: fit-content
		padding: 2rem 5rem
		border-radius: 1rem
</style>
