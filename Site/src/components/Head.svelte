<script lang="ts">
	let {
		name,
		title,
		description = "",
		ogImage = ""
	}: {
		name: string
		title?: string
		description?: string
		ogImage?: string
	} = $props()

	let t = $derived(title || name)
</script>

<svelte:head>
	<title>{t} - {name}</title>
	{#if description}
		<meta name="description" content={description} />
	{/if}
	{#if ogImage}
		<meta property="og:image" content={ogImage} />
	{/if}
</svelte:head>
