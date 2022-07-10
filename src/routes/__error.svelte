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
	export let status: number
	export let error: any
</script>

<h1>Error {status}</h1>
{error["message"]}