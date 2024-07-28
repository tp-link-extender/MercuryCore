<script lang="ts">
	export let title = "Mercury"
	export let description = ""
	export let ogImage = ""
</script>

<svelte:head>
	<title>{title} - Mercury</title>
	{#if description}
		<meta name="description" content={description} />
	{/if}
	{#if ogImage}
		<meta property="og:image" content={ogImage} />
	{/if}
</svelte:head>
