<script lang="ts">
	export let name: string
	export let title = name
	export let description = ""
	export let ogImage = ""
</script>

<svelte:head>
	<title>{title} - {name}</title>
	{#if description}
		<meta name="description" content={description} />
	{/if}
	{#if ogImage}
		<meta property="og:image" content={ogImage} />
	{/if}
</svelte:head>
