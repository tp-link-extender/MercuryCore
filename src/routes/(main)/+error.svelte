<script lang="ts" context="module">
	import { page } from "$app/stores"
</script>

<svelte:head>
	<title>Error {$page.status} - Mercury</title>
</svelte:head>

<div id="all">
	<div id="info" class="container d-flex flex-column justify-content-center align-items-center light-text">
		<h1 class="light-text">Error {$page.status}</h1>
		{$page.error?.message}
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
