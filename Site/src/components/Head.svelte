<script lang="ts">
	const {
		name,
		title = name,
		description = "",
		ogImage = ""
	}: {
		name: string
		title?: string
		description?: string
		ogImage?: string
	} = $props()
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
