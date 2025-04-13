<script lang="ts">
	interface Props {
		name: string;
		title?: any;
		description?: string;
		ogImage?: string;
	}

	let {
		name,
		title = name,
		description = "",
		ogImage = ""
	}: Props = $props();
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
